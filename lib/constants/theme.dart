import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // الألوان الأساسية - محسنة للوضوح والجمالية
  static const primaryColor = Color.fromARGB(255, 156, 182, 194); // رصاصي غامق
  static const secondaryColor = Color(0xFF78909C); // رصاصي متوسط
  static const accentColor = Color(0xFF29B6F6); // أزرق فاتح للتباين
  static const backgroundColor = Color(0xFFFAFAFA); // أبيض مائل للرمادي

  static const divider = Color(0xFFE0E0E0); // رمادي فاتح للفواصل
  static const background = Color(0xFFF0F2F5); // خلفية رمادي فاتح بدرجة مختلفة
  static const shimmerBaseColor = Color(0xFFE0E0E0); // قاعدة التلألؤ
  static const shimmerHighlightColor = Color(0xFFFFFFFF); // تركيز التلألؤ أبيض

  // ألوان الإشعارات - محسنة للوضوح
  static const errorColor = Color(0xFFE53935); // أحمر واضح
  static const successColor = Color(0xFF43A047); // أخضر واضح
  static const warningColor = Color(0xFFFFA726); // برتقالي تحذيري واضح
  static const infoColor = Color(0xFF2196F3); // أزرق معلوماتي واضح

  // ألوان النصوص - محسنة للوضوح والتباين
  static const textPrimaryColor =
      Color(0xFF212121); // أسود داكن للنصوص الرئيسية
  static const textSecondaryColor =
      Color(0xFF616161); // رمادي داكن للنصوص الثانوية
  static const textLightColor =
      Color(0xFFFAFAFA); // أبيض للنصوص على الخلفيات الداكنة
  static const textDarkColor =
      Color(0xFF212121); // أسود للنصوص على الخلفيات الفاتحة

  // الثيم الكلاسيكي - أزرق أنيق
  static const classicPrimaryColor = Color(0xFF1A237E); // أزرق داكن
  static const classicSecondaryColor = Color(0xFF303F9F); // أزرق متوسط
  static const classicAccentColor = Color(0xFF42A5F5); // أزرق فاتح
  static const classicBackgroundColor = Color(0xFFF5F7FA); // رمادي فاتح جداً
  static const classicSurfaceColor = Color(0xFFE8EAF6); // بنفسجي فاتح جداً

  // الثيم العصري - بنفسجي وأرجواني
  static const modernPrimaryColor = Color(0xFF6A1B9A); // بنفسجي غامق
  static const modernSecondaryColor = Color(0xFF9C27B0); // أرجواني
  static const modernAccentColor = Color(0xFFEC407A); // وردي
  static const modernBackgroundColor = Color(0xFFF3E5F5); // بنفسجي فاتح جداً
  static const modernSurfaceColor = Color(0xFFEDE7F6); // بنفسجي فاتح

  // الثيم البحري - أزرق محيطي
  static const oceanPrimaryColor = Color(0xFF01579B); // أزرق داكن
  static const oceanSecondaryColor = Color(0xFF039BE5); // أزرق متوسط
  static const oceanAccentColor = Color(0xFFFFD54F); // ذهبي للتباين
  static const oceanBackgroundColor = Color(0xFFE1F5FE); // أزرق فاتح جداً
  static const oceanSurfaceColor = Color(0xFFB3E5FC); // أزرق فاتح

  // ثيم بني - بدرجات البني والبيج
  static const brownPrimaryColor = Color(0xFF795548); // بني متوسط
  static const brownSecondaryColor = Color(0xFFA1887F); // بني فاتح
  static const brownAccentColor = Color(0xFFFFB74D); // برتقالي فاتح
  static const brownBackgroundColor = Color(0xFFF8F5F0); // بيج فاتح
  static const brownSurfaceColor = Color(0xFFEFEBE9); // بيج متوسط

  // ألوان الثيم الداكن - محسنة للقراءة
  static const darkPrimaryColor = Color(0xFF263238); // رمادي داكن
  static const darkSecondaryColor = Color(0xFF37474F); // رمادي متوسط
  static const darkAccentColor = Color(0xFF4FC3F7); // أزرق فاتح للتباين
  static const darkBackgroundColor = Color(0xFF121212); // أسود خالص
  static const darkSurfaceColor = Color(0xFF1E1E1E); // أسود مائل للرمادي

  // السوبر دارك (تعديل ثيم دارك الحالي)
  static const superDarkPrimaryColor = Color(0xFF121212); // أسود أكثر عمقاً
  static const superDarkSecondaryColor = Color(0xFF1E1E1E); // أسود داكن
  static const superDarkAccentColor = Color(0xFF2979FF); // أزرق ساطع للتباين
  static const superDarkBackgroundColor = Color(0xFF000000); // أسود خالص
  static const superDarkSurfaceColor = Color(0xFF121212); // أسود مع لمسة رمادي

  // لايت (تعديل ثيم كلاسيك)
  static const lightPrimaryColor = Color(0xFFFAFAFA); // أبيض ثلجي
  static const lightSecondaryColor =
      Color(0xFFF5F5F5); // أبيض مائل للرمادي فاتح
  static const lightAccentColor = Color(0xFF2962FF); // أزرق ساطع
  static const lightBackgroundColor = Color(0xFFFFFFFF); // أبيض
  static const lightSurfaceColor = Color(0xFFF0F0F0); // رمادي فاتح جداً

  // رصاصي غامق (تعديل ثيم براون)
  static const greyPrimaryColor = Color(0xFF424242); // رصاصي غامق
  static const greySecondaryColor = Color(0xFF616161); // رصاصي متوسط
  static const greyAccentColor = Color(0xFF90A4AE); // رصاصي فاتح
  static const greyBackgroundColor = Color(0xFF303030); // رصاصي غامق
  static const greySurfaceColor = Color(0xFF484848); // رصاصي متوسط غامق

  // سكاي بلو (تعديل ثيم أوشين)
  static const skyPrimaryColor = Color(0xFF03A9F4); // أزرق سماوي
  static const skySecondaryColor = Color(0xFF4FC3F7); // أزرق سماوي فاتح
  static const skyAccentColor = Color(0xFF0288D1); // أزرق مائل للداكن
  static const skyBackgroundColor = Color(0xFFE1F5FE); // أزرق فاتح جداً
  static const skySurfaceColor = Color(0xFFB3E5FC); // أزرق فاتح

  // مارون (تعديل ثيم مودرن)
  static const maroonPrimaryColor = Color(0xFF800000); // مارون كلاسيكي
  static const maroonSecondaryColor = Color(0xFFA52A2A); // بني محمّر
  static const maroonAccentColor = Color(0xFFD32F2F); // أحمر داكن
  static const maroonBackgroundColor = Color(0xFFFBE9E7); // أبيض وردي فاتح
  static const maroonSurfaceColor = Color(0xFFFFCDD2); // وردي فاتح

  // تحديث حجم الخط الأساسي مع تباين لوني أفضل للقراءة وتوحيد قيمة inherit
  static TextTheme createBaseTextTheme(Color textColor) {
    return GoogleFonts.cairoTextTheme().copyWith(
      displayLarge: TextStyle(
          inherit: true,
          fontSize: 26,
          color: textColor,
          fontWeight: FontWeight.bold),
      displayMedium: TextStyle(
          inherit: true,
          fontSize: 22,
          color: textColor,
          fontWeight: FontWeight.bold),
      displaySmall: TextStyle(
          inherit: true,
          fontSize: 18,
          color: textColor,
          fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(
          inherit: true,
          fontSize: 20,
          color: textColor,
          fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(
          inherit: true,
          fontSize: 18,
          color: textColor,
          fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(
          inherit: true,
          fontSize: 16,
          color: textColor,
          fontWeight: FontWeight.w600),
      titleLarge: TextStyle(
          inherit: true,
          fontSize: 16,
          color: textColor,
          fontWeight: FontWeight.w600),
      titleMedium: TextStyle(
          inherit: true,
          fontSize: 15,
          color: textColor,
          fontWeight: FontWeight.w600),
      titleSmall: TextStyle(
          inherit: true,
          fontSize: 16,
          color: textColor,
          fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(inherit: true, fontSize: 14, color: textColor),
      bodyMedium: TextStyle(inherit: true, fontSize: 14, color: textColor),
      bodySmall: TextStyle(
          inherit: true,
          fontSize: 14,
          color: Color.fromRGBO(
              textColor.red, textColor.green, textColor.blue, 0.8)),
      labelLarge: TextStyle(
          inherit: true,
          fontSize: 16,
          color: textColor,
          fontWeight: FontWeight.w600),
      labelMedium: TextStyle(
          inherit: true,
          fontSize: 14,
          color: textColor,
          fontWeight: FontWeight.w500),
      labelSmall: TextStyle(
          inherit: true,
          fontSize: 12,
          color: Color.fromRGBO(
              textColor.red, textColor.green, textColor.blue, 0.8),
          fontWeight: FontWeight.w500),
    );
  }

  // الثيم الكلاسيكي - أزرق أنيق
  static ThemeData classicTheme(Color? customTextColor) {
    final textColor = customTextColor ?? textPrimaryColor;
    return ThemeData(
      primaryColor: classicPrimaryColor,
      scaffoldBackgroundColor: classicBackgroundColor,
      colorScheme: const ColorScheme.light(
        primary: classicPrimaryColor,
        secondary: classicSecondaryColor,
        tertiary: classicAccentColor,
        surface: classicSurfaceColor,
        error: errorColor,
        onPrimary: textLightColor,
        onSecondary: textLightColor,
        onSurface: textPrimaryColor,
      ),
      textTheme: createBaseTextTheme(textColor),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: classicPrimaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle:
              const TextStyle(fontWeight: FontWeight.w600, inherit: true),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: classicPrimaryColor,
          side: const BorderSide(color: classicPrimaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 4,
        shadowColor: Color.fromRGBO(classicPrimaryColor.red,
            classicPrimaryColor.green, classicPrimaryColor.blue, 0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
              color: Color.fromRGBO(classicPrimaryColor.red,
                  classicPrimaryColor.green, classicPrimaryColor.blue, 0.05),
              width: 0.7),
        ),
        margin: const EdgeInsets.all(8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: TextStyle(
            color: Color.fromRGBO(textSecondaryColor.red,
                textSecondaryColor.green, textSecondaryColor.blue, 0.7)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: Color.fromRGBO(classicPrimaryColor.red,
                  classicPrimaryColor.green, classicPrimaryColor.blue, 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: Color.fromRGBO(classicPrimaryColor.red,
                  classicPrimaryColor.green, classicPrimaryColor.blue, 0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: classicPrimaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 1.5),
        ),
        floatingLabelStyle: const TextStyle(color: classicPrimaryColor),
      ),
      iconTheme: const IconThemeData(
        color: classicAccentColor,
        size: 24,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  // الثيم العصري - بنفسجي وأرجواني
  static ThemeData modernTheme(Color? customTextColor) {
    final textColor = customTextColor ?? textPrimaryColor;
    return ThemeData(
      primaryColor: modernPrimaryColor,
      scaffoldBackgroundColor: modernBackgroundColor,
      colorScheme: const ColorScheme.light(
        primary: modernPrimaryColor,
        secondary: modernSecondaryColor,
        tertiary: modernAccentColor,
        surface: modernSurfaceColor,
        error: errorColor,
        onPrimary: textLightColor,
        onSecondary: textLightColor,
        onSurface: textPrimaryColor,
      ),
      textTheme: createBaseTextTheme(textColor),
      appBarTheme: const AppBarTheme(
        backgroundColor: modernPrimaryColor,
        foregroundColor: textLightColor,
        elevation: 2,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: modernSecondaryColor,
          foregroundColor: textLightColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: modernPrimaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardTheme(
        color: Color.fromRGBO(
            Colors.white.red, Colors.white.green, Colors.white.blue, 0.9),
        elevation: 4,
        shadowColor: Color.fromRGBO(modernPrimaryColor.red,
            modernPrimaryColor.green, modernPrimaryColor.blue, 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
              color: Color.fromRGBO(modernPrimaryColor.red,
                  modernPrimaryColor.green, modernPrimaryColor.blue, 0.2),
              width: 0.7),
        ),
        margin: const EdgeInsets.all(8),
      ),
      iconTheme: const IconThemeData(
        color: modernAccentColor,
        size: 24,
      ),
    );
  }

  // الثيم الداكن المحسن للقراءة
  static ThemeData darkTheme(Color? customTextColor) {
    // استخدام textLightColor دائمًا للثيم الداكن بغض النظر عن customTextColor
    final textColor = textLightColor;
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: darkPrimaryColor,
      scaffoldBackgroundColor: darkBackgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: darkPrimaryColor,
        secondary: darkSecondaryColor,
        tertiary: darkAccentColor,
        error: errorColor,
        surface: darkSurfaceColor,
        onPrimary: textLightColor,
        onSecondary: textLightColor,
        onSurface: textLightColor,
      ),
      textTheme: createBaseTextTheme(textColor),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A1A1A),
        foregroundColor: textLightColor,
        elevation: 4,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkSecondaryColor,
          foregroundColor: textLightColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF2D2D2D),
        elevation: 4,
        shadowColor: Color.fromRGBO(
            Colors.black.red, Colors.black.green, Colors.black.blue, 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF3F3F3F), width: 0.7),
        ),
        margin: const EdgeInsets.all(8),
      ),
      iconTheme: const IconThemeData(
        // استخدام لون فاتح للأيقونات بدلاً من darkAccentColor
        color: Colors.white70, 
        size: 24,
      ),
    );
  }

  // إضافة دوال الثيمات الجديدة
  static ThemeData lightTheme(Color? customTextColor) {
    final textColor = customTextColor ?? textPrimaryColor;
    return ThemeData(
      primaryColor: lightPrimaryColor,
      scaffoldBackgroundColor: lightBackgroundColor,
      colorScheme: const ColorScheme.light(
        primary: lightPrimaryColor,
        secondary: lightSecondaryColor,
        tertiary: lightAccentColor,
        surface: lightSurfaceColor,
        error: errorColor,
        onPrimary: textDarkColor,
        onSecondary: textDarkColor,
        onSurface: textDarkColor,
      ),
      textTheme: createBaseTextTheme(textColor),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightPrimaryColor,
        foregroundColor: textDarkColor,
        elevation: 1,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightAccentColor,
          foregroundColor: textLightColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: lightAccentColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightAccentColor,
          side: const BorderSide(color: lightAccentColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shadowColor: const Color(0x1A000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0x0A000000), width: 0.5),
        ),
        margin: const EdgeInsets.all(8),
      ),
      iconTheme: const IconThemeData(
        color: lightAccentColor,
        size: 24,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightAccentColor, width: 1.5),
        ),
      ),
    );
  }

  static ThemeData greyTheme(Color? customTextColor) {
    // استخدام textLightColor دائمًا للثيم الرمادي بغض النظر عن customTextColor
    final textColor = textLightColor;
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: greyPrimaryColor,
      scaffoldBackgroundColor: greyBackgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: greyPrimaryColor,
        secondary: greySecondaryColor,
        tertiary: greyAccentColor,
        surface: greySurfaceColor,
        error: errorColor,
        onPrimary: textLightColor,
        onSecondary: textLightColor,
        onSurface: textLightColor,
      ),
      textTheme: createBaseTextTheme(textColor),
      appBarTheme: const AppBarTheme(
        backgroundColor: greyPrimaryColor,
        foregroundColor: textLightColor,
        elevation: 2,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: greySecondaryColor,
          foregroundColor: textLightColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          // استخدام لون فاتح للنص
          foregroundColor: Colors.white70,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          // استخدام لون فاتح للحدود والنص
          foregroundColor: Colors.white70,
          side: const BorderSide(color: Colors.white70, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: greySurfaceColor,
        elevation: 4,
        shadowColor: const Color(0x40000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF505050), width: 0.7),
        ),
        margin: const EdgeInsets.all(8),
      ),
      iconTheme: const IconThemeData(
        // استخدام لون فاتح للأيقونات
        color: Colors.white70,
        size: 24,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF404040),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF505050)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF505050)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          // استخدام لون فاتح لحدود الحقول
          borderSide: const BorderSide(color: Colors.white70, width: 1.5),
        ),
      ),
    );
  }

  static ThemeData maroonTheme(Color? customTextColor) {
    final textColor = customTextColor ?? textPrimaryColor;
    return ThemeData(
      primaryColor: maroonPrimaryColor,
      scaffoldBackgroundColor: maroonBackgroundColor,
      colorScheme: const ColorScheme.light(
        primary: maroonPrimaryColor,
        secondary: maroonSecondaryColor,
        tertiary: maroonAccentColor,
        surface: maroonSurfaceColor,
        error: errorColor,
        onPrimary: textLightColor,
        onSecondary: textLightColor,
        onSurface: textPrimaryColor,
      ),
      textTheme: createBaseTextTheme(textColor),
      appBarTheme: const AppBarTheme(
        backgroundColor: maroonPrimaryColor,
        foregroundColor: textLightColor,
        elevation: 3,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: maroonSecondaryColor,
          foregroundColor: textLightColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: maroonAccentColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: maroonSecondaryColor,
          side: const BorderSide(color: maroonSecondaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 3,
        shadowColor: const Color(0x1A800000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0x1A800000), width: 0.7),
        ),
        margin: const EdgeInsets.all(8),
      ),
      iconTheme: const IconThemeData(
        color: maroonAccentColor,
        size: 24,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0x33800000)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0x33800000)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: maroonPrimaryColor, width: 1.5),
        ),
      ),
    );
  }

  // تصحيح تعريف دالة getThemeByName - تبسيط إلى 4 ثيمات فقط
  static ThemeData getThemeByName(String themeName, {Color? customTextColor}) {
    switch (themeName) {
      case 'dark':
        return darkTheme(textLightColor); // دائما استخدم textLightColor للثيمات الداكنة
      case 'light':
        return lightTheme(customTextColor ?? textPrimaryColor);
      case 'grey':
        return greyTheme(textLightColor); // دائما استخدم textLightColor للثيمات الداكنة
      case 'maroon':
        return maroonTheme(customTextColor ?? textPrimaryColor);
      default:
        return lightTheme(customTextColor ?? textPrimaryColor);
    }
  }
}
