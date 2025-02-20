import 'dart:async';
import 'package:ollamax/ollamax.dart';

class OllamaxRepository {
  final DefaultClient client;
  final bool isAndroidEmulator;
  String _baseUrl;
  OllamaxRepository(this.client, this._baseUrl, this.isAndroidEmulator);

  String get baseUrl {
    final cleanBaseUrl = _baseUrl.replaceAll(RegExp(r'\/+$'), '');
    if (isAndroidEmulator) {
      final uri = Uri.parse(cleanBaseUrl);
      return cleanBaseUrl.replaceFirst(uri.host, '10.0.2.2');
    }
    return cleanBaseUrl;
  }

  void updateUrl(String newUrl) {
    _baseUrl = newUrl;
  }

  Future<dynamic> generate(Map<String, dynamic> body) async {
    if (body.containsKey("stream") && body['stream'] == true) {
      return await client.stream(url: "$baseUrl/api/generate", method: "POST", body: body);
    } else {
      return await client.post(url: "$baseUrl/api/generate", body: body);
    }
  }

  Future<dynamic> chat(OllamaxChatRequest request) async {
    if (request.stream == true) {
      return Future.value(_chatStream(request));
    } else {
      return await _chatFuture(request);
    }
  }

  Future<OllamaxChatResponse> _chatFuture(OllamaxChatRequest request) async {
    try {
      final data = await client.post(url: "$baseUrl/api/chat", body: request.toJson());
      return OllamaxChatResponse.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  Stream<OllamaxChatResponse> _chatStream(OllamaxChatRequest request) async* {
    final data = await client.stream(url: "$baseUrl/api/chat", method: "POST", body: request.toJson());

    await for (var chunk in data) {
      try {
        if (chunk.containsKey("error")) {
          yield OllamaxChatResponse(
            model: request.model,
            createdAt: DateTime.now().toIso8601String(),
            message: OllamaxMessage(role: "asistant", content: chunk['error']),
            done: true,
            doneReason: "error",
          );
        } else {
          yield OllamaxChatResponse.fromJson(chunk);
        }
      } catch (e) {
        yield OllamaxChatResponse(
          model: request.model,
          createdAt: DateTime.now().toIso8601String(),
          message: OllamaxMessage(role: 'error', content: 'Error parsing response'),
          done: true,
          doneReason: "error",
        );
      }
    }
  }

  Future<dynamic> server() async {
    return await client.get(url: "$baseUrl/");
  }

  Future<Map<String, dynamic>> version() async {
    return await client.get(url: "$baseUrl/api/version");
  }

  Future<dynamic> tags() async {
    return await client.get(url: "$baseUrl/api/tags");
  }

  Future<dynamic> show(String model) async {
    return await client.post(url: "$baseUrl/api/show", body: {"model": model});
  }

  Future<dynamic> ps() async {
    return await client.get(url: "$baseUrl/api/ps");
  }

  Future<bool> deleteModel(String model) async {
    final Response response = await client.delete(url: "$baseUrl/api/delete", body: {"model": model});
    return response.statusCode == 200 ? true : false;
  }

  Future<dynamic> pullModel(String model) async {
    return await client.post(url: "$baseUrl/api/pull", body: {"model": model});
  }

  Future<Map<String, dynamic>> embed(Map<String, dynamic> data) async {
    return await client.post(url: "$baseUrl/api/embed", body: data);
  }

  Future<dynamic> pushModel(String model) async {
    return UnimplementedError();
  }

  Future<dynamic> create(Map<String, dynamic> body) async {
    final data = Map<String, dynamic>.from(body);
    if (!data.containsKey('stream')) {
      data['stream'] = false;
    }
    if (data['stream'] == true) {
      return await client.stream(url: "$baseUrl/api/create", method: "POST", body: data);
    } else {
      return await client.post(url: "$baseUrl/api/create", body: data);
    }
  }

  Future<dynamic> copy(String source, String destination) async {
    final Map<String, dynamic> body = {"source": source, "destination": destination};
    return await client.post(url: "$baseUrl/api/copy", body: body);
  }

  Future<void> unloadChatModel(String model) async {
    final body = {"model": model, "keep_alive": 0};
    await client.post(url: "$baseUrl/api/chat", body: body);
  }

  Future<void> loadChatModel(String model) async {
    await client.post(url: "$baseUrl/api/chat", body: {"model": model});
  }
}
