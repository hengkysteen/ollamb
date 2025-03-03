import 'package:ollamb/src/features/prompts/data/default.dart';
import 'package:ollamb/src/features/prompts/data/prompt_model.dart';
import 'package:ollamb/src/features/prompts/data/prompt_storage.dart';

class PromtpRepository {
  final PromptStorage _storage;
  PromtpRepository(this._storage);

  Future<List<Prompt>> getMoreDefaultPrompts() async {
    try {
      return List.generate(default2Prompts.length, (index) {
        int id = index + 2;
        id++;
        return Prompt(
          id: 'default_$id',
          type: default2Prompts[index]['type'],
          name: default2Prompts[index]['name'],
          prompt: default2Prompts[index]['prompt'],
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
