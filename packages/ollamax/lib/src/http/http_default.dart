import 'dart:convert';
import 'dart:developer';
import 'package:fetch_client/fetch_client.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'http_helper.dart';
import 'http_interface.dart';

class DefaultClient implements HttpClientInterface {
  final http.Client httpClient;
  final bool httpLog;
  DefaultClient({required this.httpClient, this.httpLog = true});

  //coverage:ignore-line
  Future<void> _voidLog(String message, {bool newline = false}) async {
    if (httpLog == false) return;
    if (kDebugMode) {
      log("$message ${newline == true ? '\n....' : ''}", name: "OLLAMAX");
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  @override
  Future<dynamic> get({required String url}) async {
    _voidLog("[GET] URL $url");
    try {
      final response = await httpClient.get(Uri.parse(url));
      await _voidLog("[GET] STATUS : ${response.statusCode}", newline: true);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (await isJsonString(response.body)) {
          return json.decode(response.body);
        }
        return response.body;
      }
    } catch (e) {
      await _voidLog("[GET] ERROR : $e", newline: true);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> post({required String url, Map<String, dynamic>? body}) async {
    _voidLog(formatLog("[POST] URL", url, body));
    final encodedBody = body != null ? json.encode(body) : null;
    try {
      final response = await httpClient.post(Uri.parse(url), headers: {'content-type': 'application/json'}, body: encodedBody);

      if (response.statusCode == 200) {
        final decodeBody = response.body.isNotEmpty ? json.decode(response.body) as Map<String, dynamic> : <String, dynamic>{};
        await _voidLog("[POST] STATUS ${response.statusCode}", newline: true);
        return decodeBody;
      }
      throw response.body.isNotEmpty ? response.body : "Unknown error occurred.";
    } catch (e) {
      await _voidLog("[POST] ERROR $e", newline: true);
      rethrow;
    }
  }

  @override
  Future<Stream<Map<String, dynamic>>> stream({required String url, required String method, Map<String, dynamic>? body}) async {
    _voidLog(formatLog("[${method.toUpperCase()} STREAM] URL", url, body));
    final request = http.StreamedRequest(method, Uri.parse(url));
    if (body != null) {
      request.sink.add(utf8.encode(jsonEncode(body)));
    }
    request.sink.close();

    try {
      final response = kIsWeb ? await FetchClient(mode: RequestMode.cors).send(request) : await httpClient.send(request);

      if (response.statusCode == 200) {
        _voidLog("[${method.toUpperCase()} STREAM] STATUS ${response.statusCode}", newline: true);
        return Future.value(parseJsonStream(response.stream));
      } else {
        final errorBody = await getStreamResponseBody(response);
        if (errorBody.isEmpty) throw Exception("Error ${response.statusCode} . body is empty");
        throw json.decode(errorBody);
      }
    } catch (e) {
      await _voidLog("[${method.toUpperCase()} STREAM] ERROR $e", newline: true);
      rethrow;
    }
  }

  @override
  Future<dynamic> delete({required String url, Map<String, dynamic>? body}) async {
    final encodedBody = body != null ? json.encode(body) : null;
    _voidLog(formatLog("[DELETE] URL", url, body));
    final response = await httpClient.delete(Uri.parse(url), headers: {'content-type': 'application/json'}, body: encodedBody);
    await _voidLog("[DELETE] STATUS ${response.statusCode}", newline: true);
    return response;
  }
}
