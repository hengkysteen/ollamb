import 'package:get/get.dart';
import 'package:ollamb/src/core/modules/preferences/preferences_storage.dart';
import 'package:ollamb/src/core/modules/preferences/preferences_vm.dart';
import 'package:ollamb/src/services/file_service.dart';

class PreferencesModule {
  final FileService _fileService;
  PreferencesModule(this._fileService);

  Future<void> setup() async {
    try {
      final prefsStorage = PreferencesStorage(_fileService);
      await prefsStorage.init();
      Get.put(PreferencesVm(prefsStorage));
      final initialPrefs = await prefsStorage.getSettings();
      PreferencesVm.find.initSettings(initialPrefs);
    } catch (e) {
      rethrow;
    }
  }
}
