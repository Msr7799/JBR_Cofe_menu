import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/auth_controller.dart';
import 'package:gpr_coffee_shop/controllers/category_controller.dart';
import 'package:gpr_coffee_shop/controllers/feedback_controller.dart';
import 'package:gpr_coffee_shop/controllers/order_controller.dart';
import 'package:gpr_coffee_shop/controllers/product_controller.dart';
import 'package:gpr_coffee_shop/controllers/settings_controller.dart';
import 'package:gpr_coffee_shop/controllers/view_options_controller.dart'; // Add this import
import 'package:gpr_coffee_shop/models/app_settings.dart';
import 'package:gpr_coffee_shop/models/category.dart';
import 'package:gpr_coffee_shop/models/order.dart';
import 'package:gpr_coffee_shop/models/product.dart';
import 'package:gpr_coffee_shop/services/shared_preferences_service.dart';
import 'package:gpr_coffee_shop/screens/splash_screen.dart';
import 'package:gpr_coffee_shop/screens/home_screen.dart';
import 'package:gpr_coffee_shop/screens/settings_screen.dart';
import 'package:gpr_coffee_shop/screens/location_screen.dart';
import 'package:gpr_coffee_shop/screens/admin/admin_dashboard.dart';
import 'package:gpr_coffee_shop/screens/admin/login_screen.dart';
import 'package:gpr_coffee_shop/screens/customer/menu_screen.dart';
import 'package:gpr_coffee_shop/screens/customer/rate_screen.dart';
import 'package:gpr_coffee_shop/services/local_storage_service.dart';
import 'package:gpr_coffee_shop/middleware/auth_middleware.dart';
import 'package:gpr_coffee_shop/utils/app_translations.dart';
import 'package:gpr_coffee_shop/services/app_translation_service.dart';
import 'package:gpr_coffee_shop/services/notification_service.dart';
import 'package:gpr_coffee_shop/screens/admin/benefit_pay_qr_management.dart';
import 'package:gpr_coffee_shop/screens/view_options_screen.dart';
import 'package:gpr_coffee_shop/utils/hive_reset_util.dart';
import 'package:gpr_coffee_shop/utils/rendering_helper.dart'; // Add this import
import 'package:hive_flutter/hive_flutter.dart';

import 'dart:io';

// Function to register all Hive adapters
Future<void> _registerHiveAdapters() async {
  try {
    // Register app settings adapters
    Hive.registerAdapter(AppSettingsAdapter());
    Hive.registerAdapter(BackgroundSettingsAdapter());
    Hive.registerAdapter(BackgroundTypeAdapter());

    // Register product related adapters
    Hive.registerAdapter(ProductAdapter());
    // Note: ProductOptionAdapter and OptionChoiceAdapter seem to be missing
    // Uncomment these when you implement them
    // Hive.registerAdapter(ProductOptionAdapter());
    // Hive.registerAdapter(OptionChoiceAdapter());

    // Register category adapters
    Hive.registerAdapter(CategoryAdapter());

    // Register order related adapters
    Hive.registerAdapter(OrderAdapter());
    Hive.registerAdapter(OrderItemAdapter());
    Hive.registerAdapter(OrderStatusAdapter());
    Hive.registerAdapter(PaymentTypeAdapter());

    print("✅ All Hive adapters registered successfully");
  } catch (e) {
    print("⚠️ Error registering Hive adapters: $e");
    // Continue execution as some adapters might already be registered
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // خيارات تحسين الأداء لنظام Windows
  if (Platform.isWindows) {
    // استخدام الوظائف المعدلة من RenderingHelper بدلاً من الكود المباشر
    RenderingHelper.applyOptimizations();
  }

  // IMPORTANT: Comment this line after running once to reset Hive
  // await HiveResetUtil.resetHiveData();

  // Initialize Hive and register adapters
  await Hive.initFlutter();
  await _registerHiveAdapters();

  // تهيئة الترجمات أولاً
  final translations = AppTranslations();
  Get.put(translations);

  // تهيئة الخدمات
  await Get.putAsync(() => SharedPreferencesService().init());

  // تهيئة وتسجيل LocalStorageService
  final localStorageService = LocalStorageService();
  await localStorageService.init();
  Get.put(localStorageService);

  // تسجيل خدمة الترجمة لاتجاه النص
  final translationService = AppTranslationService();
  Get.put(translationService);

  // تسجيل المتحكمات
  final storageService = Get.find<LocalStorageService>();
  Get.put(ProductController(storageService));
  Get.put(CategoryController(storageService));
  Get.put(AuthController());
  Get.put(OrderController(storageService));
  Get.put(SettingsController());
  Get.put(FeedbackController());
  Get.put(ViewOptionsController()); // إضافة ViewOptionsController هنا

  // تهيئة التطبيق باللغة المحفوظة
  final savedLanguage = Get.find<SharedPreferencesService>().getLanguage();

  // تصحيح الخطأ النحوي - نقطة-فاصلة منقوصة
  Get.locale = Locale(savedLanguage);
  Get.updateLocale(Locale(savedLanguage));

  // تطبيق اتجاه النص بناءً على اللغة
  translationService.updateTextDirectionFromLanguage(savedLanguage);

  Get.put(await NotificationService().init());

  // إزالة القيود على اتجاه الشاشة للسماح بالوضع الأفقي والعمودي
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final SettingsController settingsController = Get.find<SettingsController>();
  final AppTranslationService translationService =
      Get.find<AppTranslationService>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      builder: (controller) {
        // تطبيق الثيم مقدماً بدلاً من داخل _getThemeMode
        final themeMode = _getThemeMode(controller.themeMode);

        return GetMaterialApp(
          key: UniqueKey(), // مفتاح فريد لكل بناء جديد (اختياري)
          title: 'app_name'.tr,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          locale: translationService.currentLocale.value,
          translations: Get.find<AppTranslations>(),
          fallbackLocale: const Locale('ar'),
          textDirection: translationService.textDirection.value,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          defaultTransition: Transition.fade,
          navigatorKey: Get.key,
          getPages: [
            GetPage(name: '/', page: () => const HomeScreen()),
            GetPage(name: '/splash', page: () => const SplashScreen()),
            GetPage(name: '/menu', page: () => MenuScreen()),
            GetPage(name: '/settings', page: () => const SettingsScreen()),
            GetPage(name: '/location', page: () => const LocationScreen()),
            GetPage(name: '/rate', page: () => const RateScreen()),
            GetPage(
              name: '/login',
              page: () => LoginScreen(),
            ),
            GetPage(
              name: '/admin',
              page: () => const AdminDashboard(),
              middlewares: [AuthMiddleware()],
            ),
            GetPage(
              name: '/benefit-pay-qr',
              page: () => const BenefitPayQrManagement(),
              middlewares: [AuthMiddleware()],
            ),
            GetPage(name: '/view-options', page: () => ViewOptionsScreen()),
          ],
          popGesture: true,
        );
      },
    );
  }

  ThemeMode _getThemeMode(String mode) {
    // تنفيذ تغيير الثيم قبل إرجاع ThemeMode
    switch (mode) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      case 'coffee':
        // تطبيق الثيم خارج الدالة وليس هنا
        return ThemeMode.light;
      case 'sweet':
        // تطبيق الثيم خارج الدالة وليس هنا
        return ThemeMode.light;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}
