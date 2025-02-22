import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamax/ollamax.dart';
import 'package:ollamb/src/core/dm.dart';

class OGuiModelCopyVm extends GetxController {
  final Ollamax ollamax = DM.ollamaModule.ollamax;
  final TextEditingController modelNameCtrl = TextEditingController();
  final TextEditingController modelTagCtrl = TextEditingController();

  String get newModelName => "${modelNameCtrl.text.trim().toLowerCase()}${modelTagCtrl.text.trim().isEmpty ? '' : ':${modelTagCtrl.text.trim()}'}";

  bool deleteOriginalModel = false;

  void toggleDeleteOriginalModel() {
    deleteOriginalModel = !deleteOriginalModel;
    update();
  }

  Future<void> copy(String model) async {
    await Future.delayed(const Duration(milliseconds: 500));
    await ollamax.copyModel(model, newModelName);

    if (deleteOriginalModel == true) {
      await ollamax.deleteModel(model);
    }
  }
}
