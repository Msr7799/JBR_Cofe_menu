import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/services/shared_preferences_service.dart';
import 'package:gpr_coffee_shop/screens/home_screen.dart';

class AppTranslationService extends GetxService {
  final Rx<TextDirection> textDirection = TextDirection.rtl.obs;
  final Rx<Locale> currentLocale = const Locale('ar').obs;

  late SharedPreferencesService _prefsService;

  @override
  void onInit() {
    super.onInit();
    _prefsService = Get.find<SharedPreferencesService>();

    // Initialize from saved preferences
    final String savedLanguage = _prefsService.getLanguage();
    currentLocale.value = Locale(savedLanguage);

    // Set initial text direction based on language
    updateTextDirectionFromLanguage(savedLanguage);
  }

  void updateTextDirectionFromLanguage(String languageCode) {
    final newDirection =
        (languageCode == 'ar') ? TextDirection.rtl : TextDirection.ltr;

    textDirection.value = newDirection;
  }

  void updateTextDirection(TextDirection direction) {
    textDirection.value = direction;
  }

  TextDirection getTextDirection() {
    return textDirection.value;
  }

  Future<void> changeLocale(String languageCode) async {
    try {
      // Save the language preference
      await _prefsService.saveLanguage(languageCode);

      // Update the current locale
      currentLocale.value = Locale(languageCode);

      // Update the text direction
      updateTextDirectionFromLanguage(languageCode);

      // Set the locale directly
      Get.locale = Locale(languageCode);

      // Update translations
      Get.updateLocale(Locale(languageCode));

      // Force rebuild for immediate effect
      await Future.delayed(const Duration(milliseconds: 50));
      Get.forceAppUpdate();

      // تأكد من تحديث الواجهة بعد تغيير اللغة - استخدام Get.offAll بشكل صحيح
      if (Get.currentRoute == '/') {
        Get.offAll(() => const HomeScreen());
      } else {
        // إعادة تحميل الصفحة الحالية
        final currentRoute = Get.currentRoute;
        Get.offAllNamed(currentRoute);
      }
    } catch (e) {
      print('Error changing language: $e');
      Get.snackbar(
        languageCode == 'ar' ? 'خطأ' : 'Error',
        languageCode == 'ar' ? 'فشل تغيير اللغة' : 'Failed to change language',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Helper method to get font family based on language
  String getFontFamily() {
    return currentLocale.value.languageCode == 'ar' ? 'Cairo' : 'Roboto';
  }

  // Helper method to get if the current locale is RTL
  bool isRtl() {
    return currentLocale.value.languageCode == 'ar';
  }
}
