import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gpr_coffee_shop/services/shared_preferences_service.dart';
import 'package:gpr_coffee_shop/models/app_settings.dart';
import 'package:gpr_coffee_shop/services/local_storage_service.dart';
import 'package:gpr_coffee_shop/services/app_translation_service.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/utils/logger_util.dart';
import 'package:gpr_coffee_shop/utils/image_helper.dart'; // إضافة هذا الاستيراد
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class SettingsController extends GetxController {
  
  final SharedPreferencesService _prefsService =
      Get.find<SharedPreferencesService>();
  final LocalStorageService _storageService = Get.find<LocalStorageService>();

  // Add isLoading property
  final RxBool isLoading = false.obs;

  // Observable AppSettings object
  final Rx<AppSettings> settings = AppSettings.defaultSettings().obs;

  // قائمة بجميع الثيمات المتاحة مع أسمائها المعروضة
  final List<Map<String, String>> availableThemes = [
    {'key': 'light', 'name': 'الوضع الفاتح'},
    {'key': 'dark', 'name': 'الوضع الداكن'},
    {'key': 'coffee', 'name': 'كوفي كلاسيك'},
    {'key': 'sweet', 'name': 'سويت باستيل'},
  ];

  // Predefined colors for background
  final List<Color> predefinedBackgroundColors = [
    Colors.white,
    Colors.black,
    const Color(0xFFD0B8A8), // Coffee brown color
    const Color(0xFF7D6E83), // Lavender gray
    const Color(0xFFF8EDE3), // Cream color
  ];

  // Predefined colors for text
  final List<Color> predefinedTextColors = [
    Colors.white,
    Colors.black,
    const Color(0xFF000080), // Navy blue
    const Color(0xFF800000), // Maroon
  ];

  // Convenience getters
  String get themeMode => settings.value.themeMode;
  String get language => settings.value.language;

  // Getters for background and text settings
  BackgroundType get backgroundType => settings.value.backgroundSettings.type;
  String? get backgroundImagePath =>
      settings.value.backgroundSettings.imagePath;
  Color get backgroundColor =>
      Color(settings.value.backgroundSettings.colorValue);
  Color get textColor =>
      Color(settings.value.backgroundSettings.textColorValue);
  bool get autoTextColor => settings.value.backgroundSettings.autoTextColor;

  // الحصول على اسم الثيم الحالي
  String get themeDisplayName {
    final theme = availableThemes.firstWhere(
      (theme) => theme['key'] == themeMode,
      orElse: () => availableThemes.first,
    );
    return theme['name'] ?? 'الوضع الفاتح';
  }

  // خاصية طريقة عرض المنيو
  String get menuViewMode => settings.value.menuViewMode;

  // تعيين طريقة عرض جديدة
  Future<void> setMenuViewMode(String mode) async {
    settings.update((val) {
      val?.menuViewMode = mode;
    });
    await saveSettings();
    update();
  }

  // Text scale factor for app-wide font size
  double _textScaleFactor = 1.0;
  double get textScaleFactor => _textScaleFactor;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
    _loadSettings();
  }

  void _loadSettings() {
    // تحميل مقياس النص
    _textScaleFactor =
        _prefsService.getDouble('text_scale_factor', defaultVal: 1.0);
    update();
  }

  void setTextScaleFactor(double value) {
    _textScaleFactor = value;
    _prefsService.setDouble('text_scale_factor', value);
    update();
  }

  Future<void> loadSettings() async {
    isLoading.value = true;
    try {
      // First try to load from Hive (main storage)
      final storedSettings = await _storageService.getSettings();
      if (storedSettings != null) {
        settings.value = storedSettings;
      } else {
        // If not available in Hive, try loading from SharedPreferences as fallback
        final themeString =
            _prefsService.getString('theme', defaultVal: 'system');
        final language = _prefsService.getLanguage();

        // Create new settings object with correct parameters
        settings.value = AppSettings(
          themeMode:
              themeString, // themeMode في نموذج AppSettings هو من نوع String
          language: language,
          fontSize: 1.0,
          appName: 'JBR Coffee Shop',
          isFirstRun: _prefsService.getBool('isFirstRun', defaultVal: true),
        );

        // Save to main storage
        await saveSettings();
      }
    } catch (e) {
      LoggerUtil.logger.e('Error loading settings: $e');
      // Use defaults if both storage methods fail
    } finally {
      isLoading.value = false;
    }
  }

  // تعديل دالة saveSettings
  Future<void> saveSettings() async {
    isLoading.value = true;
    try {
      // حفظ في Hive (التخزين الرئيسي)
      await _storageService.saveSettings(settings.value);

      // حفظ الإعدادات المهمة في SharedPreferences كنسخة احتياطية
      await _prefsService.setString('theme', settings.value.themeMode);
      await _prefsService.setLanguage(settings.value.language);
      await _prefsService.setBool('isFirstRun', settings.value.isFirstRun);

      // تحديث الواجهة (بدون فرض تحديث التطبيق بأكمله)
      update();

      // تجنب استخدام Get.forceAppUpdate() بشكل متكرر
      // Get.forceAppUpdate();
    } catch (e) {
      LoggerUtil.logger.e('Error saving settings: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setThemeMode(String mode) async {
    // التأكد من أن الوضع المطلوب متاح في قائمة الثيمات
    final themeExists = availableThemes.any((theme) => theme['key'] == mode);
    if (!themeExists) {
      mode = 'light'; // الرجوع للثيم الافتراضي إذا كان الثيم غير متاح
    }

    settings.update((val) {
      val?.themeMode = mode;
    });
    await saveSettings();

    // تطبيق الثيم الجديد فورًا
    Get.changeThemeMode(_getThemeMode(mode));

    // Apply specific theme based on mode
    if (mode == 'light') {
      Get.changeTheme(AppTheme.lightTheme);
    } else if (mode == 'dark') {
      Get.changeTheme(AppTheme.darkTheme);
    } else if (mode == 'coffee') {
      Get.changeTheme(AppTheme.coffeeTheme);
    } else if (mode == 'sweet') {
      Get.changeTheme(AppTheme.sweetTheme);
    }

    update();

    // Force update to ensure theme is applied throughout the app
    Get.forceAppUpdate();

    // إظهار رسالة تأكيد
    Get.snackbar(
      'تم تغيير المظهر',
      'تم تغيير مظهر التطبيق إلى $themeDisplayName',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // تحديد وضع الثيم (ضوئي أو داكن) للواجهة
  ThemeMode _getThemeMode(String mode) {
    switch (mode) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      case 'coffee':
        // تطبيق ثيم القهوة مع الوضع الفاتح
        Get.changeTheme(AppTheme.coffeeTheme);
        return ThemeMode.light;
      case 'sweet':
        // تطبيق ثيم الحلويات مع الوضع الفاتح
        Get.changeTheme(AppTheme.sweetTheme);
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      default:
        // العودة للوضع الفاتح كافتراضي
        return ThemeMode.light;
    }
  }

  // تحسين دالة تغيير اللغة لتجنب التحديثات المتزامنة
  Future<void> setLanguage(String languageCode) async {
    try {
      isLoading.value = true;

      // تحديث قيمة اللغة في الإعدادات
      settings.update((val) {
        val?.language = languageCode;
      });

      // حفظ الإعدادات أولاً
      await saveSettings();

      // استخدام خدمة الترجمة لتغيير اللغة واتجاه النص
      final translationService = Get.find<AppTranslationService>();
      await translationService.changeLocale(languageCode);

      // تحديث واجهة المستخدم
      update();

      // عرض رسالة نجاح بناءً على اللغة المختارة
      Get.snackbar(
        'language_changed'.tr,
        languageCode == 'ar'
            ? 'تم تغيير اللغة بنجاح'
            : 'Language changed successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      // لا نحتاج لـ Get.offAll هنا لأن changeLocale تقوم بذلك بالفعل
    } catch (e) {
      LoggerUtil.logger.e('Error changing language: $e');
      Get.snackbar(
        'خطأ',
        'فشل تغيير اللغة',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setAppName(String name) async {
    settings.update((val) {
      val?.appName = name;
    });
    await saveSettings();
    update();
  }

  Future<void> setFirstRunCompleted() async {
    settings.update((val) {
      val?.isFirstRun = false;
    });
    await saveSettings();
    update();
  }

  // دالة لتعيين رابط صورة باركود البنفت بي
  Future<void> setBenefitPayQrCodeUrl(String url) async {
    settings.update((val) {
      val?.benefitPayQrCodeUrl = url;
    });
    await saveSettings();
    update();
  }

  // دالة للحصول على رابط صورة باركود البنفت بي
  String? get benefitPayQrCodeUrl => settings.value.benefitPayQrCodeUrl;

  // Update background type
  Future<void> setBackgroundType(BackgroundType type) async {
    settings.update((val) {
      val?.backgroundSettings.type = type;
    });
    await saveSettings();
    update();

    Get.snackbar(
      'تم تغيير الخلفية',
      'تم تغيير خلفية الشاشة الرئيسية',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Set text color
  Future<void> setTextColor(Color color, bool auto) async {
    settings.update((val) {
      val?.backgroundSettings.textColorValue = color.toARGB32();
      val?.backgroundSettings.autoTextColor = auto;
    });
    await saveSettings();
    update();

    Get.snackbar(
      'تم تغيير لون النص',
      'تم تطبيق لون النص الجديد على الشاشة الرئيسية',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Determine best text color based on background
  Color getAdaptiveTextColor(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }

  // Set background color with automatic text color adjustment
  Future<void> setBackgroundColor(Color color) async {
    // If auto text color is enabled, adjust text color based on background
    if (autoTextColor) {
      final newTextColor = getAdaptiveTextColor(color);
      settings.update((val) {
        val?.backgroundSettings.type = BackgroundType.color;
        val?.backgroundSettings.colorValue = color.toARGB32();
        val?.backgroundSettings.textColorValue = newTextColor.toARGB32();
      });
    } else {
      settings.update((val) {
        val?.backgroundSettings.type = BackgroundType.color;
        val?.backgroundSettings.colorValue = color.toARGB32();
      });
    }

    await saveSettings();
    update();

    // Force update the home screen to reflect background changes
    Get.forceAppUpdate();

    Get.snackbar(
      'تم تغيير الخلفية',
      'تم تطبيق اللون الجديد على الشاشة الرئيسية',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Pick and set background image
  Future<void> pickAndSetBackgroundImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        // حذف الصورة السابقة إذا وجدت
        if (backgroundType == BackgroundType.image &&
            backgroundImagePath != null &&
            File(backgroundImagePath!).existsSync()) {
          try {
            await File(backgroundImagePath!).delete();
          } catch (e) {
            LoggerUtil.logger.e('Error deleting previous background: $e');
          }
        }

        // حفظ الصورة الجديدة في مجلد التطبيق
        final appDir = await getApplicationDocumentsDirectory();
        final fileName =
            'bg_${DateTime.now().millisecondsSinceEpoch}${path.extension(pickedFile.path)}';
        final savedImagePath = path.join(appDir.path, 'backgrounds', fileName);

        // التأكد من وجود المجلد
        final directory = Directory(path.join(appDir.path, 'backgrounds'));
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        // نسخ الصورة
        final File imageFile = File(pickedFile.path);
        final File copiedFile = await imageFile.copy(savedImagePath);

        // التحقق من أن الملف تم نسخه بنجاح
        if (!await copiedFile.exists()) {
          throw Exception('Failed to save image file');
        }

        // طباعة معلومات تصحيح
        LoggerUtil.logger.i('Image saved to: $savedImagePath');
        LoggerUtil.logger.i('File exists: ${await copiedFile.exists()}');
        LoggerUtil.logger.i('File size: ${await copiedFile.length()} bytes');

        // تحديث الإعدادات
        settings.update((val) {
          val?.backgroundSettings.type = BackgroundType.image;
          val?.backgroundSettings.imagePath = savedImagePath;
        });
        await saveSettings();
        update();

        Get.snackbar(
          'تم تغيير الخلفية',
          'تم تطبيق الصورة الجديدة كخلفية للشاشة الرئيسية',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );

        // فرض تحديث الشاشة الرئيسية
        Get.forceAppUpdate();
      }
    } catch (e) {
      LoggerUtil.logger.e('Error picking background image: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء اختيار الصورة: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Reset to default background also resets text color
  Future<void> resetToDefaultBackground() async {
    // If there's a custom background image, delete it
    if (backgroundType == BackgroundType.image &&
        backgroundImagePath != null &&
        File(backgroundImagePath!).existsSync()) {
      try {
        await File(backgroundImagePath!).delete();
      } catch (e) {
        LoggerUtil.logger.e('Error deleting background: $e');
      }
    }

    // Reset to default settings
    settings.update((val) {
      val?.backgroundSettings = BackgroundSettings.defaultSettings();
    });
    await saveSettings();
    update();

    Get.snackbar(
      'تم إعادة الضبط',
      'تم إعادة الخلفية إلى الوضع الافتراضي',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // دالة للحصول على مسار صورة اللوغو
  String? get logoPath => settings.value.logoPath;

  // دالة لتعيين مسار صورة اللوغو - إصدار محسن ومستقر
  Future<void> setLogoPath(String path) async {
    // التحقق من صلاحية المسار قبل محاولة التعيين
    if (path.isEmpty) {
      LoggerUtil.logger.w('محاولة تعيين مسار فارغ للوغو');
      return;
    }

    // بدء عملية التحميل
    isLoading.value = true;
    
    try {
      // التحقق من أن الصورة صالحة قبل تطبيقها
      final bool isValidImage = path.startsWith('assets/') || 
          (File(path).existsSync() && await File(path).length() > 0);
      
      if (!isValidImage) {
        throw Exception('صورة اللوغو غير صالحة أو غير موجودة: $path');
      }
      
      
      // تحديث إعدادات اللوغو في الذاكرة
      settings.update((val) {
        val?.logoPath = path;
      });
      
      // حفظ الإعدادات في التخزين المستمر
      await saveSettings();
      
      // تحديث الواجهة بشكل محدد باستخدام معرف
      update(['app_logo']);
      
      // عرض رسالة نجاح
      Get.snackbar(
        'تم التغيير',
        'تم تغيير شعار التطبيق بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withAlpha(200),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e, stackTrace) {
      // تسجيل الخطأ بالتفصيل
      LoggerUtil.error('خطأ في تغيير شعار التطبيق:', e, stackTrace);
      
      // استعادة المسار القديم إذا كان متاحًا
      if (settings.value.logoPath != 'assets/images/logo.png') {
        settings.update((val) {
          val?.logoPath = 'assets/images/logo.png';
        });
        
        try {
          await saveSettings();
          update(['app_logo']);
        } catch (_) {
          // تجاهل أي أخطاء أخرى هنا لمنع سلسلة من الاستثناءات
        }
      }
      
      // إظهار رسالة خطأ للمستخدم
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تغيير شعار التطبيق. تم استعادة الشعار الافتراضي.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withAlpha(200),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      // إنهاء حالة التحميل
      isLoading.value = false;
    }
  }

  // اختيار وتطبيق لوغو مخصص
  Future<bool> pickAndSetCustomLogo() async {
    try {
      // عرض مؤشر التحميل
      isLoading(true);

      // استخدام ImageHelper.pickImage بدلاً من image_picker مباشرة
      final File? pickedFile = await ImageHelper.pickImage(source: ImageSource.gallery);

      // إذا لم يختر المستخدم صورة
      if (pickedFile == null) {
        isLoading(false);
        return false;
      }

      // الاحتفاظ بمسار اللوغو القديم للحذف لاحقاً
      final String? oldPath = logoPath;
      
      // نسخ الصورة إلى مجلد التطبيق
      final customLogoPath = await ImageHelper.copyImageToAppDirectory(pickedFile.path);

      if (customLogoPath != null) {
        // تغيير حجم الصورة وحفظها مع الحفاظ على نسبة العرض للارتفاع
        final resizedPath = await ImageHelper.resizeAndSaveImage(
          customLogoPath,
          targetWidth: 300,
          targetHeight: 300,
          keepAspectRatio: true,
        );

        // تعيين مسار اللوغو الجديد
        await setLogoPath(resizedPath ?? customLogoPath);
        
        // حذف الملف القديم إذا كان موجوداً ولم يكن من الأصول
        if (oldPath != null && oldPath.isNotEmpty && !oldPath.startsWith('assets/')) {
          await ImageHelper.safeDeleteImage(oldPath);
        }
        
        isLoading(false);
        return true;
      }

      isLoading(false);
      return false;
    } catch (e) {
      LoggerUtil.logger.e('فشل في اختيار وتعيين اللوغو المخصص: $e');
      isLoading(false);
      return false;
    }
  }

}
