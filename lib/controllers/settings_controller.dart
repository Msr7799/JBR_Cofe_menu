import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gpr_coffee_shop/services/shared_preferences_service.dart';
import 'package:gpr_coffee_shop/models/app_settings.dart';
import 'package:gpr_coffee_shop/services/local_storage_service.dart';
import 'package:gpr_coffee_shop/services/app_translation_service.dart';
import 'package:gpr_coffee_shop/screens/home_screen.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/utils/logger_util.dart';
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
    Color(0xFFD0B8A8), // Coffee brown color
    Color(0xFF7D6E83), // Lavender gray
    Color(0xFFF8EDE3), // Cream color
  ];

  // Predefined colors for text
  final List<Color> predefinedTextColors = [
    Colors.white,
    Colors.black,
    Color(0xFF000080), // Navy blue
    Color(0xFF800000), // Maroon
  ];

  // Convenience getters
  String get themeMode => settings.value.themeMode;
  String get language => settings.value.language;
  List<SocialMediaAccount> get socialAccounts => settings.value.socialAccounts;

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

  @override
  void onInit() {
    super.onInit();
    loadSettings();
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
        final themeMode = _prefsService.getThemeMode();
        final language = _prefsService.getLanguage();

        // Create new settings object
        settings.value = AppSettings(
          themeMode: themeMode,
          language: language,
          fontSize: 1.0,
          socialAccounts: [],
          appName: 'GPR Coffee Shop',
          isFirstRun: _prefsService.getBool('isFirstRun', defaultValue: true),
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

  Future<void> saveSettings() async {
    isLoading.value = true;
    try {
      // Save to Hive (main storage)
      await _storageService.saveSettings(settings.value);

      // Also save critical settings to SharedPreferences as backup
      await _prefsService.saveThemeMode(settings.value.themeMode);
      await _prefsService.saveLanguage(settings.value.language);
      await _prefsService.saveBool('isFirstRun', settings.value.isFirstRun);
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
    update();

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

  Future<void> setLanguage(String languageCode) async {
    try {
      isLoading.value = true;

      // Update settings value
      settings.update((val) {
        val?.language = languageCode;
      });

      // Save settings to both storages
      await saveSettings();

      // Create and update locale
      final locale = Locale(languageCode);

      // Update translations first
      Get.updateLocale(locale);

      // Then update the translation service for text direction
      final translationService = Get.find<AppTranslationService>();
      await translationService.changeLocale(languageCode);

      // Force rebuild of all Getx widgets
      Get.forceAppUpdate();

      // Reset the app state
      Get.delete<AppTranslationService>();
      Get.put(AppTranslationService());
      Get.forceAppUpdate();

      // Show confirmation message
      await Future.delayed(const Duration(milliseconds: 100));
      Get.snackbar(
        'success'.tr,
        'language_changed'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );

      // Restart the app with a clean state
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAll(() => HomeScreen(), transition: Transition.fade);
    } catch (e) {
      LoggerUtil.logger.e('Error changing language: $e');
      final isArabic = Get.locale?.languageCode == 'ar';
      Get.snackbar(
        isArabic ? 'خطأ' : 'Error',
        isArabic ? 'فشل تغيير اللغة' : 'Failed to change language',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addSocialAccount(SocialMediaAccount account) async {
    settings.update((val) {
      val?.socialAccounts.add(account);
    });
    await saveSettings();
    update();
  }

  Future<void> removeSocialAccount(String id) async {
    settings.update((val) {
      val?.socialAccounts.removeWhere((account) => account.id == id);
    });
    await saveSettings();
    update();
  }

  Future<void> updateSocialAccount(SocialMediaAccount account) async {
    settings.update((val) {
      final index =
          val?.socialAccounts.indexWhere((a) => a.id == account.id) ?? -1;
      if (index != -1) {
        val?.socialAccounts[index] = account;
      }
    });
    await saveSettings();
    update();
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
      val?.backgroundSettings.textColorValue = color.value;
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
        val?.backgroundSettings.colorValue = color.value;
        val?.backgroundSettings.textColorValue = newTextColor.value;
      });
    } else {
      settings.update((val) {
        val?.backgroundSettings.type = BackgroundType.color;
        val?.backgroundSettings.colorValue = color.value;
      });
    }

    await saveSettings();
    update();

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
        // Delete previous custom background if exists
        if (backgroundType == BackgroundType.image &&
            backgroundImagePath != null &&
            File(backgroundImagePath!).existsSync()) {
          try {
            await File(backgroundImagePath!).delete();
          } catch (e) {
            LoggerUtil.logger.e('Error deleting previous background: $e');
          }
        }

        // Save the new image to app documents directory
        final appDir = await getApplicationDocumentsDirectory();
        final fileName =
            'bg_${DateTime.now().millisecondsSinceEpoch}${path.extension(pickedFile.path)}';
        final savedImagePath = path.join(appDir.path, 'backgrounds', fileName);

        // Ensure directory exists
        final directory = Directory(path.join(appDir.path, 'backgrounds'));
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        // Copy the image
        final File imageFile = File(pickedFile.path);
        await imageFile.copy(savedImagePath);

        // Update settings
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
      }
    } catch (e) {
      LoggerUtil.logger.e('Error picking background image: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء اختيار الصورة',
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
}
