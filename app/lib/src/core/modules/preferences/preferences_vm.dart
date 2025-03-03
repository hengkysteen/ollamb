import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/core/modules/preferences/models/preferences_model.dart';
import 'package:ollamb/src/core/modules/preferences/preferences_storage.dart';

class PreferencesVm extends GetxController {
  final PreferencesStorage _storage;
  PreferencesVm(this._storage);

  Preferences settings = Preferences(
    themeMode: 0,
    themeColor: Colors.blue,
    codeSyntaxTheme: 'atom-one-dark',
    responseFormat: "Markdown",
    useLatex: true,
    textScaleFactor: 1.0,
  );
  Brightness? systemBrightness;

  bool isAutoTitle = false;

  String modelAutoTitle = "Auto Model";

  void setModelAutoTitle(String value) {
    modelAutoTitle = value;
    update();
  }

  void setIsGenerateTitle(bool value) {
    isAutoTitle = value;
    update();
  }

  void initSettings(Preferences? settings) {
    this.settings = settings ?? this.settings;
    update();
  }

  void setTextScaleFactor(double value) {
    settings.textScaleFactor = value;
    update();
    _storage.saveSettings(settings.copyWith(textScaleFactor: value));
  }

  void changeResponseFormat(String value) {
    settings.responseFormat = value;
    update();
    _storage.saveSettings(settings.copyWith(responseFormat: value));
  }

  void setSelectedCodeSyntaxTheme(String value) {
    settings.codeSyntaxTheme = value;
    update();
    _storage.saveSettings(settings.copyWith(codeSyntaxTheme: value));
  }

  bool get isDark {
    if (settings.themeModeEnum == ThemeMode.dark) return true;
    if (settings.themeModeEnum == ThemeMode.light) return false;
    return systemBrightness == Brightness.dark ? true : false;
  }

  void listenSystemBrightness(Brightness brightness) {
    systemBrightness = brightness;
  }

  void changeTheme(Color color) {
    settings.themeColor = color;
    update();
    _storage.saveSettings(settings.copyWith(themeColor: color));
  }

  void changeThemeMode(ThemeMode mode) {
    settings.themeMode = mode.index;
    update();
    _storage.saveSettings(settings.copyWith(themeMode: mode.index));
  }

  ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(brightness: Brightness.light, seedColor: settings.themeColor),
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(brightness: Brightness.dark, seedColor: settings.themeColor),
    );
  }

  double getPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 800) {
      return 10;
    } else if (screenWidth <= 1200) {
      return 20;
    } else {
      return 120;
    }
  }

  static PreferencesVm get find => Get.find();
}
