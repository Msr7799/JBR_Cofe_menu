import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/services/shared_preferences_service.dart';
import 'package:gpr_coffee_shop/screens/home_screen.dart';
import 'package:gpr_coffee_shop/utils/logger_util.dart';

// Changed from GetxService to GetxController to fix type bound error with GetBuilder
class AppTranslationService extends GetxController {
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

      // Log success for debugging
      LoggerUtil.logger.i('تغيير اللغة إلى: $languageCode');

      // Update the UI to reflect the changes
      update(['language_switcher']);

      // Use a more reliable approach to rebuild the UI after language change
      await Future.delayed(const Duration(milliseconds: 100));

      // Force app update in a safe way using separate microtask
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.microtask(() {
          Get.forceAppUpdate();

          // Only navigate if needed - avoid rebuilding during layout
          if (Get.currentRoute == '/') {
            // Use a safer way to refresh the home screen
            final currentContext = Get.context;
            if (currentContext != null && currentContext.mounted) {
              Get.offAll(() => const HomeScreen(),
                  transition: Transition.fade,
                  duration: const Duration(milliseconds: 300));
            }
          } else {
            // For other routes, just update the locale without navigation
            // This avoids layout issues during rebuilds
            LoggerUtil.logger.i('تم تحديث اللغة للشاشة: ${Get.currentRoute}');
          }
        });
      });

      return;
    } catch (e) {
      LoggerUtil.logger.e('خطأ في تغيير اللغة: $e');
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
