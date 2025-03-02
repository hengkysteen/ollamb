import 'dart:convert';
import 'package:ollamax/ollamax.dart' as http;
import 'package:ollamb/src/features/prompts/data/prompt_model.dart';
import 'package:ollamb/src/features/prompts/data/prompt_storage.dart';

class PromtpRepository {
  final PromptStorage _storage;
  PromtpRepository(this._storage);

  Future<List<Prompt>> getFromRemote() async {
    try {
      final response = await http.get(Uri.parse("http://127.0.0.1:8080/prompts.json"));
      final List data = json.decode(response.body);

      return List.generate(data.length, (index) {
        int id = index + 4;
        id++;
        return Prompt(
          id: 'default_$id',
          type: data[index]['type'],
          name: data[index]['name'],
          prompt: data[index]['prompt'],
        );
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> add(Prompt prompt) async {
    await _storage.add(prompt.toJson());
  }

  Future<void> addAll(List<Prompt> prompt) async {
    await _storage.addAll(prompt.map((e) => e.toJson()).toList());
  }

  Future<List<Prompt>> getPrompts() async {
    final data = await _storage.getAll();
    return data.map((e) => Prompt.fromJson(e)).toList();
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  Future<void> delete(String id) async {
    await _storage.delete(id);
  }
}
