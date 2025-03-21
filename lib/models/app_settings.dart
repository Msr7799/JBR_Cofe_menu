import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 4)
@JsonSerializable()
class AppSettings extends HiveObject {
  @HiveField(0)
  String language;

  @HiveField(1)
  double fontSize;

  @HiveField(2)
  String theme;

  @HiveField(3)
  Map<String, SocialMediaAccount> socialAccounts;

  @HiveField(4)
  String? benefitEmail;

  @HiveField(5)
  String? storedQrCode;

  @HiveField(6)
  String appVersion;

  @HiveField(7)
  String licenseNumber;

  AppSettings({
    this.language = 'ar',
    this.fontSize = 1.0,
    this.theme = 'brown',
    Map<String, SocialMediaAccount>? socialAccounts,
    this.benefitEmail,
    this.storedQrCode,
    this.appVersion = '1.0.0',
    this.licenseNumber = '',
  }) : socialAccounts = socialAccounts ?? {};

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);
}

@HiveType(typeId: 5)
@JsonSerializable()
class SocialMediaAccount extends HiveObject {
  @HiveField(0)
  bool isActive;

  @HiveField(1)
  String url;

  @HiveField(2)
  String platform;

  SocialMediaAccount({
    this.isActive = false,
    this.url = '',
    required this.platform,
  });

  factory SocialMediaAccount.fromJson(Map<String, dynamic> json) =>
      _$SocialMediaAccountFromJson(json);

  Map<String, dynamic> toJson() => _$SocialMediaAccountToJson(this);
}
