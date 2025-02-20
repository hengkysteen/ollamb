import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ollamax/ollamax.dart';
import '../data/dummy.dart';

class MockOllamaxRepository extends Mock implements OllamaxRepository {}

void main() {
  late Ollamax ollamax;
  late MockOllamaxRepository mockRepository;

  setUp(() {
    mockRepository = MockOllamaxRepository();
    ollamax = Ollamax(url: 'https://example.com');
    ollamax.setupTest(mockRepository);
  });

  group("updateUrl", () {
    test('should called 1', () {
      const newUrl = 'https://newexample.com';
      when(() => mockRepository.updateUrl(any())).thenReturn(null);
      ollamax.changeUrl(newUrl);
      verify(() => mockRepository.updateUrl(newUrl)).called(1);
    });
  });

  group("version", () {
    test('should return string', () async {
      when(() => mockRepository.version()).thenAnswer((_) async => {'version': '0.0.4'});
      final result = await ollamax.version();
      expect(result, isA<String?>());
      expect(result, equals('0.0.4'));
      verify(() => mockRepository.version()).called(1);
    });

    test('should return null', () async {
      when(() => mockRepository.version()).thenThrow(Exception('Test exception'));
      final result = await ollamax.version();
      expect(result, isNull);
      verify(() => mockRepository.version()).called(1);
    });
  });

  group("models", () {
    test('should return a list of models', () async {
      when(() => mockRepository.tags()).thenAnswer((_) async {
        return {
          'models': [model1.toJson()]
        };
      });
      final result = await ollamax.models();
      expect(result, isA<List<OllamaxModel>>());
      expect(result.length, 1);
      verify(() => mockRepository.tags()).called(1);
    });
  });
  group("running models", () {
    test('should return empty list', () async {
      when(() => mockRepository.ps()).thenAnswer((_) async {
        return {'models': []};
      });
      final result = await ollamax.runningModels();
      expect(result, isEmpty);
    });
  });

  group("showModel", () {
    test('should return map', () async {
      const String modelName = "model1";
      when(() => mockRepository.show(modelName)).thenAnswer((_) async => Future.value({'name': modelName}));
      final result = await ollamax.showModel(modelName);
      expect(result, isA<Map<String, dynamic>>());
      expect(result['name'], equals(modelName));
    });
  });

  group("server", () {
    test('should return true', () async {
      when(() => mockRepository.server()).thenAnswer((_) => Future.value("Ollama is running"));
      final result = await ollamax.server();
      expect(result, equals(true));
      verify(() => mockRepository.server()).called(1);
    });
    test('should return false', () async {
      when(() => mockRepository.version()).thenThrow(Exception());
      final result = await ollamax.server();
      expect(result, equals(false));
      verify(() => mockRepository.server()).called(1);
    });
  });

  group('chat', () {
    test('should return future', () async {
      final request = OllamaxChatRequest(model: "model", messages: [OllamaxMessage(role: "user", content: "hi")], stream: false);
      final response = OllamaxChatResponse(model: "model", createdAt: "createdAt", message: OllamaxMessage(role: "assistant", content: "hi there"), done: true);
      when(() => mockRepository.chat(request)).thenAnswer((_) async => response);
      final OllamaxChatResponse result = await ollamax.chat(request);
      expect(result, isA<OllamaxChatResponse>());
      expect(result.message.role, equals("assistant"));
      verify(() => mockRepository.chat(request)).called(1);
    });

    test('should return stream', () async {
      final request = OllamaxChatRequest(model: "model", messages: [OllamaxMessage(role: "user", content: "hi")], stream: true);
      when(() => mockRepository.chat(request)).thenAnswer((_) async => Stream.fromIterable(streamResponse));
      final Stream<OllamaxChatResponse> result = await ollamax.chat(request);
      expect(result, isA<Stream<OllamaxChatResponse>>());
      final responseList = await result.toList();
      expect(responseList.length, equals(3));
      expect(responseList[0].message.content, equals("Hi"));
      expect(responseList[1].message.content, equals("How"));
      expect(responseList[2].message.content, equals("are you?"));
      expect(responseList[2].done, isTrue);
      verify(() => mockRepository.chat(request)).called(1);
    });
  });

  test('loadChatModel should call with correct model', () async {
    const modelName = "example-model";
    when(() => mockRepository.loadChatModel(modelName)).thenAnswer((_) async => Future.value());
    await ollamax.loadChatModel(modelName);
    verify(() => mockRepository.loadChatModel(modelName)).called(1);
  });

  test('unloadChatModel should call with correct model', () async {
    const modelName = "model1";
    when(() => mockRepository.unloadChatModel(modelName)).thenAnswer((_) async => Future.value());
    await ollamax.unloadChatModel(modelName);
    verify(() => mockRepository.unloadChatModel(modelName)).called(1);
  });

  group('embed', () {
    test('should return a valid embedding response', () async {
      final requestBody = {
        'model': 'model1',
        'input': ['Hello, world!']
      };
      final mockResponse = {
        'model': 'model1',
        'embeddings': [
          [0.0, 0.1]
        ]
      };
      when(() => mockRepository.embed(requestBody)).thenAnswer((_) async => mockResponse);
      final result = await ollamax.embed(requestBody);
      expect(result, isA<Map<String, dynamic>>());
      expect(result['model'], equals('model1'));
      expect(result['embeddings'], isA<List<List<double>>>());
      expect(result['embeddings'][0], equals([0.0, 0.1]));
      verify(() => mockRepository.embed(requestBody)).called(1);
    });

    test('should throw an exception when embed fails', () async {
      final requestBody = {
        'model': 'model1',
        'input': ['Hello, world!']
      };
      when(() => mockRepository.embed(requestBody)).thenThrow(Exception('Network error'));
      expect(() async => await ollamax.embed(requestBody), throwsA(isA<Exception>()));
      verify(() => mockRepository.embed(requestBody)).called(1);
    });
  });

  group('createModel', () {
    test('should call post when stream is false', () async {
      final requestBody = {'stream': false};
      final mockResponse = {'status': 'success'};
      when(() => mockRepository.create(requestBody)).thenAnswer((_) async => mockResponse);
      final result = await ollamax.createModel(requestBody);
      expect(result, isA<Map<String, dynamic>>());
      expect(result['status'], equals('success'));
      verify(() => mockRepository.create(requestBody)).called(1);
    });
    test('should call stream when stream is true', () async {
      final requestBody = {'stream': true};
      final mockResponse = {'status': 'streaming'};
      when(() => mockRepository.create(requestBody)).thenAnswer((_) async => mockResponse);
      final result = await ollamax.createModel(requestBody);
      expect(result, isA<Map<String, dynamic>>());
      expect(result['status'], equals('streaming'));
      verify(() => mockRepository.create(requestBody)).called(1);
    });

    test('should throw exception when create fails', () async {
      final requestBody = {'stream': false};
      when(() => mockRepository.create(requestBody)).thenThrow(Exception('Network error'));
      expect(() async => await ollamax.createModel(requestBody), throwsA(isA<Exception>()));
      verify(() => mockRepository.create(requestBody)).called(1);
    });
  });

  group('generate', () {
    test('should call post when stream is false', () async {
      final requestBody = {'model': 'model1', 'prompt': 'Hello, world!', 'stream': false};
      final mockResponse = {'status': 'generated', 'data': 'some generated data'};
      when(() => mockRepository.generate(requestBody)).thenAnswer((_) async => mockResponse);
      final result = await ollamax.generate(requestBody);
      expect(result, isA<Map<String, dynamic>>());
      expect(result['status'], equals('generated'));
      expect(result['data'], equals('some generated data'));
      verify(() => mockRepository.generate(requestBody)).called(1);
    });
    test('should call stream when stream is true', () async {
      final requestBody = {'model': 'model1', 'prompt': 'Hello, world!', 'stream': true};
      final mockResponse = {'status': 'streaming', 'data': 'streaming data'};
      when(() => mockRepository.generate(requestBody)).thenAnswer((_) async => mockResponse);
      final result = await ollamax.generate(requestBody);
      expect(result, isA<Map<String, dynamic>>());
      expect(result['status'], equals('streaming'));
      expect(result['data'], equals('streaming data'));
      verify(() => mockRepository.generate(requestBody)).called(1);
    });
    test('should throw exception when generate fails', () async {
      final requestBody = {'model': 'model1', 'prompt': 'Hello, world!', 'stream': false};
      when(() => mockRepository.generate(requestBody)).thenThrow(Exception('Network error'));
      expect(() async => await ollamax.generate(requestBody), throwsA(isA<Exception>()));
      verify(() => mockRepository.generate(requestBody)).called(1);
    });
  });

  group('copyModel', () {
    test('should call copy on repository', () async {
      const model = 'model1';
      const newModel = 'model2';
      when(() => mockRepository.copy(model, newModel)).thenAnswer((_) async => null);
      await ollamax.copyModel(model, newModel);
      verify(() => mockRepository.copy(model, newModel)).called(1);
    });
  });

  group('deleteModel', () {
    test('should call deleteModel and return true', () async {
      const model = 'model1';
      when(() => mockRepository.deleteModel(model)).thenAnswer((_) async => true);
      final result = await ollamax.deleteModel(model);
      expect(result, isTrue);
      verify(() => mockRepository.deleteModel(model)).called(1);
    });
    test('should return false when deleteModel throws exception', () async {
      const model = 'model1';
      when(() => mockRepository.deleteModel(model)).thenThrow(Exception('Error'));
      final result = await ollamax.deleteModel(model);
      expect(result, isFalse);
      verify(() => mockRepository.deleteModel(model)).called(1);
    });
  });
}
