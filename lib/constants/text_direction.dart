import 'package:flutter/material.dart';

/// ثابت لتحديد اتجاه النص في التطبيق
const TextDirection arabicTextDirection = TextDirection.rtl;

/// دالة مساعدة لتغليف الواجهات باتجاه النص العربي
Widget wrapWithTextDirection(Widget child) {
  return Directionality(
    textDirection: arabicTextDirection,
    child: child,
  );
}

/// اتجاه النص للتنسيق
const TextDirection defaultTextDirection = TextDirection.rtl;

/// مغلف للحوارات لتوحيد اتجاه النص
Widget wrapDialogWithTextDirection(Widget dialog) {
  return Directionality(
    textDirection: arabicTextDirection,
    child: dialog,
  );
}

/// تنسيق النص العربي الافتراضي
const TextStyle arabicTextStyle = TextStyle(
  fontFamily: 'Cairo',
  // يمكن إضافة المزيد من خصائص التنسيق هنا
);

/// تهيئة اتجاه النص للمحتوى العربي
const TextAlign arabicTextAlign = TextAlign.right;

/// اتجاه محاذاة العناصر للعربية
const CrossAxisAlignment arabicCrossAxisAlignment = CrossAxisAlignment.start;

/// هوامش النص العربي
const EdgeInsets arabicTextPadding = EdgeInsets.only(right: 16.0);

/// هوامش المحتوى العربي
const EdgeInsets arabicContentPadding = EdgeInsets.symmetric(horizontal: 16.0);

/// الزخرفة الافتراضية للنص العربي
const InputDecoration arabicInputDecoration = InputDecoration(
  border: OutlineInputBorder(),
  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
  // يمكن إضافة المزيد من خصائص التنسيق هنا
);

/// تنسيقات النص العربي حسب الحجم
class ArabicTextStyles {
  static const TextStyle headline1 = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headline2 = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle body1 = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 16,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 14,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 12,
    color: Colors.grey,
  );
}
