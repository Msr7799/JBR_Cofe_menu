// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 10;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      themeMode: fields[0] as String,
      language: fields[1] as String,
      fontSize: fields[2] as double,
      isFirstRun: fields[5] as bool,
      appName: fields[4] as String,
      benefitPayQrCodeUrl: fields[6] as String?,
      menuViewMode: fields[8] as String,
      logoPath: fields[9] as String?,
      backgroundSettings: fields[7] as BackgroundSettings,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.themeMode)
      ..writeByte(1)
      ..write(obj.language)
      ..writeByte(2)
      ..write(obj.fontSize)
      ..writeByte(4)
      ..write(obj.appName)
      ..writeByte(5)
      ..write(obj.isFirstRun)
      ..writeByte(6)
      ..write(obj.benefitPayQrCodeUrl)
      ..writeByte(8)
      ..write(obj.menuViewMode)
      ..writeByte(9)
      ..write(obj._logoPath)
      ..writeByte(7)
      ..write(obj.backgroundSettings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BackgroundSettingsAdapter extends TypeAdapter<BackgroundSettings> {
  @override
  final int typeId = 12;

  @override
  BackgroundSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BackgroundSettings(
      type: fields[0] as BackgroundType,
      colorValue: fields[2] as int,
      textColorValue: fields[3] as int,
      imagePath: fields[1] as String?,
      autoTextColor: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BackgroundSettings obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.colorValue)
      ..writeByte(3)
      ..write(obj.textColorValue)
      ..writeByte(1)
      ..write(obj.imagePath)
      ..writeByte(4)
      ..write(obj.autoTextColor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BackgroundSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SocialMediaAccountAdapter extends TypeAdapter<SocialMediaAccount> {
  @override
  final int typeId = 11;

  @override
  SocialMediaAccount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SocialMediaAccount(
      id: fields[0] as String,
      name: fields[1] as String,
      url: fields[2] as String,
      icon: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SocialMediaAccount obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.url)
      ..writeByte(3)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SocialMediaAccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BackgroundTypeAdapter extends TypeAdapter<BackgroundType> {
  @override
  final int typeId = 13;

  @override
  BackgroundType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BackgroundType.default_bg;
      case 1:
        return BackgroundType.color;
      case 2:
        return BackgroundType.image;
      default:
        return BackgroundType.default_bg;
    }
  }

  @override
  void write(BinaryWriter writer, BackgroundType obj) {
    switch (obj) {
      case BackgroundType.default_bg:
        writer.writeByte(0);
        break;
      case BackgroundType.color:
        writer.writeByte(1);
        break;
      case BackgroundType.image:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BackgroundTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
