// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 4;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      language: fields[0] as String,
      fontSize: fields[1] as double,
      theme: fields[2] as String,
      socialAccounts: (fields[3] as Map?)?.cast<String, SocialMediaAccount>(),
      benefitEmail: fields[4] as String?,
      storedQrCode: fields[5] as String?,
      appVersion: fields[6] as String,
      licenseNumber: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.language)
      ..writeByte(1)
      ..write(obj.fontSize)
      ..writeByte(2)
      ..write(obj.theme)
      ..writeByte(3)
      ..write(obj.socialAccounts)
      ..writeByte(4)
      ..write(obj.benefitEmail)
      ..writeByte(5)
      ..write(obj.storedQrCode)
      ..writeByte(6)
      ..write(obj.appVersion)
      ..writeByte(7)
      ..write(obj.licenseNumber);
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

class SocialMediaAccountAdapter extends TypeAdapter<SocialMediaAccount> {
  @override
  final int typeId = 5;

  @override
  SocialMediaAccount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SocialMediaAccount(
      isActive: fields[0] as bool,
      url: fields[1] as String,
      platform: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SocialMediaAccount obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.isActive)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.platform);
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

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
      language: json['language'] as String? ?? 'ar',
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 1.0,
      theme: json['theme'] as String? ?? 'brown',
      socialAccounts: (json['socialAccounts'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, SocialMediaAccount.fromJson(e as Map<String, dynamic>)),
      ),
      benefitEmail: json['benefitEmail'] as String?,
      storedQrCode: json['storedQrCode'] as String?,
      appVersion: json['appVersion'] as String? ?? '1.0.0',
      licenseNumber: json['licenseNumber'] as String? ?? '',
    );

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'language': instance.language,
      'fontSize': instance.fontSize,
      'theme': instance.theme,
      'socialAccounts': instance.socialAccounts,
      'benefitEmail': instance.benefitEmail,
      'storedQrCode': instance.storedQrCode,
      'appVersion': instance.appVersion,
      'licenseNumber': instance.licenseNumber,
    };

SocialMediaAccount _$SocialMediaAccountFromJson(Map<String, dynamic> json) =>
    SocialMediaAccount(
      isActive: json['isActive'] as bool? ?? false,
      url: json['url'] as String? ?? '',
      platform: json['platform'] as String,
    );

Map<String, dynamic> _$SocialMediaAccountToJson(SocialMediaAccount instance) =>
    <String, dynamic>{
      'isActive': instance.isActive,
      'url': instance.url,
      'platform': instance.platform,
    };
