import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:ollamax/src/http/http_helper.dart';
import 'package:http/http.dart' as http;

void main() {
  group('formatLog', () {
    test('should format log correctly for various cases', () {
      expect(
        formatLog('POST', 'https://example.com/api', {'key': 'value'}),
        equals('POST https://example.com/api\n{\n   "key": "value"\n}'),
      );
      expect(
        formatLog('GET', 'https://example.com/api', null),
        equals('GET https://example.com/api\n   No body provided'),
      );
      expect(
        formatLog('PUT', 'https://example.com/api', {}),
        equals('PUT https://example.com/api\n{}'),
      );
    });
  });

  group('isJsonString', () {
    test('should return false for invalid JSON input', () async {
      expect(await isJsonString('key: value'), isFalse);
      expect(await isJsonString('{"key": "value"}'), isTrue);
    });
  });

  group('getStreamResponseBody', () {
    test('should return decoded response body as string', () async {
      const body = 'This is a test response body.';
      final response = http.StreamedResponse(Stream.value(utf8.encode(body)), 200);
      final result = await getStreamResponseBody(response);
      expect(result, body);
    });
    test('should return empty string for empty response body', () async {
      final response = http.StreamedResponse(const Stream.empty(), 200);
      final result = await getStreamResponseBody(response);
      expect(result, '');
    });
    test('should handle non-UTF8 encoded response body', () async {
      final body = [0x80, 0x81, 0x82];
      final response = http.StreamedResponse(Stream.value(body), 200);
      final result = await getStreamResponseBody(response);
      expect(result, isNotEmpty);
    });
  });
  group('parseJsonStream', () {
    test('should parse valid JSON objects from stream', () async {
      final jsonStrings = [
        '{"key1": "value1"}\n',
        '{"key2": "value2"}\n{"key3": "value3"}\n',
      ];
      final stream = Stream.fromIterable(jsonStrings.map(utf8.encode));
      final byteStream = http.ByteStream(stream);
      final results = await parseJsonStream(byteStream).toList();
      expect(results, [
        {'key1': 'value1'},
        {'key2': 'value2'},
        {'key3': 'value3'},
      ]);
    });
    test('should handle JSON spread across multiple chunks', () async {
      final jsonChunks = ['{"key": "val', 'ue"}\n{"anoth', 'er": "test"}\n'];
      final stream = Stream.fromIterable(jsonChunks.map(utf8.encode));
      final byteStream = http.ByteStream(stream);
      final results = await parseJsonStream(byteStream).toList();
      expect(results, [
        {'key': 'value'},
        {'another': 'test'},
      ]);
    });
    test('should ignore empty lines and invalid JSON', () async {
      final jsonStrings = [
        '{"valid": "json"}\n',
        'invalid json\n',
        '\n{"another": "valid"}\n',
      ];
      final stream = Stream.fromIterable(jsonStrings.map(utf8.encode));
      final byteStream = http.ByteStream(stream);
      final results = await parseJsonStream(byteStream).toList();
      expect(results, [
        {'valid': 'json'},
        {'another': 'valid'},
      ]);
    });
    test('should handle empty stream', () async {
      const stream = Stream<List<int>>.empty();
      const byteStream = http.ByteStream(stream);
      final results = await parseJsonStream(byteStream).toList();
      expect(results, isEmpty);
    });
  });
}
