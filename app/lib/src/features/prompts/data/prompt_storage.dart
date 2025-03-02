import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:ollamb/src/core/configs/path.dart';
import 'package:ollamb/src/services/file_service.dart';

class PromptStorage {
  final FileService _fileService;
  PromptStorage(this._fileService);
  late Box _box;
  
  Future<void> init() async {
    final path = await _fileService.createPath(DB_PATH);
    _box = await Hive.openBox("promtps", path: path);
  }

  Future<void> add(Map<String, dynamic> data) async {
    final id = data['id'];
    if (id == null) throw ArgumentError('Data harus memiliki kunci "id"');
    await _box.put(id, data);
  }

  Future<void> addAll(List<Map<String, dynamic>> dataList) async {
    final existingKeys = _box.keys.toSet();
    final Map<dynamic, Map<String, dynamic>> mappedData = {
      for (var data in dataList)
        if (data['id'] != null && !existingKeys.contains(data['id'])) data['id']: data
    };
    if (mappedData.isNotEmpty) {
      await _box.putAll(mappedData);
    }
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final data = _box.values.toList();
    return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<void> deleteAll() async {
    await _box.clear();
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
