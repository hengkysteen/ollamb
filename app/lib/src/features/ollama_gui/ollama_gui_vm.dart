import 'dart:io';
import 'package:get/get.dart';
import 'package:ollamax/ollamax.dart';
import 'package:ollamb/src/core/dm.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_model.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_repository.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_vm.dart';

class OllamaGuiVm extends GetxController {
  bool isExpanded = false;
  OllamaServer? selectedServer;
  List<OllamaServer> server = [];
  String addServerErrorMessage = "";
  Ollamax get _ollamax => DM.ollamaModule.ollamax;
  OllamaRepository get _ollamaRepository => DM.ollamaModule.repository;
  bool loadingModel = false;
  List<OllamaxModel> models = [];
  String selectedServerErrorMessage = "";

  void ToggleExapnded() {
    isExpanded = !isExpanded;
    update();
  }

  void removeModel(String modelName) {
    models.removeWhere((e) => e.model == modelName);
    update();
  }

  Future<void> getModels(OllamaServer? server) async {
    OllamaServer selectServer;
    loadingModel = true;
    selectServer = server ?? selectedServer!;
    update();
    try {
      _ollamaRepository.changeServerUrl(selectServer.host.url);
      final models = await _ollamax.models();
      this.models = models;
      selectedServer = selectServer;
      loadingModel = false;
      selectedServerErrorMessage = "";
    } catch (e) {
      if (selectedServer != null) {
        _ollamaRepository.changeServerUrl(selectedServer!.host.url);
      }

      selectedServerErrorMessage = parseErrorMessage(e);
      loadingModel = false;
    }
    update();
  }

  String parseErrorMessage(dynamic e) {
    if (e is SocketException || e is ClientException) {
      return "Connection refused!";
    }
    return "Something when wrong";
  }

  @override
  void onInit() async {
    selectedServer = OllamaServer(host: OllamaVm.find.server.host);
    server = OllamaVm.find.servers;
    update();
    await getModels(null);
    super.onInit();
  }

  static OllamaGuiVm get find => Get.find();
}
