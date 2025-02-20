import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:ollamax/ollamax.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeHttpRequest extends Fake implements http.BaseRequest {}

void main() {
  late MockHttpClient mockHttpClient;
  final Uri uri = Uri.parse("https://google.com");
  late DefaultClient defaultClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    defaultClient = DefaultClient(httpClient: mockHttpClient);
    registerFallbackValue(uri);
    registerFallbackValue(FakeHttpRequest());
  });

  group('DefaultClient ', () {
    test("get", () async {
      final http.Response res = http.Response("ok", 200);
      when(() => mockHttpClient.get(any())).thenAnswer((_) async => res);
      final response = await defaultClient.get(url: uri.toString());
      expect(response, equals("ok"));
    });

    test("stream", () async {
      final http.StreamedResponse res = http.StreamedResponse(const Stream.empty(), 200);
      when(() => mockHttpClient.send(any())).thenAnswer((_) async => res);
      final response = await defaultClient.stream(url: uri.toString(), method: "POST", body: {"model": "model1"});
      expect(response, isA<Stream>());
    });

    test("post", () async {
      final http.Response res = http.Response('{"data" : "ok"}', 200, headers: {'content-type': 'application/json'});

      when(() => mockHttpClient.post(any(), headers: any(named: 'headers'), body: any(named: 'body'))).thenAnswer((_) async => res);

      final response = await defaultClient.post(url: uri.toString(), body: {"model": "model1"});

      expect(response['data'], equals("ok"));
    });

    test("delete", () async {
      final http.Response res = http.Response('', 200);
      when(() => mockHttpClient.delete(any(), headers: any(named: 'headers'), body: any(named: 'body'))).thenAnswer((_) async => res);
      final http.Response response = await defaultClient.delete(url: uri.toString(), body: {"model": "model1"});
      expect(response.body, isEmpty);
    });
  });
}
