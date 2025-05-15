import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/services/app_translation_service.dart';
import 'package:gpr_coffee_shop/utils/logger_util.dart';

abstract class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({Key? key}) : super(key: key);

 
  // Language switcher widget - Circle toggle that slides left/right to switch languages
  Widget _buildLanguageSwitcher() {
    // Use a safer approach with GetBuilder that handles rebuilds better
    return GetBuilder<AppTranslationService>(
      id: 'language_switcher',
      builder: (translationService) {
        // Get current locale from translation service
        final isArabic =
            translationService.currentLocale.value.languageCode == 'ar';

        return Container(
          width: 60,
          height: 36,
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          // Use Stack with AnimatedPositioned for the sliding effect
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Material(
              color: const Color.fromARGB(0, 255, 255, 255),
              child: Stack(
                children: [
                  // The sliding indicator
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    left: isArabic ? 2 : 30,
                    top: 2,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 125, 122, 160),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 20, 20, 20)
                                .withOpacity(0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Language text options with improved tap targets
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Arabic option
                      Expanded(
                        child: InkWell(
                          onTap: () => _changeLanguageSafely('ar'),
                          child: Center(
                            child: Text(
                              'AR',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isArabic
                                    ? const Color.fromARGB(255, 0, 0, 0)
                                    : const Color.fromARGB(137, 255, 255, 255),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // English option
                      Expanded(
                        child: InkWell(
                          onTap: () => _changeLanguageSafely('en'),
                          child: Center(
                            child: Text(
                              'EN',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: !isArabic
                                    ? const Color.fromARGB(255, 0, 0, 0)
                                    : const Color.fromARGB(137, 254, 254, 254),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Change application language with error handling and debouncing
  void _changeLanguageSafely(String languageCode) async {
    try {
      // Prevent multiple quick taps that could cause layout issues
      DateTime? lastTap;
      final now = DateTime.now();

      // Debounce language switching to prevent multiple rapid changes
      // ignore: unnecessary_null_comparison
      if (lastTap != null &&
          now.difference(lastTap) < const Duration(seconds: 2)) {
        LoggerUtil.logger
            .i('تم تجاهل تغيير اللغة - التغيير الأخير كان منذ وقت قصير');
        return;
      }
      lastTap = now;

      // Get the AppTranslationService
      final appTranslationService = Get.find<AppTranslationService>();

      // Don't change if already using this language
      if (appTranslationService.currentLocale.value.languageCode ==
          languageCode) {
        return;
      }

      // Show loading indicator to prevent user interaction during transition
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      // Small delay to ensure loading dialog appears
      await Future.delayed(const Duration(milliseconds: 50));

      // Change language
      await appTranslationService.changeLocale(languageCode);

      // Close loading dialog
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    } catch (e) {
      // Close loading dialog if open
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      LoggerUtil.logger.e('خطأ في تغيير اللغة: $e');

      // Show error message
      Get.snackbar(
        'error'.tr,
        'language_change_failed'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
}

