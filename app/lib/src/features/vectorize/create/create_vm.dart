import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_vm.dart';
import 'package:ollamb/src/features/vectorize/data/vectorize_model.dart';

class VectorizeCreateVm extends GetxController {
  VectorizeDocument? initDocument;
  VectorizeCreateVm({this.initDocument});

  TextEditingController titleCtrl = TextEditingController();
  TextEditingController chunkCtrl = TextEditingController();
  final List<String> chunks = [];
  String? model;

  void clearChunks() {
    chunks.clear();
    update();
  }

  void reset() {
    titleCtrl.clear();
    chunks.clear();
    update();
  }

  void removeChunks(String data) {
    chunks.remove(data);
    update();
  }

  void updateChunk(int index, String data) {
    chunks[index] = data;
    update();
  }

  @override
  void onInit() {
    if (initDocument != null) {
      titleCtrl.text = initDocument!.title;
      chunks.addAll(initDocument!.vectorize.map((e) => e.text).toList());
    }
    final embedsuggest = OllamaVm.find.server.models.where((e) => e.name.contains("embed"));
    if (embedsuggest.isNotEmpty) {
      model = embedsuggest.first.name;
    }
    super.onInit();
  }
}
