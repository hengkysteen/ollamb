import 'dart:convert';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:ollamb/src/core/configs/path.dart';
import 'package:ollamb/src/services/file_service.dart';

class ConversationStorage {
  final FileService _fileService;

  ConversationStorage(this._fileService);

  late Box _box;

  Future<void> init() async {
    final path = await _fileService.createPath(DB_PATH);
    _box = await Hive.openBox("conversations", path: path);
  }

  Future<void> update(Map<String, dynamic> data, String id) async {
    await _box.delete(id);
    await _box.put(id, json.encode(data));
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  Future<void> save(Map<String, dynamic> data) async {
    final id = data['id'].toString();
    await _box.put(id, json.encode(data));
  }

  Future<Map<String, dynamic>?> get(String key) async {
    final value = await _box.get(key);
    if (value != null) {
      return json.decode(value) as Map<String, dynamic>;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getList() async {
    final data = _box.values;
    if (data.isNotEmpty) {
      return data.map((item) => json.decode(item) as Map<String, dynamic>).toList();
    }
    return [];
  }
}
