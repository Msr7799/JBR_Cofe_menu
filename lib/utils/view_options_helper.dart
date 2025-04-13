import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gpr_coffee_shop/services/shared_preferences_service.dart';
import 'package:flutter/material.dart';

/// مساعد لإدارة خيارات العرض في التطبيق
class ViewOptionsHelper {
  // مفاتيح التخزين
  static const String _viewModeKey = 'menu_view_mode';
  static const String _showImagesKey = 'show_images';
  static const String _useAnimationsKey = 'use_animations';
  static const String _showOrderButtonKey = 'show_order_button';
  static const String _cardSizeKey = 'card_size';
  static const String _textColorKey = 'text_color';
  static const String _priceColorKey = 'price_color';
  static const String _displayModeKey = 'display_mode';

  // القيم الافتراضية
  static const String _defaultViewMode = 'grid';
  static const bool _defaultShowImages = true;
  static const bool _defaultUseAnimations = true;
  static const bool _defaultShowOrderButton = true;
  static const double _defaultCardSize = 1.0;
  static const int _defaultTextColor = 0xFF000000; // أسود
  static const int _defaultPriceColor = 0xFF800000; // اللون الأساسي
  static const String _defaultDisplayMode = 'products';

  // الحصول على خدمة التفضيلات المشتركة
  static SharedPreferencesService _getPrefs() {
    return Get.find<SharedPreferencesService>();
  }

  /// الحصول على وضع العرض الحالي (شبكي، قائمة، مدمج)
  static String getViewMode() {
    return _getPrefs().getString(_viewModeKey, defaultVal: _defaultViewMode);
  }

  /// حفظ وضع العرض
  static Future<void> saveViewMode(String mode) async {
    await _getPrefs().setString(_viewModeKey, mode);
  }

  /// الحصول على طريقة عرض القائمة (فئات، منتجات)
  static String getDisplayMode() {
    return _getPrefs()
        .getString(_displayModeKey, defaultVal: _defaultDisplayMode);
  }

  /// حفظ طريقة عرض القائمة
  static Future<void> saveDisplayMode(String mode) async {
    await _getPrefs().setString(_displayModeKey, mode);
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

  /// الحصول على حجم بطاقة المنتج
  static double getCardSize() {
    return _getPrefs().getDouble(_cardSizeKey, defaultVal: _defaultCardSize);
  }

  /// حفظ حجم بطاقة المنتج
  static Future<void> saveCardSize(double size) async {
    await _getPrefs().setDouble(_cardSizeKey, size);
  }

  /// الحصول على لون نص عنوان المنتج
  static int getTextColor() {
    return _getPrefs().getInt(_textColorKey, defaultVal: _defaultTextColor);
  }

  /// حفظ لون نص عنوان المنتج
  static Future<void> saveTextColor(int colorValue) async {
    await _getPrefs().setInt(_textColorKey, colorValue);
  }

  /// الحصول على لون السعر
  static int getPriceColor() {
    return _getPrefs().getInt(_priceColorKey, defaultVal: _defaultPriceColor);
  }

  /// حفظ لون السعر
  static Future<void> savePriceColor(int colorValue) async {
    await _getPrefs().setInt(_priceColorKey, colorValue);
  }

  /// الحصول على كائن Color من لون النص المحفوظ
  static Color getTextColorAsColor() {
    return Color(getTextColor());
  }

  /// الحصول على كائن Color من لون السعر المحفوظ
  static Color getPriceColorAsColor() {
    return Color(getPriceColor());
  }

  /// إعادة ضبط جميع الإعدادات إلى القيم الافتراضية
  static Future<void> resetAllSettings() async {
    await saveViewMode(_defaultViewMode);
    await saveShowImages(_defaultShowImages);
    await saveUseAnimations(_defaultUseAnimations);
    await saveShowOrderButton(_defaultShowOrderButton);
    await saveCardSize(_defaultCardSize);
    await saveTextColor(_defaultTextColor);
    await savePriceColor(_defaultPriceColor);
    await saveDisplayMode(_defaultDisplayMode);
  }
}
