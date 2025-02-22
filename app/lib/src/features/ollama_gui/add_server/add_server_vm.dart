import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_model.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_repository.dart';
import 'package:ollamb/src/features/ollama_gui/ollama_gui_vm.dart';

class OllamGuiAddServerVm extends GetxController {
  final OllamaRepository ollamaRepository;

  OllamGuiAddServerVm(this.ollamaRepository);

  final TextEditingController name = TextEditingController();
  final TextEditingController url = TextEditingController();

  String serverError = "";
  String nameError = "";
  String urlError = "";

  void clearError() {
    serverError = "";
    nameError = "";
    urlError = "";
    update();
  }

  Future<void> submit(void Function(OllamaHost host) onData) async {
    clearError();

    if (name.text.trim().isEmpty && url.text.trim().isEmpty) {
      nameError = "Required";
      urlError = "Required";
      update();
      return;
    }
    if (name.text.isEmpty) {
      nameError = "Required";
      update();
      return;
    }

    if (url.text.isEmpty) {
      urlError = "Required";
      update();
      return;
    }

    ollamaRepository.changeServerUrl(url.text);
    final isok = await ollamaRepository.checkServer();
    if (isok) {
      final version = await ollamaRepository.ollamax!.version();
      onData(OllamaHost(url: url.text.trim(), name: name.text.trim().toLowerCase(), version: version ?? ""));
    } else {
      ollamaRepository.changeServerUrl(OllamaGuiVm.find.selectedServer!.host.url);
      serverError = "Connection failed. Make sure your ollama server is running.";
    }
    update();
  }
}
