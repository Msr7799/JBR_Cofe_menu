import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 10)
class AppSettings extends HiveObject {
  @HiveField(0)
  String themeMode;

  @HiveField(1)
  String language;

  @HiveField(2)
  double fontSize;

  @HiveField(3)
  List<SocialMediaAccount> socialAccounts;

  @HiveField(4)
  String appName;

  @HiveField(5)
  bool isFirstRun;

  @HiveField(6)
  String? benefitPayQrCodeUrl;

  @HiveField(7)
  BackgroundSettings backgroundSettings;

  @HiveField(8)
  String menuViewMode;

  AppSettings({
    required this.themeMode,
    required this.language,
    required this.fontSize,
    required this.socialAccounts,
    required this.appName,
    required this.isFirstRun,
    this.benefitPayQrCodeUrl,
    BackgroundSettings? backgroundSettings,
    this.menuViewMode = 'cards',
  }) : this.backgroundSettings =
            backgroundSettings ?? BackgroundSettings.defaultSettings();

  factory AppSettings.defaultSettings() {
    return AppSettings(
      themeMode: 'light',
      language: 'ar',
      fontSize: 1.0,
      socialAccounts: [],
      appName: 'JBR Coffee Shop',
      isFirstRun: true,
      backgroundSettings: BackgroundSettings.defaultSettings(),
      menuViewMode: 'cards',
    );
  }

  MenuViewMode get viewMode {
    switch (menuViewMode) {
      case 'list':
        return MenuViewMode.list;
      case 'textOnly':
        return MenuViewMode.textOnly;
      case 'singleProduct':
        return MenuViewMode.singleProduct;
      case 'categories':
        return MenuViewMode.categories;
      case 'cards':
      default:
        return MenuViewMode.cards;
    }
  }
}

@HiveType(typeId: 11)
class SocialMediaAccount extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String url;

  @HiveField(3)
  String icon;

  SocialMediaAccount({
    required this.id,
    required this.name,
    required this.url,
    required this.icon,
  });
}

@HiveType(typeId: 12)
class BackgroundSettings extends HiveObject {
  @HiveField(0)
  BackgroundType type;

  @HiveField(1)
  String? imagePath;

  @HiveField(2)
  int colorValue;

  @HiveField(3, defaultValue: 0xFF000000) // Black as default
  int textColorValue;

  @HiveField(4, defaultValue: true)
  bool autoTextColor;

  BackgroundSettings({
    required this.type,
    this.imagePath,
    required this.colorValue,
    int? textColorValue,
    bool? autoTextColor,
  })  : this.textColorValue = textColorValue ?? Colors.black.value,
        this.autoTextColor = autoTextColor ?? true;

  factory BackgroundSettings.defaultSettings() {
    return BackgroundSettings(
      type: BackgroundType.default_bg,
      colorValue: Colors.white.value,
      textColorValue: Colors.black.value,
      autoTextColor: true,
    );
  }
}

@HiveType(typeId: 13)
enum BackgroundType {
  @HiveField(0)
  default_bg,

  @HiveField(1)
  color,

  @HiveField(2)
  image
}

enum MenuViewMode {
  cards, // بطاقات (الافتراضي)
  list, // قائمة
  textOnly, // نص فقط
  singleProduct, // منتج واحد في كل صفحة
  categories // فئات
}
