import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/auth_controller.dart';
import 'package:gpr_coffee_shop/controllers/settings_controller.dart';
import 'package:gpr_coffee_shop/screens/admin/admin_dashboard.dart';
import 'package:gpr_coffee_shop/screens/admin/login_screen.dart';
import 'package:gpr_coffee_shop/screens/about_screen.dart';
import 'package:gpr_coffee_shop/screens/view_options_screen.dart';
import 'package:gpr_coffee_shop/services/shared_preferences_service.dart';
import 'package:gpr_coffee_shop/utils/image_helper.dart';
import 'package:gpr_coffee_shop/utils/logger_util.dart';
import 'package:url_launcher/url_launcher.dart';

/// File containing sidebar menu elements for the app
class HomeDrawer {
  /// Build the main sidebar menu
  static Widget buildMainDrawer(BuildContext context) {
    // Get the required controllers
    final settingsController = Get.find<SettingsController>();
    final authController = Get.find<AuthController>();

    // Determine if the user is logged in
    final bool isLoggedIn = authController.isLoggedIn.value;
    final bool isAdmin = authController.isAdmin.value;

    // Determine screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 230;

    return Drawer(
      backgroundColor: Colors.white,
      elevation: 0,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer header
            buildDrawerHeader(
                isLoggedIn, isAdmin, isSmallScreen, settingsController),

            const Divider(),

            // Main menu items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  buildDrawerItem(
                    icon: Icons.home_rounded,
                    title: 'home'.tr,
                    onTap: () {
                      Get.back();
                      Get.offAllNamed('/home');
                    },
                    isSmallScreen: isSmallScreen,
                    isActive: Get.currentRoute == '/home',
                  ),
                  if (isAdmin) ...[
                    const Divider(),
                    buildDrawerItem(
                      icon: Icons.dashboard,
                      title: 'dashboard'.tr,
                      onTap: () {
                        Get.back();
                        Get.to(() => const AdminDashboard());
                      },
                      isSmallScreen: isSmallScreen,
                      isActive: Get.currentRoute.startsWith('/admin'),
                    ),
                    buildDrawerItem(
                      icon: Icons.receipt_long,
                      title: 'إدارة الطلبات',
                      onTap: () {
                        Get.back();
                        Get.toNamed('/admin/orders');
                      },
                      isSmallScreen: isSmallScreen,
                      isActive: Get.currentRoute.startsWith('/admin/orders'),
                    ),
                  ],
                  const Divider(),
                  buildDrawerItem(
                    icon: Icons.color_lens,
                    title: 'خيارات العرض',
                    onTap: () {
                      Get.back();
                      Get.to(() => ViewOptionsScreen());
                    },
                    isSmallScreen: isSmallScreen,
                    isActive: Get.currentRoute.startsWith('/view-options'),
                  ),
                  buildDrawerItem(
                    icon: Icons.info_rounded,
                    title: 'عن التطبيق',
                    onTap: () {
                      Get.back();
                      Get.to(() => const AboutScreen());
                    },
                    isSmallScreen: isSmallScreen,
                    isActive: Get.currentRoute.startsWith('/about'),
                  ),
                  buildDrawerItem(
                    icon: Icons.help_rounded,
                    title: 'المساعدة والدعم',
                    onTap: () {
                      Get.back();
                      launchSupportWebsite();
                    },
                    isSmallScreen: isSmallScreen,
                  ),
                ],
              ),
            ),

            const Divider(),

            // زر تسجيل الدخول/الخروج
            buildAuthButton(isLoggedIn, isSmallScreen, authController),

            // معلومات الإصدار
            const SizedBox(height: 8),
            buildVersionInfo(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  /// بناء رأس القائمة الجانبية
  static Widget buildDrawerHeader(bool isLoggedIn, bool isAdmin,
      bool isSmallScreen, SettingsController settingsController) {
    final logoPath = settingsController.logoPath ?? 'assets/images/logo.png';

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isSmallScreen ? 16 : 20,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.05),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.primaryColor.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // شعار التطبيق
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: isSmallScreen ? 36 : 44,
                  height: isSmallScreen ? 36 : 44,
                  child: ImageHelper.buildImage(
                    logoPath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'JBR coffee',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  Text(
                    'مذاق أصيل بنكهة عربية',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // معلومات الوضع الإداري
          if (isAdmin) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.amber.shade700,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.admin_panel_settings,
                    size: isSmallScreen ? 16 : 18,
                    color: Colors.amber.shade900,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'وضع المدير',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// بناء عنصر في القائمة الجانبية
  static Widget buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isActive = false,
    required bool isSmallScreen,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isActive
                  ? AppTheme.primaryColor.withOpacity(0.1)
                  : Colors.transparent,
              border: Border.all(
                color: isActive
                    ? AppTheme.primaryColor.withOpacity(0.3)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: isSmallScreen ? 8 : 12,
              horizontal: isSmallScreen ? 12 : 16,
            ),
            child: Row(
              children: [
                Container(
                  width: isSmallScreen
                      ? 28
                      : 32, // Smaller icon container for small screens
                  height: isSmallScreen ? 28 : 32,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppTheme.primaryColor.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(isSmallScreen ? 6 : 8),
                  ),
                  child: Icon(
                    icon,
                    color:
                        isActive ? AppTheme.primaryColor : Colors.grey.shade700,
                    size: isSmallScreen
                        ? 16
                        : 18, // Smaller icon for small screens
                  ),
                ),
                SizedBox(
                    width: isSmallScreen
                        ? 8
                        : 12), // Reduce spacing on small screens
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 13 : 14,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color:
                        isActive ? AppTheme.primaryColor : Colors.grey.shade800,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// بناء زر تسجيل الدخول/الخروج
  static Widget buildAuthButton(
      bool isLoggedIn, bool isSmallScreen, AuthController authController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton(
        onPressed: () {
          Get.back();
          if (isLoggedIn) {
            showLogoutConfirmation(authController);
          } else {
            Get.to(() => const LoginScreen());
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: isLoggedIn ? Colors.white : AppTheme.primaryColor,
          backgroundColor:
              isLoggedIn ? Colors.red.shade600 : Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.symmetric(
            vertical: isSmallScreen ? 10 : 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: isLoggedIn
                ? BorderSide.none
                : const BorderSide(color: AppTheme.primaryColor),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isLoggedIn ? Icons.logout_rounded : Icons.login_rounded,
              size: isSmallScreen ? 18 : 20,
            ),
            const SizedBox(width: 8),
            Text(
              isLoggedIn ? 'تسجيل الخروج' : 'تسجيل الدخول',
              style: TextStyle(
                fontSize: isSmallScreen ? 13 : 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// عرض مربع حوار لتأكيد تسجيل الخروج
  static void showLogoutConfirmation(AuthController authController) {
    Get.dialog(
      AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              // تنفيذ تسجيل الخروج
              authController.logout();
              Get.back();
              Get.offAllNamed('/home');

              // عرض إشعار نجاح تسجيل الخروج
              Get.snackbar(
                'تم تسجيل الخروج',
                'تم تسجيل خروجك بنجاح',
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(8),
                backgroundColor: Colors.green.shade700,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
            ),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }

  /// فتح موقع الدعم الفني
  static Future<void> launchSupportWebsite() async {
    try {
      const url = 'https://www.example.com/support';
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'تعذر فتح الرابط $url';
      }
    } catch (e) {
      LoggerUtil.logger.e('خطأ في فتح موقع الدعم: $e');
      Get.snackbar(
        'خطأ',
        'تعذر فتح موقع الدعم الفني',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  /// بناء معلومات الإصدار
  static Widget buildVersionInfo() {
    // استخدام القيمة المخزنة في التفضيلات المشتركة أو القيمة الافتراضية
    final prefs = Get.find<SharedPreferencesService>();
    // استبدال دالة غير موجودة بطريقة صحيحة للحصول على إصدار التطبيق
    final appVersion = prefs.getString('app_version', defaultVal: 'v1.0.0');

    return Text(
      appVersion,
      style: TextStyle(
        fontSize: 11,
        color: Colors.grey.shade500,
      ),
    );
  }
}
