import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart'; // Add Flutter material import for Color

class ViewOptionsHelper {
  static final GetStorage _box = GetStorage();

  // قيم افتراضية
  static const String _defaultViewMode = 'grid';
  static const String _defaultDisplayMode = 'categorized';
  static const bool _defaultShowImages = true;
  static const bool _defaultUseAnimations = true;
  static const bool _defaultShowOrderButton = true;
  static const double _defaultCardSize = 1.0;
  static const int _defaultTextColor = 0xFF000000; // أسود
  static const int _defaultPriceColor = 0xFF4CAF50; // أخضر

  // قيم افتراضية للإضافات الجديدة
  static const double _defaultProductTitleFontSize = 16.0;
  static const double _defaultProductPriceFontSize = 14.0;
  static const double _defaultProductButtonFontSize = 14.0;
  static const double _defaultProductCardWidth = 200.0;
  static const double _defaultProductCardHeight = 250.0;
  static const double _defaultProductImageHeight = 120.0;
  // قيمة افتراضية للاستمرار في التكرار
  static const bool _defaultContinueToIterate = true;

  // إضافة الثوابت الافتراضية للشاشات الكبيرة والصغيرة
  // قيم الشاشات الكبيرة
  static const double _defaultLargeScreenCardWidth = 260.0;
  static const double _defaultLargeScreenCardHeight = 310.0;
  static const double _defaultLargeScreenImageHeight = 150.0;

  // قيم الشاشات الصغيرة
  static const double _defaultSmallScreenCardWidth = 220.0;
  static const double _defaultSmallScreenCardHeight = 240.0;
  static const double _defaultSmallScreenImageHeight = 120.0;

  // مفاتيح التخزين
  static const String _viewModeKey = 'viewMode';
  static const String _displayModeKey = 'displayMode';
  static const String _showImagesKey = 'showImages';
  static const String _useAnimationsKey = 'useAnimations';
  static const String _showOrderButtonKey = 'showOrderButton';
  static const String _cardSizeKey = 'cardSize';
  static const String _textColorKey = 'textColor';
  static const String _priceColorKey = 'priceColor';

  // مفاتيح التخزين للإضافات الجديدة
  static const String _productTitleFontSizeKey = 'productTitleFontSize';
  static const String _productPriceFontSizeKey = 'productPriceFontSize';
  static const String _productButtonFontSizeKey = 'productButtonFontSize';
  static const String _productCardWidthKey = 'productCardWidth';
  static const String _productCardHeightKey = 'productCardHeight';
  static const String _productImageHeightKey = 'productImageHeight';
  // مفتاح التخزين للاستمرار في التكرار
  static const String _continueToIterateKey = 'continueToIterate';

  // دوال الحصول على القيم
  static String getViewMode() {
    return _box.read(_viewModeKey) ?? _defaultViewMode;
  }

  static String getDisplayMode() {
    return _box.read(_displayModeKey) ?? _defaultDisplayMode;
  }

  static bool getShowImages() {
    return _box.read(_showImagesKey) ?? _defaultShowImages;
  }

  static bool getUseAnimations() {
    return _box.read(_useAnimationsKey) ?? _defaultUseAnimations;
  }

  static bool getShowOrderButton() {
    return _box.read(_showOrderButtonKey) ?? _defaultShowOrderButton;
  }

  static double getCardSize() {
    return _box.read(_cardSizeKey) ?? _defaultCardSize;
  }

  static int getTextColor() {
    return _box.read(_textColorKey) ?? _defaultTextColor;
  }

  static int getPriceColor() {
    return _box.read(_priceColorKey) ?? _defaultPriceColor;
  }

  // دوال الحصول على القيم للإضافات الجديدة
  static double getProductTitleFontSize() {
    return _box.read(_productTitleFontSizeKey) ?? _defaultProductTitleFontSize;
  }

  static double getProductPriceFontSize() {
    return _box.read(_productPriceFontSizeKey) ?? _defaultProductPriceFontSize;
  }

  static double getProductButtonFontSize() {
    return _box.read(_productButtonFontSizeKey) ??
        _defaultProductButtonFontSize;
  }

  static double getProductCardWidth() {
    final isLargeScreen = getIsLargeScreen();
    final defaultWidth = isLargeScreen
        ? _defaultLargeScreenCardWidth
        : _defaultSmallScreenCardWidth;
    return _box.read(_productCardWidthKey) ?? defaultWidth;
  }

  static double getProductCardHeight() {
    final isLargeScreen = getIsLargeScreen();
    final defaultHeight = isLargeScreen
        ? _defaultLargeScreenCardHeight
        : _defaultSmallScreenCardHeight;
    return _box.read(_productCardHeightKey) ?? defaultHeight;
  }

  static double getProductImageHeight() {
    final isLargeScreen = getIsLargeScreen();
    final defaultImageHeight = isLargeScreen
        ? _defaultLargeScreenImageHeight
        : _defaultSmallScreenImageHeight;
    return _box.read(_productImageHeightKey) ?? defaultImageHeight;
  }

  // إضافة دالة للحصول على قيمة الاستمرار في التكرار
  static bool getContinueToIterate() {
    return _box.read(_continueToIterateKey) ?? _defaultContinueToIterate;
  }

  // إضافة دالة تخزين واسترجاع نوع الشاشة (كبيرة أو صغيرة)
  static bool getIsLargeScreen() {
    return _box.read('is_large_screen') ?? true; // الافتراضي للشاشات الكبيرة
  }

  static void saveIsLargeScreen(bool isLargeScreen) {
    _box.write('is_large_screen', isLargeScreen);
  }

  // دوال حفظ القيم
  static void saveViewMode(String viewMode) {
    _box.write(_viewModeKey, viewMode);
  }

  static void saveDisplayMode(String displayMode) {
    _box.write(_displayModeKey, displayMode);
  }

  static void saveShowImages(bool showImages) {
    _box.write(_showImagesKey, showImages);
  }

  static void saveUseAnimations(bool useAnimations) {
    _box.write(_useAnimationsKey, useAnimations);
  }

  static void saveShowOrderButton(bool showOrderButton) {
    _box.write(_showOrderButtonKey, showOrderButton);
  }

  static void saveCardSize(double cardSize) {
    _box.write(_cardSizeKey, cardSize);
  }

  static void saveTextColor(int textColor) {
    _box.write(_textColorKey, textColor);
  }

  static void savePriceColor(int priceColor) {
    _box.write(_priceColorKey, priceColor);
  }

  // دوال حفظ القيم للإضافات الجديدة
  static void saveProductTitleFontSize(double size) {
    _box.write(_productTitleFontSizeKey, size);
  }

  static void saveProductPriceFontSize(double size) {
    _box.write(_productPriceFontSizeKey, size);
  }

  static void saveProductButtonFontSize(double size) {
    _box.write(_productButtonFontSizeKey, size);
  }

  static void saveProductCardWidth(double width) {
    _box.write(_productCardWidthKey, width);
  }

  static void saveProductCardHeight(double height) {
    _box.write(_productCardHeightKey, height);
  }

  static void saveProductImageHeight(double height) {
    _box.write(_productImageHeightKey, height);
  }

  // إضافة دالة لحفظ قيمة الاستمرار في التكرار
  static void saveContinueToIterate(bool continueToIterate) {
    _box.write(_continueToIterateKey, continueToIterate);
  }

  // دوال حفظ الإعدادات حسب حجم الشاشة
  static void saveScreenSizePreset(bool isLargeScreen) {
    saveIsLargeScreen(isLargeScreen);

    if (isLargeScreen) {
      saveProductCardWidth(_defaultLargeScreenCardWidth);
      saveProductCardHeight(_defaultLargeScreenCardHeight);
      saveProductImageHeight(_defaultLargeScreenImageHeight);
    } else {
      saveProductCardWidth(_defaultSmallScreenCardWidth);
      saveProductCardHeight(_defaultSmallScreenCardHeight);
      saveProductImageHeight(_defaultSmallScreenImageHeight);
    }

    // تعيين حجم الخط إلى متوسط
    saveProductTitleFontSize(16.0);
    saveProductPriceFontSize(14.0);
    saveProductButtonFontSize(14.0);

    // تعيين حجم البطاقة إلى متوسط
    saveCardSize(1.0);
  }

  // Method to convert integer text color to Flutter Color
  static Color getTextColorAsColor() {
    return Color(getTextColor());
  }

  // Method to convert integer price color to Flutter Color
  static Color getPriceColorAsColor() {
    return Color(getPriceColor());
  }
}

