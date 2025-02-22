import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
part 'preferences_model.g.dart';

@HiveType(typeId: 1)
class Preferences {
  @HiveField(0)
  int themeMode;

  @HiveField(1)
  Color themeColor;

  @HiveField(2)
  String codeSyntaxTheme;

  @HiveField(3)
  String responseFormat;

  @HiveField(4)
  bool useLatex;

  @HiveField(5)
  double textScaleFactor;

  @HiveField(6)
  bool isSidebarCollapsed;

  Preferences({
    required this.themeMode,
    required this.themeColor,
    required this.codeSyntaxTheme,
    required this.responseFormat,
    required this.useLatex,
    required this.textScaleFactor,
    this.isSidebarCollapsed = false,
  });

  ThemeMode get themeModeEnum {
    return ThemeMode.values[themeMode];
  }

  Preferences copyWith({
    int? themeMode,
    Color? themeColor,
    String? codeSyntaxTheme,
    String? responseFormat,
    bool? useLatex,
    double? textScaleFactor,
    String? ollambPath,
    String? exportPath,
    bool? isSidebarCollapsed,
  }) {
    return Preferences(
      themeMode: themeMode ?? this.themeMode,
      themeColor: themeColor ?? this.themeColor,
      codeSyntaxTheme: codeSyntaxTheme ?? this.codeSyntaxTheme,
      responseFormat: responseFormat ?? this.responseFormat,
      useLatex: useLatex ?? this.useLatex,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      isSidebarCollapsed: isSidebarCollapsed ?? this.isSidebarCollapsed,
    );
  }
}
