import 'dart:io';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ollamax/ollamax.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_model.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_vm.dart';

class ModelListVm extends GetxController {
  bool modelLoading = false;
  String modelLoadingError = "";
  List<OllamaModel> models = [];
  List<Map> runningModels = [];
  bool showEmbedModel = false;
  bool showRunningModel = false;

  void toggleShowEmbedModel() {
    showEmbedModel = !showEmbedModel;
    update();
    _setModels();
  }

  Future<void> getRunningModel() async {
    runningModels.clear();
    try {
      final data = await OllamaVm.find.getRunningModels();

      runningModels = data;
      showRunningModel = true;
    } catch (e) {
      //Error
    }
    update();
  }

  Future<void> unload(String model) async {
    await OllamaVm.find.unloadModel(model);
    await getRunningModel();
  }

  void _setModels() {
    models.clear();
    models = List.from(OllamaVm.find.server.models);
    if (!showEmbedModel) {
      models.removeWhere((e) => e.name.contains("embed"));
    }
    update();
  }

  Future<void> refreshModel() async {
    modelLoading = true;
    update();
    await getModels();
    await Future.delayed(const Duration(milliseconds: 300));
    modelLoading = false;
    update();
  }

  Future<void> getModels() async {
    modelLoadingError = "";
    try {
      await OllamaVm.find.getModels();
      _setModels();
    } catch (e) {
      modelLoading = false;
      if (e is SocketException || e is ClientException) {
        modelLoadingError = "Connection refused!";
      } else {
        modelLoadingError = e.toString();
      }

      update();
    }
  }

  Future<void> changeServer(OllamaHost host) async {
    modelLoading = true;
    update();
    OllamaVm.find.changeServer(host.name);
    await getModels();
    showRunningModel = false;
    modelLoading = false;
    update();
  }

  @override
  void onInit() async {
    _setModels();
    super.onInit();
  }
}
