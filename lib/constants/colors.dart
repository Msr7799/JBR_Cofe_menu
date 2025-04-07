import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const primary = Color(0xFF6366F1);
  static const secondary = Color(0xFF22D3EE);
  static const accent = Color(0xFFF43F5E);

  // Background Colors
  static const background = Color(0xFFF9FAFB);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceDark = Color(0xFF1E293B);

  // Text Colors
  static const textPrimary = Color(0xFF1F2937);
  static const textSecondary = Color(0xFF6B7280);
  static const textLight = Color(0xFFF9FAFB);

  // Status Colors
  static const success = Color(0xFF10B981);
  static const error = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);
  static const info = Color(0xFF3B82F6);

  // Additional Colors
  static const divider = Color(0xFFE2E8F0);
  static const disabled = Color(0xFFE5E7EB);
}

extension ColorExtensions on Color {
  // تحديث الطرق المهملة باستخدام الطرق الجديدة
  int get rInt => r.toInt();
  int get gInt => g.toInt();
  int get bInt => b.toInt();
}
