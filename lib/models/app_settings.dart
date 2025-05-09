import 'dart:io';
import 'package:hive/hive.dart';

part 'app_settings.g.dart';

// تعريف انواع خلفية التطبيق
@HiveType(typeId: 13)
enum BackgroundType {
  @HiveField(0)
  default_bg,
  @HiveField(1)
  color,
  @HiveField(2)
  image
}

// نموذج إعدادات التطبيق
@HiveType(typeId: 10)
class AppSettings {
  // إعدادات عامة
  @HiveField(0)
  String themeMode; // هذا صحيح، نحن نخزن واضع الثيم كسلسلة نصية

  @HiveField(1)
  String language;

  @HiveField(2)
  double fontSize;

  @HiveField(4)
  String appName;

  @HiveField(5)
  bool isFirstRun;

  @HiveField(6)
  String? benefitPayQrCodeUrl;

  @HiveField(8)
  String menuViewMode;

  // إضافة خاصية لوغو التطبيق
  @HiveField(9)
  String? _logoPath;

  // إعدادات الخلفية
  @HiveField(7)
  BackgroundSettings backgroundSettings;

  AppSettings({
    this.themeMode = 'system',
    this.language = 'ar',
    this.fontSize = 1.0,
    this.isFirstRun = true,
    this.appName = 'JBR Coffee Shop',
    this.benefitPayQrCodeUrl,
    this.menuViewMode = 'grid',
    String? logoPath,
    BackgroundSettings? backgroundSettings,
  })  : _logoPath = logoPath,
        backgroundSettings =
            backgroundSettings ?? BackgroundSettings.defaultSettings();

  // إعدادات افتراضية
  factory AppSettings.defaultSettings() {
    return AppSettings(
      themeMode: 'system',
      language: 'ar',
      fontSize: 1.0,
      isFirstRun: true,
      appName: 'JBR Coffee Shop',
      benefitPayQrCodeUrl: null,
      menuViewMode: 'grid',
      logoPath: 'assets/images/logo.png',
      backgroundSettings: BackgroundSettings.defaultSettings(),
    );
  }

  // تحويل من JSON
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      themeMode: json['themeMode'] as String? ?? 'system',
      language: json['language'] as String? ?? 'ar',
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 1.0,
      isFirstRun: json['isFirstRun'] as bool? ?? true,
      appName: json['appName'] as String? ?? 'JBR Coffee Shop',
      benefitPayQrCodeUrl: json['benefitPayQrCodeUrl'] as String?,
      menuViewMode: json['menuViewMode'] as String? ?? 'grid',
      logoPath: json['logoPath'] as String? ?? 'assets/images/logo.png',
      backgroundSettings: json['backgroundSettings'] != null
          ? BackgroundSettings.fromJson(
              json['backgroundSettings'] as Map<String, dynamic>)
          : BackgroundSettings.defaultSettings(),
    );
  }

  // getter لمسار الشعار
  String? get logoPath => _logoPath ?? 'assets/images/logo.png';

  // setter آمن لمسار الشعار - تنظيف المسار القديم إذا كان مخصصًا
  set logoPath(String? path) {
    // عند تعيين شعار مخصص جديد، نحتاج إلى تنظيف الشعار المخصص السابق
    if (_logoPath != null &&
        path != _logoPath &&
        !_logoPath!.startsWith('assets/') &&
        File(_logoPath!).existsSync()) {
      try {
        // محاولة حذف الصورة القديمة بشكل غير متزامن
        File(_logoPath!).deleteSync();
      } catch (e) {
        // تجاهل أي أخطاء قد تحدث أثناء عملية الحذف
        print('خطأ عند محاولة حذف الشعار المخصص السابق: $e');
      }
    }
    _logoPath = path;
  }

  // تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode,
      'language': language,
      'fontSize': fontSize,
      'isFirstRun': isFirstRun,
      'appName': appName,
      'benefitPayQrCodeUrl': benefitPayQrCodeUrl,
      'menuViewMode': menuViewMode,
      'logoPath': _logoPath,
      'backgroundSettings': backgroundSettings.toJson(),
    };
  }
}

// نموذج إعدادات الخلفية
@HiveType(typeId: 12)
class BackgroundSettings {
  @HiveField(0)
  BackgroundType type;

  @HiveField(2)
  int colorValue;

  @HiveField(3)
  int textColorValue;

  @HiveField(1)
  String? imagePath;

  @HiveField(4)
  bool autoTextColor;

  BackgroundSettings({
    this.type = BackgroundType.default_bg,
    this.colorValue = 0xFFFFFFFF, // أبيض افتراضي
    this.textColorValue = 0xFF000000, // أسود افتراضي
    this.imagePath,
    this.autoTextColor = true,
  });

  // إعدادات افتراضية
  factory BackgroundSettings.defaultSettings() {
    return BackgroundSettings(
      type: BackgroundType.default_bg,
      colorValue: 0xFFFFFFFF,
      textColorValue: 0xFF000000,
      imagePath: null,
      autoTextColor: true,
    );
  }

  // تحويل من JSON
  factory BackgroundSettings.fromJson(Map<String, dynamic> json) {
    return BackgroundSettings(
      type: _parseBackgroundType(json['type']),
      colorValue: json['colorValue'] as int? ?? 0xFFFFFFFF,
      textColorValue: json['textColorValue'] as int? ?? 0xFF000000,
      imagePath: json['imagePath'] as String?,
      autoTextColor: json['autoTextColor'] as bool? ?? true,
    );
  }

  // تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type.index,
      'colorValue': colorValue,
      'textColorValue': textColorValue,
      'imagePath': imagePath,
      'autoTextColor': autoTextColor,
    };
  }

  // دالة مساعدة لتحويل القيمة إلى نوع الخلفية
  static BackgroundType _parseBackgroundType(dynamic value) {
    if (value is BackgroundType) {
      return value;
    } else if (value is int &&
        value >= 0 &&
        value < BackgroundType.values.length) {
      return BackgroundType.values[value];
    } else {
      return BackgroundType.default_bg;
    }
  }
}

// فئة فارغة مطلوبة فقط للتوافق مع ملف app_settings.g.dart المولّد تلقائيًا
@HiveType(typeId: 11)
class SocialMediaAccount {
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
