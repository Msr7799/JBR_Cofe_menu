import 'package:flutter/material.dart';

/// ثوابت الألوان المستخدمة في التطبيق
class AppColors {
  // منع إنشاء نسخة من الكلاس
  AppColors._();

  // الألوان الأساسية
  static const Color primary = Color(0xFF8B5A2B); // بني داكن
  static const Color secondary = Color(0xFFD2B48C); // بني فاتح (بيج)
  static const Color accent = Color(0xFF5D4037); // بني محمر

  // ألوان الخلفية
  static const Color background = Color(0xFFF5F5F5); // رمادي فاتح جدًا
  static const Color surface = Colors.white;
  static const Color card = Colors.white;

  // ألوان النص
  static const Color textPrimary = Color(0xFF212121); // أسود داكن
  static const Color textSecondary = Color(0xFF757575); // رمادي متوسط
  static const Color textLight = Color(0xFFBDBDBD); // رمادي فاتح

  // ألوان الحالة
  static const Color success = Color(0xFF4CAF50); // أخضر
  static const Color error = Color(0xFFE53935); // أحمر
  static const Color warning = Color(0xFFFFA000); // برتقالي
  static const Color info = Color(0xFF2196F3); // أزرق

  // ألوان أخرى
  static const Color divider = Color(0xFFE0E0E0); // رمادي فاتح للفواصل
  static const Color disabled = Color(0xFFBDBDBD); // رمادي للعناصر المعطلة
  static const Color overlay = Color(0x80000000); // أسود شفاف للطبقات العلوية

  // تدرجات لونية
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, Color(0xFFE6CCB2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
