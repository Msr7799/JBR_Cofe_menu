import 'package:flutter/material.dart';

/// تجاوز لأخطاء fl_chart المتعلقة بـ MediaQuery
class ChartUtils {
  /// بديل لـ MediaQuery.boldTextOverride
  static bool getBoldTextOverride(BuildContext context) {
    return MediaQuery.of(context).boldText;
  }
}

/// إضافة خصائص للـ MediaQuery
extension MediaQueryExtension on MediaQuery {
  static bool boldTextOverride(BuildContext context) {
    return MediaQuery.of(context).boldText;
  }
}

/// إضافة خصائص للـ MediaQueryData
extension MediaQueryDataExtension on MediaQueryData {
  static bool boldTextOverride(BuildContext context) {
    return MediaQuery.of(context).boldText;
  }
}