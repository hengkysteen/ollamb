class Vectorize {
  String id;
  String text;
  List<double> vector;

  Vectorize({required this.id, required this.text, required this.vector});

  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text, 'vector': vector};
  }

  factory Vectorize.fromJson(Map<String, dynamic> json) {
    return Vectorize(id: json['id'], text: json['text'] ?? '', vector: List<double>.from(json['vector']));
  }
}

class VectorizeDocument {
  final String id;
  final String title;
  final String model;
  List<Vectorize> vectorize;

  VectorizeDocument({required this.id, required this.title, required this.model, required this.vectorize});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'model': model,
      'vectorize': vectorize.map((v) => v.toJson()).toList(),
    };
  }

  factory VectorizeDocument.fromJson(Map<String, dynamic> json) {
    return VectorizeDocument(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      model: json['model'] ?? '',
      vectorize: (json['vectorize'] as List).map((item) => Vectorize.fromJson(item)).toList(),
    );
  }
}

class VectorizeAttachment {
  final VectorizeDocument document;
  final int range;
  final double treshold;

  VectorizeAttachment({
    required this.document,
    required this.range,
    required this.treshold,
  });

  factory VectorizeAttachment.fromJson(Map<String, dynamic> json) {
    return VectorizeAttachment(
      document: VectorizeDocument.fromJson(json['document']),
      range: json['range'] as int,
      treshold: (json['treshold'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'document': document.toJson(), 'range': range, 'treshold': treshold};
  }
}

class VectorizeResult {
  final String document;
  final String query;
  final String model;
  final int range;
  final double threshold;
  final List<Similarity> similarities;

  VectorizeResult({
    required this.document,
    required this.query,
    required this.model,
    required this.range,
    required this.threshold,
    required this.similarities,
  });

  factory VectorizeResult.fromJson(Map<String, dynamic> map) {
    return VectorizeResult(
      document: map['document'] as String,
      query: map['query'] as String,
      model: map['model'] as String,
      range: map['range'] as int,
      threshold: (map['threshold'] as num).toDouble(),
      similarities: (map['similarities'] as List).map((e) => Similarity.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'document': document,
      'query': query,
      'model': model,
      'range': range,
      'threshold': threshold,
      'similarities': similarities.map((e) => e.toJson()).toList(),
    };
  }
}

class Similarity {
  final String chunk;
  final double score;

  Similarity({required this.chunk, required this.score});

  factory Similarity.fromJson(Map<String, dynamic> map) {
    return Similarity(chunk: map['chunk'] as String, score: (map['score'] as num).toDouble());
  }

  Map<String, dynamic> toJson() {
    return {'chunk': chunk, 'score': score};
  }

  @override
  String toString() => '- $chunk (Score: ${score.toStringAsFixed(2)})';
}
