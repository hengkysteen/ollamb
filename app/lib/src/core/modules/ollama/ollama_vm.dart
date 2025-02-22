import 'package:get/get.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_repository.dart';
import 'ollama_model.dart';

class OllamaVm extends GetxController {
  final OllamaRepository _repository;
  OllamaVm(this._repository);

  final List<OllamaServer> servers = [];

  late OllamaServer server;

  OllamaModel? model;

  void initOllama({required List<OllamaServer> servers, required OllamaServer selectedServer}) {
    this.servers.addAll(servers);
    server = selectedServer;
    update();
  }

  void setModel(String name) {
    model = server.models.firstWhere((e) => e.name == name);
    update();
  }

  void initModel() {
    final filteredModels = server.models.where((e) => !e.name.contains("embed")).toList();
    model = filteredModels.isNotEmpty ? filteredModels.first : null;
    update();
  }

  void changeServer(String name) {
    server = servers.firstWhere((e) => e.host.name == name);
    _repository.changeServerUrl(server.host.url);
    _repository.saveSelectedHost(server.host);
    update();
    initModel();
  }

  Future<void> addServer(OllamaServer server) async {
    if (servers.any((e) => e.host.name == server.host.name)) throw Exception("Server name must be unique");
    servers.add(server);
    await _repository.saveServer(servers);
    update();
  }

  Future<void> deleteServer(OllamaServer server) async {
    if (servers.length == 1) throw Exception("Can't delete last server");
    servers.remove(server);
    await _repository.saveServer(servers);
    update();
  }

  Future<void> getModels() async {
    final data = await _repository.getModels();
    server.models = data;
    update();
  }

  Future<List<Map>> getRunningModels() async {
    return await _repository.getRunningModels();
  }

  Future<bool> checkServer() async {
    return await _repository.checkServer();
  }

  Future<void> unloadModel(String model) async {
    await _repository.ollamax!.unloadChatModel(model);
  }

  Future<void> updateSelectedHostVersion() async {
    final version = await _repository.ollamax!.version();
    if (version == null) return;
    servers.firstWhere((e) => e.host.name == server.host.name).host.version = version;
    server.host.version = version;
    _repository.saveServer(servers);
  }

  static OllamaVm get find => Get.find();
}
