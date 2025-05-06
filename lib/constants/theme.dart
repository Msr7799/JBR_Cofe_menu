import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Modern and trendy color palette
  static const primaryColor = Color(0xFF9E9E9E); // رصاصي فاتح بدلاً من النيلي
  static const secondaryColor = Color(0xFF22D3EE); // Vibrant cyan
  static const accentColor = Color(0xFFF43F5E); // Hot pink
  static const backgroundColor = Color(0xFFF9FAFB); // Cool gray background

  static const divider = Color(0xFFE2E8F0); // Cool gray divider
  static const background = Color(0xFFF1F5F9); // Slate background
  static const shimmerBaseColor = Color(0xFFE2E8F0); // Cool shimmer base
  static const shimmerHighlightColor = Color(0xFFFFFFFF); // White

  // Notification colors - modern palette
  static const errorColor = Color(0xFFEF4444); // Modern red
  static const successColor = Color(0xFF10B981); // Modern green
  static const warningColor = Color(0xFFF59E0B); // Modern amber
  static const infoColor = Color(0xFF3B82F6); // Modern blue

  // Text colors - clearer contrast
  static const textPrimaryColor = Color(0xFF263238); // Dark blue-gray
  static const textSecondaryColor = Color(0xFF607D8B); // Blue-gray
  static const textLightColor = Color(0xFFFAFAFA); // White
  static const textDarkColor = Color(0xFF000000); // أسود

  // ألوان ثيم القهوة الكلاسيكي
  static const coffeePrimaryColor = Color(0xFF6F4E37); // بني غامق
  static const coffeeSecondaryColor = Color(0xFFB85C38); // بني محمر
  static const coffeeAccentColor = Color(0xFFE4A672); // بني ذهبي
  static const coffeeBackgroundColor = Color(0xFFF8EDE3); // بيج فاتح
  static const coffeeSurfaceColor = Color(0xFFDFD3C3); // بيج متوسط

  // ألوان ثيم الحلويات الباستيل
  static const sweetPrimaryColor = Color(0xFFDB7093); // وردي متوسط
  static const sweetSecondaryColor = Color(0xFF9370DB); // بنفسجي فاتح
  static const sweetAccentColor = Color(0xFF20B2AA); // تركواز
  static const sweetBackgroundColor = Color(0xFFFFF0F5); // وردي باهت جداً
  static const sweetSurfaceColor = Color(0xFFFFE4E1); // وردي خفيف

  // تحديث حجم الخط الأساسي ليكون 14 في جميع النصوص
  static final _baseTextTheme = GoogleFonts.cairoTextTheme().copyWith(
    displayLarge: const TextStyle(
        fontSize: 26, color: textPrimaryColor, fontWeight: FontWeight.bold),
    displayMedium: const TextStyle(
        fontSize: 22, color: textPrimaryColor, fontWeight: FontWeight.bold),
    displaySmall: const TextStyle(
        fontSize: 18, color: textPrimaryColor, fontWeight: FontWeight.bold),
    headlineLarge: const TextStyle(
        fontSize: 20, color: textPrimaryColor, fontWeight: FontWeight.bold),
    headlineMedium: const TextStyle(
        fontSize: 18, color: textPrimaryColor, fontWeight: FontWeight.bold),
    headlineSmall: const TextStyle(
        fontSize: 16, color: textPrimaryColor, fontWeight: FontWeight.w600),
    titleLarge: const TextStyle(
        fontSize: 16, color: textPrimaryColor, fontWeight: FontWeight.w600),
    titleMedium: const TextStyle(
        fontSize: 15, color: textPrimaryColor, fontWeight: FontWeight.w600),
    titleSmall: const TextStyle(
        fontSize: 18, color: textPrimaryColor, fontWeight: FontWeight.w500),
    bodyLarge: const TextStyle(fontSize: 14, color: textPrimaryColor),
    bodyMedium: const TextStyle(fontSize: 14, color: textPrimaryColor),
    bodySmall: const TextStyle(fontSize: 14, color: textSecondaryColor),
    labelLarge: const TextStyle(
        fontSize: 18,
        color: Color.fromARGB(255, 9, 10, 22),
        fontWeight: FontWeight.w600),
    labelMedium:
        const TextStyle(fontSize: 14, color: Color.fromARGB(255, 14, 14, 31)),
    labelSmall:
        const TextStyle(fontSize: 14, color: Color.fromARGB(255, 17, 18, 41)),
  );

  static final lightTheme = ThemeData(
    primaryColor: const Color.fromARGB(255, 134, 134, 164),
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: Color.fromARGB(255, 174, 174, 200),
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: backgroundColor,
      error: errorColor,
      onPrimary: textLightColor,
      onSecondary: textPrimaryColor,
      onSurface: textPrimaryColor,
    ),
    // استخدام السمة النصية الجديدة مع حجم الخط 14
    textTheme: _baseTextTheme,
    // شكل AppBar موحد
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 157, 158, 175),
      foregroundColor: textLightColor,
      elevation: 2,
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
    ),
    // أزرار محسنة
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 152, 152, 178),
        foregroundColor: textLightColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
      ),
    ),
    // أزرار نصية
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 111, 112, 138),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    // أزرار مسطحة
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 98, 99, 118),
        side: const BorderSide(color: Color.fromARGB(255, 125, 126, 150), width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    // بطاقات محسنة
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: const Color.fromARGB(255, 85, 86, 121).withOpacity(0.05), width: 0.7),
      ),
      margin: const EdgeInsets.all(8),
    ),
    // حقول النص محسنة
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: TextStyle(color: textSecondaryColor.withOpacity(0.7)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor.withOpacity(0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor.withOpacity(0.15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 1.5),
      ),
      // إضافة ظل ناعم
      floatingLabelStyle: const TextStyle(color: primaryColor),
      prefixIconColor: primaryColor,
      suffixIconColor: primaryColor,
    ),
    // شرائح محسنة
    chipTheme: ChipThemeData(
      backgroundColor: secondaryColor.withOpacity(0.15),
      selectedColor: primaryColor.withOpacity(0.2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      labelStyle: const TextStyle(
        color: textPrimaryColor,
        fontSize: 14,
      ),
      secondaryLabelStyle: const TextStyle(
        color: primaryColor,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: primaryColor.withOpacity(0.2)),
      ),
    ),
    // أيقونات
    iconTheme: const IconThemeData(
      color: accentColor,
      size: 24,
    ),
    // صناديق الحوار
    dialogTheme: DialogTheme(
      backgroundColor: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );

  // المظهر الداكن المحسن
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF8B5A2B), // بني دافئ
    scaffoldBackgroundColor: const Color(0xFF121212), // أسود طبيعي
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFAB7F52), // بني محمر دافئ
      secondary: Color(0xFF5B8A72), // أخضر داكن هادئ
      tertiary: Color(0xFFE2A54C), // ذهبي دافئ
      background: Color(0xFF212121),
      error: errorColor,
      surface: Color(0xFF1E1E1E), // أسود قليل السطوع
      onPrimary: textLightColor,
      onSecondary: textLightColor,
      onSurface: textLightColor,
    ),
    // استخدام السمة النصية الجديدة مع تعديل الألوان المناسبة للوضع الداكن
    textTheme: _baseTextTheme.apply(
      bodyColor: textLightColor,
      displayColor: textLightColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A1A1A), // أغمق قليلاً من الخلفية
      foregroundColor: textLightColor,
      elevation: 4,
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
    ),
    // نفس الكونفجريشن للأزرار مع تعديل الألوان
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFAB7F52), // بني محمر دافئ
        foregroundColor: textLightColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
      ),
    ),
    // بطاقات معدلة للوضع الداكن
    cardTheme: CardTheme(
      color: const Color(0xFF262626), // أغمق قليلاً من الخلفية
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF333333), width: 0.7),
      ),
      margin: const EdgeInsets.all(8),
    ),
    // حقول نص معدلة للوضع الداكن
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2C), // أفتح قليلاً من الخلفية
      hintStyle: TextStyle(color: Colors.grey[400]),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF444444)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF444444)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFAB7F52), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 1.5),
      ),
      floatingLabelStyle: const TextStyle(color: Color(0xFFAB7F52)),
      prefixIconColor: const Color(0xFFE2A54C),
      suffixIconColor: const Color(0xFFE2A54C),
    ),
    // شرائح للوضع الداكن
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF333333),
      selectedColor: const Color(0xFFE2A54C).withOpacity(0.3),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      labelStyle: const TextStyle(
        color: textLightColor,
        fontSize: 16
      ),
      secondaryLabelStyle: const TextStyle(
        color: Color(0xFFE2A54C),
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFF444444)),
      ),
    ),
    // أيقونات للوضع الداكن
    iconTheme: const IconThemeData(
      color: Color(0xFFE2A54C),
      size: 24,
    ),
    // صناديق الحوار للوضع الداكن
    dialogTheme: DialogTheme(
      backgroundColor: const Color(0xFF1E1E1E),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );

  // ثيم القهوة الكلاسيكي
  static final coffeeTheme = ThemeData(
    primaryColor: coffeePrimaryColor,
    scaffoldBackgroundColor: coffeeBackgroundColor,
    colorScheme: const ColorScheme.light(
      primary: coffeePrimaryColor,
      secondary: coffeeSecondaryColor,
      tertiary: coffeeAccentColor,
      surface: coffeeSurfaceColor,
      background: coffeeBackgroundColor,
      error: errorColor,
      onPrimary: textLightColor,
      onSecondary: textLightColor,
      onSurface: textPrimaryColor,
    ),
    // استخدام نفس السمة النصية ذات حجم الخط 14
    textTheme: _baseTextTheme.copyWith(
      titleLarge: const TextStyle(
          fontSize: 19, color: coffeePrimaryColor, fontWeight: FontWeight.w600),
      titleMedium: const TextStyle(
          fontSize: 17, color: coffeePrimaryColor, fontWeight: FontWeight.w600),
      titleSmall: const TextStyle(
          fontSize: 16, color: coffeePrimaryColor, fontWeight: FontWeight.w500),
      labelLarge: const TextStyle(
          fontSize: 15,
          color: coffeeSecondaryColor,
          fontWeight: FontWeight.w600),
      labelMedium: const TextStyle(fontSize: 14, color: coffeeSecondaryColor),
      labelSmall: const TextStyle(fontSize: 14, color: coffeeSecondaryColor),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: coffeePrimaryColor,
      foregroundColor: textLightColor,
      elevation: 2,
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
    ),
    // أزرار محسنة
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: coffeeSecondaryColor,
        foregroundColor: textLightColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
      ),
    ),
    // أزرار نصية
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: coffeePrimaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    // بطاقات محسنة
    cardTheme: CardTheme(
      color: coffeeSurfaceColor.withOpacity(0.7),
      elevation: 4,
      shadowColor: Colors.brown.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side:
            BorderSide(color: coffeePrimaryColor.withOpacity(0.1), width: 0.7),
      ),
      margin: const EdgeInsets.all(8),
    ),
    // حقول النص محسنة
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.8),
      hintStyle: TextStyle(color: textSecondaryColor.withOpacity(0.7)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: coffeePrimaryColor.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: coffeePrimaryColor.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: coffeePrimaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 1.5),
      ),
      floatingLabelStyle: const TextStyle(color: coffeePrimaryColor),
      prefixIconColor: coffeePrimaryColor,
      suffixIconColor: coffeePrimaryColor,
    ),
    // أيقونات
    iconTheme: const IconThemeData(
      color: coffeeSecondaryColor,
      size: 24,
    ),
  );

  // ثيم الحلويات الباستيل
  static final sweetTheme = ThemeData(
    primaryColor: sweetPrimaryColor,
    scaffoldBackgroundColor: sweetBackgroundColor,
    colorScheme: const ColorScheme.light(
      primary: sweetPrimaryColor,
      secondary: sweetSecondaryColor,
      tertiary: sweetAccentColor,
      surface: sweetSurfaceColor,
      background: sweetBackgroundColor,
      error: errorColor,
      onPrimary: textLightColor,
      onSecondary: textLightColor,
      onSurface: textPrimaryColor,
    ),
    // استخدام نفس السمة النصية ذات حجم الخط 14
    textTheme: _baseTextTheme.copyWith(
      titleLarge: const TextStyle(
          fontSize: 20, color: sweetPrimaryColor, fontWeight: FontWeight.w600),
      titleMedium: const TextStyle(
          fontSize: 19, color: sweetPrimaryColor, fontWeight: FontWeight.w600),
      titleSmall: const TextStyle(
          fontSize: 18, color: sweetPrimaryColor, fontWeight: FontWeight.w500),
      labelLarge: const TextStyle(
          fontSize: 16,
          color: sweetSecondaryColor,
          fontWeight: FontWeight.w600),
      labelMedium: const TextStyle(fontSize: 14, color: sweetSecondaryColor),
      labelSmall: const TextStyle(fontSize: 14, color: sweetSecondaryColor),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: sweetPrimaryColor,
      foregroundColor: textLightColor,
      elevation: 2,
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
    ),
    // أزرار محسنة
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: sweetSecondaryColor,
        foregroundColor: textLightColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
      ),
    ),
    // أزرار نصية
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: sweetPrimaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    // بطاقات محسنة
    cardTheme: CardTheme(
      color: Colors.white.withOpacity(0.9),
      elevation: 4,
      shadowColor: sweetPrimaryColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: sweetPrimaryColor.withOpacity(0.2), width: 0.7),
      ),
      margin: const EdgeInsets.all(8),
    ),
    // حقول النص محسنة
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.8),
      hintStyle: TextStyle(color: textSecondaryColor.withOpacity(0.7)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: sweetPrimaryColor.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: sweetPrimaryColor.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: sweetPrimaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 1.5),
      ),
      floatingLabelStyle: const TextStyle(color: sweetPrimaryColor),
      prefixIconColor: sweetPrimaryColor,
      suffixIconColor: sweetPrimaryColor,
    ),
    // أيقونات
    iconTheme: const IconThemeData(
      color: sweetSecondaryColor,
      size: 24,
    ),
  );

  // دالة لاختيار الثيم المناسب حسب الاسم
  static ThemeData getThemeByName(String themeName) {
    switch (themeName) {
      case 'light':
        return lightTheme;
      case 'dark':
        return darkTheme;
      case 'coffee':
        return coffeeTheme;
      case 'sweet':
        return sweetTheme;
      default:
        return lightTheme;
    }
  }
}
