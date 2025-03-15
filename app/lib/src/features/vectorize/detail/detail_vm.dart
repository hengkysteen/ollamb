import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/features/vectorize/data/vectorize_model.dart';
import 'package:ollamb/src/features/vectorize/vectorize_vm.dart';

class DocDetailVm extends GetxController {
  final VectorizeVm _embeddingsVm;
  DocDetailVm(this._embeddingsVm);
  double threshold = 0.6;
  int chunkRange = 3;
  final TextEditingController searchQueryController = TextEditingController();

  String get searchQuery => searchQueryController.text.trim();
  bool isSearch = false;
  List<Map> searchResult = [];

  void updateOptions({double? threshold, int? chunkRange}) {
    if (threshold != null) this.threshold = threshold;
    if (chunkRange != null) this.chunkRange = chunkRange;
    update();
  }

  void resetOptions() {
    threshold = 0.6;
    chunkRange = 3;
  }

  Future<void> search(VectorizeDocument doc) async {
    if (searchQueryController.text.trim().isEmpty) return;
    isSearch = true;
    update();

    await Future.delayed(const Duration(milliseconds: 200));

    final queryVector = await _embeddingsVm.embedQuery(doc.model, searchQuery);

    final input = Vectorize(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: searchQueryController.text.trim(),
      vector: queryVector,
    );

    final data = _embeddingsVm.searchSimilarity(
      model: doc.model,
      input: input,
      document: doc,
      range: chunkRange,
      threshold: threshold,
    );

    isSearch = false;
    searchResult.add({"input": searchQuery, "similarities": data.similarities.map((e) => e.toJson()).toList()});
    searchQueryController.clear();
    update();
  }
}
