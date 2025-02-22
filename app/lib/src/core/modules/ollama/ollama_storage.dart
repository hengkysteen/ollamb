import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:ollamb/src/core/configs/path.dart';
import 'package:ollamb/src/services/file_service.dart';

class OllamaStorage {
  final FileService _fileService;
  OllamaStorage(this._fileService);

  late Box _box;

  Future<void> init() async {
    final path = await _fileService.createPath(DB_PATH);
    _box = await Hive.openBox("ollama", path: path);
  }

  Future<void> saveServerHosts(List<Map<String, dynamic>> data) async {
    await _box.put("HOSTS", data);
  }

  List<Map<String, dynamic>>? getServerHosts() {
    final data = _box.get("HOSTS");
    if (data == null) return null;
    return List<Map<String, dynamic>>.from((data as List).map((e) => Map<String, dynamic>.from(e)));
  }

  Future<void> saveSelectedHost(Map<String, dynamic> data) async {
    await _box.put("SELECTED_HOST", data);
  }

  Future<Map<String, dynamic>> getSelectedHost() async {
    final data = await _box.get("SELECTED_HOST");
    if (data == null) return {'url': "http://127.0.0.1:11434", 'name': "default"};
    return Map<String, dynamic>.from(data);
  }
}
