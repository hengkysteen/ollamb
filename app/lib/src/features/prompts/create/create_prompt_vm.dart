import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/features/prompts/data/prompt_storage.dart';
import '../data/prompt_model.dart';

class CreatePromptVm extends GetxController {
  final PromptStorage _storage;

  CreatePromptVm(this._storage);

  String type = "user";
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController promptCtrl = TextEditingController();

  void reset() {
    nameCtrl.clear();
    promptCtrl.clear();
    update();
  }

  Future<Prompt> create() async {
    final data = Prompt(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      name: nameCtrl.text.trim(),
      prompt: promptCtrl.text.trim(),
    );
    await _storage.add(data.toJson());
    return data;
  }
}
