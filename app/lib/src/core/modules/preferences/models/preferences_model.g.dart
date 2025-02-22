// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PreferencesAdapter extends TypeAdapter<Preferences> {
  @override
  final int typeId = 1;

  @override
  Preferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Preferences(
      themeMode: (fields[0] as num).toInt(),
      themeColor: fields[1] as Color,
      codeSyntaxTheme: fields[2] as String,
      responseFormat: fields[3] as String,
      useLatex: fields[4] as bool,
      textScaleFactor: (fields[5] as num).toDouble(),
      isSidebarCollapsed: fields[6] == null ? false : fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Preferences obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.themeMode)
      ..writeByte(1)
      ..write(obj.themeColor)
      ..writeByte(2)
      ..write(obj.codeSyntaxTheme)
      ..writeByte(3)
      ..write(obj.responseFormat)
      ..writeByte(4)
      ..write(obj.useLatex)
      ..writeByte(5)
      ..write(obj.textScaleFactor)
      ..writeByte(6)
      ..write(obj.isSidebarCollapsed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
