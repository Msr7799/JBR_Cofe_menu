import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gpr_coffee_shop/services/shared_preferences_service.dart';

/// مساعد لإدارة خيارات العرض في التطبيق
class ViewOptionsHelper {
  // مفاتيح التخزين
  static const String _viewModeKey = 'menu_view_mode';
  static const String _showImagesKey = 'show_images';
  static const String _useAnimationsKey = 'use_animations';
  static const String _showOrderButtonKey = 'show_order_button';

  // القيم الافتراضية
  static const String _defaultViewMode = 'grid';
  static const bool _defaultShowImages = true;
  static const bool _defaultUseAnimations = true;
  static const bool _defaultShowOrderButton = true;

  // الحصول على خدمة التفضيلات المشتركة
  static SharedPreferencesService _getPrefs() {
    return Get.find<SharedPreferencesService>();
  }

  /// الحصول على وضع العرض الحالي
  static String getViewMode() {
    return _getPrefs().getString(_viewModeKey, defaultVal: _defaultViewMode);
  }

  /// حفظ وضع العرض
  static Future<void> saveViewMode(String mode) async {
    await _getPrefs().setString(_viewModeKey, mode);
  }

  /// التحقق مما إذا كان يجب عرض الصور
  static bool getShowImages() {
    return _getPrefs().getBool(_showImagesKey, defaultVal: _defaultShowImages);
  }

  /// حفظ إعداد عرض الصور
  static Future<void> saveShowImages(bool show) async {
    await _getPrefs().setBool(_showImagesKey, show);
  }

  /// التحقق مما إذا كان يجب استخدام التأثيرات الحركية
  static bool getUseAnimations() {
    return _getPrefs()
        .getBool(_useAnimationsKey, defaultVal: _defaultUseAnimations);
  }

  /// حفظ إعداد استخدام التأثيرات الحركية
  static Future<void> saveUseAnimations(bool use) async {
    await _getPrefs().setBool(_useAnimationsKey, use);
  }

  /// التحقق مما إذا كان يجب عرض زر الطلب
  static bool getShowOrderButton() {
    return _getPrefs()
        .getBool(_showOrderButtonKey, defaultVal: _defaultShowOrderButton);
  }

  /// حفظ إعداد عرض زر الطلب
  static Future<void> saveShowOrderButton(bool show) async {
    await _getPrefs().setBool(_showOrderButtonKey, show);
  }
}
