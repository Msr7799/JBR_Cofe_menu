import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // الألوان الأساسية - محسنة للوضوح والجمالية
  static const primaryColor = Color(0xFF546E7A); // رصاصي غامق
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

  // ثيم القهوة محسن بألوان عصرية
  static const mintPrimaryColor = Color(0xFF00796B); // أخضر نعناعي داكن
  static const mintSecondaryColor = Color(0xFF26A69A); // أخضر نعناعي متوسط
  static const mintAccentColor = Color(0xFF80CBC4); // أخضر نعناعي فاتح
  static const mintBackgroundColor = Color(0xFFE0F2F1); // خلفية خضراء شفافة
  static const mintSurfaceColor = Color(0xFFB2DFDB); // سطح أخضر فاتح

  // ثيم جديد: الأزرق الداكن (المحيط)
  static const oceanPrimaryColor = Color(0xFF01579B); // أزرق داكن
  static const oceanSecondaryColor = Color(0xFF039BE5); // أزرق متوسط
  static const oceanAccentColor = Color(0xFF4FC3F7); // أزرق فاتح
  static const oceanBackgroundColor = Color(0xFFE1F5FE); // خلفية زرقاء شفافة
  static const oceanSurfaceColor = Color(0xFFB3E5FC); // سطح أزرق فاتح

  // إضافة الألوان المفقودة
  // ثيم القهوة
  static const coffeePrimaryColor = Color(0xFFBCAAA4); // بيج متوسط
  static const coffeeSecondaryColor = Color(0xFFD7CCC8); // بيج فاتح
  static const coffeeAccentColor = Color(0xFFA1887F); // بيج غامق
  static const coffeeBackgroundColor = Color(0xFFF5F5F5); // أبيض مائل للبيج
  static const coffeeSurfaceColor = Color(0xFFEFEBE9); // بيج فاتح جداً

  // ثيم الحلويات الباستيل
  static const sweetPrimaryColor = Color(0xFF558B2F); // زيتي غامق
  static const sweetSecondaryColor = Color(0xFF7CB342); // زيتي متوسط
  static const sweetAccentColor = Color(0xFFAED581); // زيتي فاتح
  static const sweetBackgroundColor = Color(0xFFF1F8E9); // أخضر فاتح جداً
  static const sweetSurfaceColor = Color(0xFFDCEDC8); // أخضر فاتح

  // ألوان الثيم الداكن - أسود ورصاصي
  static const darkPrimaryColor = Color(0xFF212121); // أسود
  static const darkSecondaryColor = Color.fromARGB(255, 98, 98, 98); // رمادي داكن
  static const darkAccentColor = Color(0xFF757575); // رمادي متوسط
  static const darkBackgroundColor = Color(0xFF121212); // أسود خالص
  static const darkSurfaceColor = Color(0xFF1E1E1E); // أسود مائل للرمادي

  // تحديث حجم الخط الأساسي مع تباين لوني أفضل
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
        fontSize: 16, color: textPrimaryColor, fontWeight: FontWeight.w500),
    bodyLarge: const TextStyle(fontSize: 14, color: textPrimaryColor),
    bodyMedium: const TextStyle(fontSize: 14, color: textPrimaryColor),
    bodySmall: const TextStyle(fontSize: 14, color: textSecondaryColor),
    labelLarge: const TextStyle(
        fontSize: 16, color: textPrimaryColor, fontWeight: FontWeight.w600),
    labelMedium: const TextStyle(fontSize: 14, color: textPrimaryColor),
    labelSmall: const TextStyle(fontSize: 14, color: textSecondaryColor),
  );

  // الثيم الفاتح المحسن
  static final lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: backgroundColor,
      error: errorColor,
      onPrimary: textLightColor,
      onSecondary: textLightColor,
      onSurface: textPrimaryColor,
    ),
    textTheme: _baseTextTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
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
        backgroundColor: primaryColor,
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
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: primaryColor.withOpacity(0.05), width: 0.7),
      ),
      margin: const EdgeInsets.all(8),
    ),
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
      floatingLabelStyle: const TextStyle(color: primaryColor),
      prefixIconColor: primaryColor,
      suffixIconColor: primaryColor,
    ),
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
    iconTheme: const IconThemeData(
      color: accentColor,
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

  // الثيم الداكن المحسن
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkPrimaryColor, // أسود
    scaffoldBackgroundColor: darkBackgroundColor, // خلفية داكنة
    colorScheme: const ColorScheme.dark(
      primary: darkPrimaryColor, // أسود
      secondary: darkSecondaryColor, // رمادي داكن
      tertiary: darkAccentColor, // رمادي متوسط
      error: errorColor,
      surface: darkSurfaceColor, // أسود مائل للرمادي
      onPrimary: textLightColor,
      onSecondary: textLightColor,
      onSurface: textLightColor,
    ),
    textTheme: _baseTextTheme.apply(
      bodyColor: textLightColor,
      displayColor: textLightColor,
    ),
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
        backgroundColor: darkPrimaryColor,
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
      shadowColor: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF3F3F3F), width: 0.7),
      ),
      margin: const EdgeInsets.all(8),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2D2D2D),
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
        borderSide: const BorderSide(color: darkPrimaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 1.5),
      ),
      floatingLabelStyle: const TextStyle(color: darkPrimaryColor),
      prefixIconColor: darkPrimaryColor,
      suffixIconColor: darkPrimaryColor,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF383838),
      selectedColor: darkPrimaryColor.withOpacity(0.3),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      labelStyle: const TextStyle(color: textLightColor, fontSize: 14),
      secondaryLabelStyle: const TextStyle(
        color: darkPrimaryColor,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFF444444)),
      ),
    ),
    iconTheme: const IconThemeData(
      color: darkAccentColor,
      size: 24,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: const Color(0xFF2D2D2D),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );

  // ثيم النعناع (بديل للقهوة)
  static final mintTheme = ThemeData(
    primaryColor: mintPrimaryColor,
    scaffoldBackgroundColor: mintBackgroundColor,
    colorScheme: const ColorScheme.light(
      primary: mintPrimaryColor,
      secondary: mintSecondaryColor,
      tertiary: mintAccentColor,
      surface: mintSurfaceColor,
      error: errorColor,
      onPrimary: textLightColor,
      onSecondary: textLightColor,
      onSurface: textPrimaryColor,
    ),
    textTheme: _baseTextTheme.copyWith(
      titleLarge: const TextStyle(
          fontSize: 18, color: mintPrimaryColor, fontWeight: FontWeight.w600),
      titleMedium: const TextStyle(
          fontSize: 16, color: mintPrimaryColor, fontWeight: FontWeight.w600),
      titleSmall: const TextStyle(
          fontSize: 15, color: mintPrimaryColor, fontWeight: FontWeight.w500),
      labelLarge: const TextStyle(
          fontSize: 16, color: mintSecondaryColor, fontWeight: FontWeight.w600),
      labelMedium: const TextStyle(fontSize: 14, color: mintSecondaryColor),
      labelSmall: const TextStyle(fontSize: 14, color: mintSecondaryColor),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: mintPrimaryColor,
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
        backgroundColor: mintSecondaryColor,
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
        foregroundColor: mintPrimaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white.withOpacity(0.9),
      elevation: 4,
      shadowColor: mintPrimaryColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: mintPrimaryColor.withOpacity(0.2), width: 0.7),
      ),
      margin: const EdgeInsets.all(8),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.8),
      hintStyle: TextStyle(color: textSecondaryColor.withOpacity(0.7)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: mintPrimaryColor.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: mintPrimaryColor.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: mintPrimaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 1.5),
      ),
      floatingLabelStyle: const TextStyle(color: mintPrimaryColor),
      prefixIconColor: mintPrimaryColor,
      suffixIconColor: mintPrimaryColor,
    ),
    iconTheme: const IconThemeData(
      color: mintSecondaryColor,
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

  // ثيم القهوة الكلاسيكي
  static final coffeeTheme = ThemeData(
    primaryColor: coffeePrimaryColor,
    scaffoldBackgroundColor: coffeeBackgroundColor,
    colorScheme: const ColorScheme.light(
      primary: coffeePrimaryColor,
      secondary: coffeeSecondaryColor,
      tertiary: coffeeAccentColor,
      surface: coffeeSurfaceColor,
      error: errorColor,
      onPrimary: textLightColor,
      onSecondary: textLightColor,
      onSurface: textPrimaryColor,
    ),
    textTheme: _baseTextTheme.copyWith(
      titleLarge: const TextStyle(
          fontSize: 18, color: coffeePrimaryColor, fontWeight: FontWeight.w600),
      titleMedium: const TextStyle(
          fontSize: 16, color: coffeePrimaryColor, fontWeight: FontWeight.w600),
      titleSmall: const TextStyle(
          fontSize: 15, color: coffeePrimaryColor, fontWeight: FontWeight.w500),
      labelLarge: const TextStyle(
          fontSize: 16,
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
    // باقي إعدادات الثيم مشابهة لثيمات أخرى
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
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: coffeePrimaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white.withOpacity(0.9),
      elevation: 4,
      shadowColor: coffeePrimaryColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side:
            BorderSide(color: coffeePrimaryColor.withOpacity(0.2), width: 0.7),
      ),
      margin: const EdgeInsets.all(8),
    ),
    iconTheme: const IconThemeData(
      color: coffeeAccentColor,
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
      case 'mint':
        return mintTheme;
      case 'sweet':
        return sweetTheme;
      case 'coffee':
        return coffeeTheme;
      default:
        return lightTheme;
    }
  }
}
