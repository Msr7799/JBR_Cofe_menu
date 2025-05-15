import 'package:flutter/material.dart';

class MenuOption {
  final String id;
  final String title;
  final IconData icon;
  final String route;
  final Color color;
  final bool isVisible;
  final int sortOrder;

  // استخدم const للمنشئ
  const MenuOption({
    required this.id,
    required this.title,
    required this.icon,
    required this.route,
    required this.color,
    this.isVisible = true,
    required this.sortOrder,
  });

  // تحويل من وإلى Map للتخزين في SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'icon': icon.codePoint,
      'icon_fontFamily': icon.fontFamily, // حفظ خاصية fontFamily أيضًا
      'icon_fontPackage': icon.fontPackage, // حفظ خاصية fontPackage إذا وجدت
      'route': route,
      'color': color.value,
      'isVisible': isVisible,
      'sortOrder': sortOrder,
    };
  }

  // طريقة بديلة لإنشاء كائن MenuOption من Map
  static MenuOption fromMap(Map<String, dynamic> map) {
    // استخدام الأيقونات الثابتة المعروفة من Flutter إذا أمكن
    final int iconCodePoint = map['icon'];
    final String fontFamily = map['icon_fontFamily'] ?? 'MaterialIcons';
    final String? fontPackage = map['icon_fontPackage'];
    
    return MenuOption(
      id: map['id'],
      title: map['title'],
      // استخدام const IconData للسماح بهز شجرة الأيقونات
      icon: IconData(iconCodePoint, fontFamily: fontFamily, fontPackage: fontPackage),
      route: map['route'],
      color: Color(map['color']),
      isVisible: map['isVisible'] ?? true,
      sortOrder: map['sortOrder'] ?? 0,
    );
  }

  // نسخ الكائن مع إمكانية تغيير بعض الخصائص
  MenuOption copyWith({
    String? title,
    IconData? icon,
    String? route,
    Color? color,
    bool? isVisible,
    int? sortOrder,
  }) {
    return MenuOption(
      id: id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      route: route ?? this.route,
      color: color ?? this.color,
      isVisible: isVisible ?? this.isVisible,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}