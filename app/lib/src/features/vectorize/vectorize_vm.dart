import 'dart:math';
import 'package:get/get.dart';
import 'package:ollamax/ollamax.dart';
import 'package:ollamb/src/features/vectorize/data/vectorize_model.dart';
import 'package:ollamb/src/features/vectorize/data/vectorize_storage.dart';

class VectorizeVm extends GetxController {
  final Ollamax _ollamax;
  final VectorizeStorage _storage;
  VectorizeVm(this._ollamax, this._storage);

  /// List of vector documents
  final List<VectorizeDocument> documents = [];

  double threshold = 0.6;

  int chunkRange = 3;

  void updateOptions({double? threshold, int? chunkRange}) {
    if (threshold != null) this.threshold = threshold;
    if (chunkRange != null) this.chunkRange = chunkRange;
    update();
  }

  void resetOptions() {
    threshold = 0.6;
    chunkRange = 3;
  }

  Future<void> createVectorDocument({required String modelEmbed, required String title, required List<String> chunks}) async {
    final id = DateTime.now().millisecondsSinceEpoch;
    final data = VectorizeDocument(id: id.toString(), title: title, model: modelEmbed, vectorize: []);
    final vectors = await embedDocument(modelEmbed, chunks);
    for (var i = 0; i < chunks.length; i++) {
      data.vectorize.add(Vectorize(id: "${id}_$i", text: chunks[i], vector: vectors[i].vector));
    }
    await _storage.add(data.toJson());
    documents.add(data);
    update();
  }

  /// Search for similar chunks in a document to the given input vector.
  ///
  /// This method calculates the cosine similarity between the input vector and each chunk in the document.
  /// Chunks with a similarity score greater than or equal to the given threshold are returned.
  /// The results are sorted by similarity in descending order and capped at the given chunk range.
  /// The method returns a map with the input text and a list of similar chunks, each containing the chunk text and similarity score.
  // Map<String, dynamic> searchSimilarity({
  //   required Vectorize input,
  //   required VectorizeDocument document,
  //   int chunkRange = 3,
  //   double threshold = 0.6,
  // }) {
  //   List<Map<String, dynamic>> similarities = [];
  //   for (var i = 0; i < document.vectorize.length; i++) {
  //     if (input.vector.isEmpty || document.vectorize[i].vector.isEmpty) {
  //       similarities.add({'chunk': document.vectorize[i].text, 'similarity': 0.0});
  //       continue;
  //     }
  //     final score = _cosineSimilarity(input.vector, document.vectorize[i].vector);
  //     if (score >= threshold) {
  //       similarities.add({
  //         'chunk': document.vectorize[i].text,
  //         'similarity': score,
  //       });
  //     }
  //   }
  //   similarities.sort((a, b) => b['similarity'].compareTo(a['similarity']));
  //   similarities = similarities.take(chunkRange).toList();
  //   return {'input': input.text, 'similarChunks': similarities};
  // }

  VectorizeResult searchSimilarity({required String model, required Vectorize input, required VectorizeDocument document, int range = 3, double threshold = 0.6}) {
    List<Similarity> similarities = [];

    for (var i = 0; i < document.vectorize.length; i++) {
      if (input.vector.isEmpty || document.vectorize[i].vector.isEmpty) {
        similarities.add(Similarity(chunk: document.vectorize[i].text, score: 0.0));
        continue;
      }

      final score = _cosineSimilarity(input.vector, document.vectorize[i].vector);
      if (score >= threshold) {
        similarities.add(Similarity(chunk: document.vectorize[i].text, score: score));
      }
    }

    similarities.sort((a, b) => b.score.compareTo(a.score));
    similarities = similarities.take(range).toList();

    return VectorizeResult(
      document: document.title,
      query: input.text,
      model: model,
      range: range,
      threshold: threshold,
      similarities: similarities,
    );
  }

  /// Calculates the cosine similarity between two vectors.
  ///
  /// The cosine similarity between two vectors is given by the dot product of the
  /// two vectors divided by the product of their magnitudes. The magnitude of a
  /// vector is the square root of the sum of the squares of its elements.
  ///
  /// The cosine similarity is a measure of how similar two vectors are. It ranges
  /// from -1 (completely different) to 1 (exactly the same). A cosine similarity
  /// of 0 indicates that the vectors are orthogonal (perpendicular).
  ///
  /// The vectors must be of the same length. If the vectors are of different
  /// lengths, an [ArgumentError] is thrown.
  double _cosineSimilarity(List<double> a, List<double> b) {
    if (a.length != b.length) throw ArgumentError("Vectors must be of the same length");
    double dotProduct = 0.0;
    double magnitudeA = 0.0;
    double magnitudeB = 0.0;
    for (int i = 0; i < a.length; i++) {
      dotProduct += a[i] * b[i];
      magnitudeA += a[i] * a[i];
      magnitudeB += b[i] * b[i];
    }
    magnitudeA = sqrt(magnitudeA);
    magnitudeB = sqrt(magnitudeB);
    if (magnitudeA == 0 || magnitudeB == 0) return 0.0;
    return dotProduct / (magnitudeA * magnitudeB);
  }

  Future<List<Vectorize>> embedDocument(String model, List<String> inputs) async {
    final Map<String, dynamic> body = {"model": model, "input": inputs, "keep_alive": 0};
    final response = await _ollamax.embed(body);
    if (response['embeddings'] is List) {
      final rawEmbeddings = response['embeddings'] as List;
      List<Vectorize> embeddings = [];
      for (var i = 0; i < rawEmbeddings.length; i++) {
        if (rawEmbeddings[i] is List) {
          final id = DateTime.now().millisecondsSinceEpoch.toString();
          final vector = (rawEmbeddings[i] as List).map((e) => e is num ? e.toDouble() : 0.0).toList();
          embeddings.add(Vectorize(id: id, text: inputs[i], vector: vector));
        } else {
          throw FormatException("Invalid embedding format for index $i");
        }
      }
      return embeddings;
    } else {
      throw const FormatException("Invalid embeddings structure in response");
    }
  }

  Future<List<double>> embedQuery(String model, String inputs) async {
    final Map<String, dynamic> body = {"model": model, "input": inputs, "keep_alive": 0};
    final data = await _ollamax.embed(body);
    if (data['embeddings'] is List && data['embeddings'][0] is List) {
      return (data['embeddings'][0] as List).map((e) => e is num ? e.toDouble() : throw FormatException("Invalid embedding value: $e")).toList();
    } else {
      throw const FormatException("Invalid embeddings structure in response");
    }
  }

  Future<void> deleteDocument(String id) async {
    await _storage.delete(id);
    documents.removeWhere((e) => e.id == id);
    update();
  }

  @override
  void onInit() async {
    final data = await _storage.getAll();
    documents.addAll(data.map((e) => VectorizeDocument.fromJson(e)).toList());
    update();
    super.onInit();
  }

  static VectorizeVm get find => Get.find();
}
