import 'dart:convert';
import 'package:http/http.dart' as http;

String formatLog(String method, String url, Map<String, dynamic>? body) {
  final logHeader = "$method $url";
  final logBody = body != null ? const JsonEncoder.withIndent('   ').convert(body) : "   No body provided";
  return "$logHeader\n$logBody";
}

Future<bool> isJsonString(String input) async {
  try {
    final data = json.decode(input);
    return data is Map || data is List;
  } catch (e) {
    return Future.value(false);
  }
}

Future<String> getStreamResponseBody(http.StreamedResponse response) async {
  final bodyBytes = await response.stream.toBytes();
  try {
    return utf8.decode(bodyBytes);
  } catch (e) {
    return Future.value('Invalid UTF-8 response');
  }
}

Stream<Map<String, dynamic>> parseJsonStream(http.ByteStream inputStream) async* {
  final buffer = StringBuffer();

  await for (final chunk in inputStream) {
    buffer.write(utf8.decode(chunk));

    final jsonParts = buffer.toString().split('\n');

    for (int i = 0; i < jsonParts.length - 1; i++) {
      final part = jsonParts[i].trim();
      if (part.isNotEmpty) {
        try {
          final data = jsonDecode(part) as Map<String, dynamic>;
          yield data;
        } catch (e) {
          /// ERROR
        }
      }
    }
    buffer
      ..clear()
      ..write(jsonParts.last.trim());
  }
  if (buffer.isNotEmpty) {
    try {
      final data = jsonDecode(buffer.toString()) as Map<String, dynamic>;
      yield data;
    } catch (e) {
      // ERROR
    }
  }
}
