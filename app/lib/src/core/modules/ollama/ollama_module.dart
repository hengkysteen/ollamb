import 'package:get/get.dart';
import 'package:ollamax/ollamax.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_model.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_repository.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_storage.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_vm.dart';
import 'package:ollamb/src/services/file_service.dart';

class OllamaModule {
  final FileService _fileService;
  OllamaModule(this._fileService);
  late final Ollamax ollamax;
  late final OllamaRepository repository;

  Future<void> setup() async {
    final ollamaStorage = OllamaStorage(_fileService);
    await ollamaStorage.init();

    repository = OllamaRepository(ollamaStorage);

    final hosts = await repository.getHostFromStorage();
    final selected = await repository.getSelectedHostFromStorage();
    ollamax = Ollamax(url: selected.url, showLog: true);
    repository.ollamax = ollamax;

    Get.put(OllamaVm(repository));

    OllamaVm.find.initOllama(selectedServer: OllamaServer(host: selected), servers: hosts.map((e) => OllamaServer(host: e)).toList());

    await initModel();
  }

  Future<void> initModel() async {
    try {
      await OllamaVm.find.updateSelectedHostVersion();

      await OllamaVm.find.getModels();

      if (OllamaVm.find.server.models.isNotEmpty) {
        OllamaVm.find.initModel();
      }
    } catch (e) {
      // Error
    }
  }
}
