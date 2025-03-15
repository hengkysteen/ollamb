import 'dart:convert';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:ollamb/src/core/configs/path.dart';
import 'package:ollamb/src/services/file_service.dart';

class VectorizeStorage {
  final FileService _fileService;
  VectorizeStorage(this._fileService);

  late Box _box;

  Future<void> init() async {
    if (Hive.isBoxOpen('vectors')) return;
    final path = await _fileService.createPath(DB_PATH);
    _box = await Hive.openBox("vectors", path: path);
  }

  Future<void> add(Map<String, dynamic> data) async {
    await _box.put(data['id'], json.encode(data));
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    return _box.values.map((e) => json.decode(e) as Map<String, dynamic>).toList();
  }

  Future<void> close() async {
    await _box.close();
  }
}
