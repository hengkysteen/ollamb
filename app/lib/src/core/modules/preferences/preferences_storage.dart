import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:ollamb/src/core/configs/path.dart';
import 'package:ollamb/src/core/modules/preferences/models/preferences_model.dart';

import 'package:ollamb/src/services/file_service.dart';

class PreferencesStorage {
  final FileService _fileService;
  PreferencesStorage(this._fileService);

  late Box<Preferences> _box;

  Future<void> init() async {
    Hive.registerAdapter(PreferencesAdapter());
    final path = await _fileService.createPath(DB_PATH);
    _box = await Hive.openBox("preferences", path: path);
  }

  Future<void> saveSettings(Preferences settings) async {
    await _box.put("PREFERENCES", settings);
  }

  Future<Preferences?> getSettings() async {
    return _box.get("PREFERENCES");
  }
}
