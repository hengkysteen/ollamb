import 'package:ollamax/ollamax.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_model.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_storage.dart';

class OllamaRepository {
  Ollamax? ollamax;
  final OllamaStorage _storage;

  OllamaRepository(this._storage, {this.ollamax});

  void changeServerUrl(String? url) {
    if (url == null) return;
    ollamax!.changeUrl(url);
  }

  Future<List<OllamaModel>> getModels() async {
    try {
      final models = await ollamax!.models();
      return models.map(
        (e) {
          return OllamaModel(
            name: e.model,
            size: e.formatedSize,
            family: e.details.family,
            quantization: e.details.quantizationLevel,
            paramSize: e.details.parameterSize,
          );
        },
      ).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map>> getRunningModels() async {
    final models = await ollamax!.runningModels();
    return models.map((e) {
      return {"name": e['name'], "exp": e['expires_at'], 'size_vram': e['size_vram']};
    }).toList();
  }

  Future<bool> checkServer() async {
    return await ollamax!.server();
  }

  Future createModel(Map<String, dynamic> request) async {
    return await ollamax!.createModel(request);
  }

  Future<dynamic> chat(OllamaxChatRequest request) async {
    return await ollamax!.chat(request);
  }

  Future deleteModel(String model) async {
    return await ollamax!.deleteModel(model);
  }

  Future<Map<String, dynamic>> generate(Map<String, dynamic> body) async {
    return await ollamax!.generate(body);
  }

  Future<void> saveServer(List<OllamaServer> servers) async {
    await _storage.saveServerHosts(servers.map((e) => e.host.toJson()).toList());
  }

  Future<void> saveSelectedHost(OllamaHost host) async {
    await _storage.saveSelectedHost(host.toJson());
  }

  Future<List<OllamaHost>> getHostFromStorage() async {
    List<OllamaHost> hosts = [];
    final data = _storage.getServerHosts();
    if (data != null) {
      hosts = data.map((e) => OllamaHost.fromJson(e)).toList();
    } else {
      final defaultOllama = OllamaHost(url: "http://127.0.0.1:11434", name: "default");
      hosts = [defaultOllama];
      await _storage.saveServerHosts([defaultOllama.toJson()]);
      await _storage.saveSelectedHost(hosts.first.toJson());
    }
    return hosts;
  }

  Future<OllamaHost> getSelectedHostFromStorage() async {
    final data = await _storage.getSelectedHost();

    return OllamaHost.fromJson(data);
  }
}
