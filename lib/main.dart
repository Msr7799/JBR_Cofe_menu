import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/auth_controller.dart';
import 'package:gpr_coffee_shop/controllers/category_controller.dart';
import 'package:gpr_coffee_shop/controllers/order_controller.dart';
import 'package:gpr_coffee_shop/controllers/product_controller.dart';
import 'package:gpr_coffee_shop/controllers/settings_controller.dart';
import 'package:gpr_coffee_shop/screens/splash_screen.dart';
import 'package:gpr_coffee_shop/services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تعيين اتجاه التطبيق للوضع الرأسي فقط
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // تهيئة خدمة التخزين المحلي
  await localStorageService.init();

  // تهيئة المتحكمات
  final settingsController = Get.put(SettingsController(localStorageService));
  Get.put(AuthController());
  Get.put(CategoryController(localStorageService));
  Get.put(ProductController(localStorageService));
  Get.put(OrderController(localStorageService));

  runApp(MyApp(settingsController: settingsController));
}

class MyApp extends StatelessWidget {
  final SettingsController settingsController;

  const MyApp({Key? key, required this.settingsController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeMode = _getThemeMode(settingsController.settings.value.theme);
      final isDark = themeMode == ThemeMode.dark ||
          (themeMode == ThemeMode.system &&
              MediaQuery.platformBrightnessOf(context) == Brightness.dark);

      return GetMaterialApp(
        title: 'GPR Coffee Shop',
        debugShowCheckedModeBanner: false,
        theme: _getLightTheme(context),
        darkTheme: _getDarkTheme(context),
        themeMode: themeMode,
        home: Theme(
          data: isDark ? _getDarkTheme(context) : _getLightTheme(context),
          child: SplashScreen(),
        ),
        getPages: [],
        translations: AppTranslations(),
        locale: Locale(settingsController.settings.value.language),
        fallbackLocale: Locale('ar'),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: settingsController.settings.value.fontSize,
            ),
            child: Directionality(
              textDirection: settingsController.settings.value.language == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: child!,
            ),
          );
        },
      );
    });
  }

  ThemeData _getLightTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: _getThemeColor(settingsController.settings.value.theme),
        secondary: AppTheme.secondaryColor,
        background: AppTheme.backgroundColor,
      ),
      scaffoldBackgroundColor: AppTheme.backgroundColor,
      textTheme: _getTextTheme(context, false),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: _getThemeColor(settingsController.settings.value.theme),
        ),
      ),
    );
  }

  ThemeData _getDarkTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: _getThemeColor(settingsController.settings.value.theme),
        secondary: AppTheme.secondaryColor,
        background: Color(0xFF303030),
      ),
      scaffoldBackgroundColor: Color(0xFF303030),
      textTheme: _getTextTheme(context, true),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: AppTheme.secondaryColor,
        ),
      ),
    );
  }

  TextTheme _getTextTheme(BuildContext context, bool isDark) {
    return GoogleFonts.cairoTextTheme(
      Theme.of(context).textTheme,
    ).apply(
      bodyColor: isDark ? Colors.white : AppTheme.textPrimaryColor,
      displayColor: isDark ? Colors.white : AppTheme.textPrimaryColor,
    );
  }

  Color _getThemeColor(String theme) {
    switch (theme) {
      case 'brown':
        return AppTheme.primaryColor;
      case 'custom':
        return Colors.teal;
      default:
        return Colors.brown;
    }
  }

  ThemeMode _getThemeMode(String theme) {
    switch (theme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ar': {
          'settings': 'الإعدادات',
          'language': 'اللغة',
          'appearance': 'المظهر',
          'fontSize': 'حجم الخط',
          'theme': 'النمط',
          'light': 'فاتح',
          'dark': 'داكن',
          'brown': 'بني',
          'custom': 'مميز',
        },
        'en': {
          'settings': 'Settings',
          'language': 'Language',
          'appearance': 'Appearance',
          'fontSize': 'Font Size',
          'theme': 'Theme',
          'light': 'Light',
          'dark': 'Dark',
          'brown': 'Brown',
          'custom': 'Custom',
        },
      };
}
