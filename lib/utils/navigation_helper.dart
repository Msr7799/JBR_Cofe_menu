import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/screens/splash_screen.dart';
import 'package:gpr_coffee_shop/utils/logger_util.dart';

class NavigationHelper {
  /// دالة مساعدة للتنقل إلى شاشة المنيو مع شاشة البداية
  static void navigateToMenuWithSplash() {
    Get.off(() => const SplashScreen(
          nextRoute: '/menu',
        ));
  }

  /// دالة مساعدة للتنقل إلى شاشة المنيو مباشرة
  static void navigateToMenu() {
    Get.toNamed('/menu');
  }

  /// دالة آمنة للتنقل إلى أي مسار محدد مع معالجة الأخطاء
  static void navigateToRoute(String route,
      {Map<String, dynamic>? arguments, bool showSplash = false}) {
    try {
      if (showSplash) {
        Get.off(() => SplashScreen(nextRoute: route));
      } else if (arguments != null) {
        Get.toNamed(route, arguments: arguments);
      } else {
        Get.toNamed(route);
      }
    } catch (e) {
      LoggerUtil.logger.e('خطأ أثناء التنقل إلى المسار $route: $e');
      Get.snackbar(
        'خطأ في التنقل',
        'تعذر الانتقال إلى الصفحة المطلوبة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  /// دالة للتنقل إلى الخلف مع معالجة الأخطاء
  static void goBack({dynamic result}) {
    try {
      if (Get.previousRoute.isNotEmpty) {
        Get.back(result: result);
      } else {
        Get.offAllNamed('/home');
      }
    } catch (e) {
      LoggerUtil.logger.e('خطأ أثناء العودة: $e');
      Get.offAllNamed('/home');
    }
  }

  /// دالة للتحقق إذا كان المسار نشطًا حاليًا
  static bool isCurrentRoute(String route) {
    return Get.currentRoute == route;
  }
}
