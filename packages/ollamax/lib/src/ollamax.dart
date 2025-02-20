import 'package:ollamax/ollamax.dart';
import 'package:http/http.dart' as http;

class Ollamax {
  /// Ollama host eg : http://127.0.0.1:11434
  final String url;

  /// show http logs
  final bool showLog;

  /// Simply replaces `localhost` with `10.0.2.2` for Android emulator purposes.
  final bool isAndroidEmulator;

  Ollamax({required this.url, this.isAndroidEmulator = false, this.showLog = false}) {
    _repository = OllamaxRepository(DefaultClient(httpLog: showLog, httpClient: http.Client()), url, isAndroidEmulator);
  }
  late OllamaxRepository _repository;
  void setupTest(OllamaxRepository repository) {
    _repository = repository;
  }

  void changeUrl(String newUrl) {
    _repository.updateUrl(newUrl);
  }

  /// Generate a chat completion
  Future<dynamic> chat(OllamaxChatRequest request) async {
    return await _repository.chat(request);
  }

  /// Retrieve the Ollama version
  Future<String?> version() async {
    try {
      final data = await _repository.version();
      return data['version'];
    } catch (e) {
      return Future.value(null);
    }
  }

  Future<bool> server() async {
    try {
      final response = await _repository.server();
      return response == "Ollama is running" ? true : false;
    } catch (e) {
      return Future.value(false);
    }
  }

  /// List Local Models
  Future<List<OllamaxModel>> models() async {
    final data = await _repository.tags();
    return (data['models'] as List).map((e) => OllamaxModel.fromJson(e)).toList();
  }

  /// List Running Models
  Future<List<Map<String, dynamic>>> runningModels() async {
    final data = await _repository.ps();
    return List<Map<String, dynamic>>.from(data['models']);
  }

  /// Show Model Information
  Future<Map<String, dynamic>> showModel(String model) async {
    return await _repository.show(model);
  }

  /// Copy a Model
  /// Creates a model with another name from an existing model.
  Future<void> copyModel(String model, String newModel) async {
    await _repository.copy(model, newModel);
  }

  /// Delete a Model
  Future<bool> deleteModel(String model) async {
    try {
      return await _repository.deleteModel(model);
    } catch (e) {
      return false;
    }
  }

  /// Generate a completion
  ///
  /// https://github.com/ollama/ollama/blob/main/docs/api.md#generate-a-completion
  Future<dynamic> generate(Map<String, dynamic> body) async {
    return await _repository.generate(body);
  }

  /// Create a Model
  ///
  /// https://github.com/ollama/ollama/blob/main/docs/api.md#create-a-model
  Future<dynamic> createModel(Map<String, dynamic> body) async {
    return await _repository.create(body);
  }

  /// Generate Embeddings
  ///
  /// https://github.com/ollama/ollama/blob/main/docs/api.md#generate-embeddings
  Future<Map<String, dynamic>> embed(Map<String, dynamic> body) async {
    return await _repository.embed(body);
  }

  /// Unload a model
  Future<void> unloadChatModel(String model) async {
    await _repository.unloadChatModel(model);
  }

  /// Load a model
  Future<void> loadChatModel(String model) async {
    await _repository.loadChatModel(model);
  }
}
