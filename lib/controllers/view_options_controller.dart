import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gpr_coffee_shop/services/shared_preferences_service.dart';

class ViewOptionsController extends GetxController {
  final SharedPreferencesService _prefsService =
      Get.find<SharedPreferencesService>();

  // خصائص عرض المنتجات
  final RxString viewMode = 'grid'.obs;
  final RxBool showImages = true.obs;

  // خصائص إضافية للعرض والتفاعل
  final RxBool useAnimations = true.obs;
  final RxBool showOrderButton = true.obs;

  // إضافة متغيرات للتحكم في مظهر خيارات الهوم سكرين
  final RxBool useTransparentCardBackground = true.obs; // خلفية شفافة أو بيضاء
  final RxString optionTextColor =
      '#000000'.obs; // لون خط الخيارات (أسود افتراضياً)
  final RxString optionIconColor =
      '#546E7A'.obs; // لون أيقونات الخيارات (رمادي غامق افتراضياً)
  final RxDouble optionTextSize = 16.0.obs; // حجم خط الخيارات
  final RxBool useCustomIconColors =
      false.obs; // استخدام لون مخصص للأيقونات أم الألوان الأصلية
  final RxString optionBorderColor = '#546E7A'.obs; // لون حدود الخيارات

  // خصائص جديدة لتحجيم النصوص
  final RxDouble productTitleFontSize = 16.0.obs; // حجم خط عنوان المنتج
  final RxDouble productPriceFontSize = 14.0.obs; // حجم خط سعر المنتج
  final RxDouble productButtonFontSize = 14.0.obs; // حجم خط زر الطلب

  // خصائص جديدة لتحجيم عناصر الواجهة
  final RxDouble productCardWidth = 180.0.obs; // عرض بطاقة المنتج
  final RxDouble productCardHeight = 220.0.obs; // ارتفاع بطاقة المنتج
  final RxDouble productImageHeight = 120.0.obs; // ارتفاع صورة المنتج

  // إضافة متغير للتحكم في تفعيل إعدادات الشاشة الصغيرة
  final RxBool useSmallScreenSettings = false.obs;

  // إضافة متغيرات للشاشات الصغيرة
  final RxString smallScreenOptionTextColor =
      '#000000'.obs; // لون النص للشاشات الصغيرة
  final RxString smallScreenOptionIconColor =
      '#546E7A'.obs; // لون الأيقونة للشاشات الصغيرة
  final RxString smallScreenOptionBorderColor =
      '#546E7A'.obs; // لون الحدود للشاشات الصغيرة
  final RxDouble smallScreenOptionTextSize =
      14.0.obs; // حجم النص للشاشات الصغيرة

  // إضافة متغيرات جديدة للتحكم بخلفية الخيارات في الهوم
  final RxString optionBackgroundColor = '#FFFFFF'.obs; // لون خلفية الخيارات
  final RxDouble optionBackgroundOpacity = 0.2.obs; // درجة شفافية خلفية الخيارات (20% كقيمة افتراضية)
  final RxBool useOptionShadows = false.obs; // تفعيل/إلغاء ظلال الخيارات
  final RxDouble optionWidth = 0.0.obs; // عرض الخيارات (0 تعني استخدام العرض التلقائي)
  final RxDouble optionHeight = 60.0.obs; // ارتفاع الخيارات
  final RxDouble optionSpacing = 8.0.obs; // المسافة بين الخيارات
  final RxDouble optionPadding = 16.0.obs; // التباعد الداخلي للخيارات
  final RxDouble optionCornerRadius = 12.0.obs; // نصف قطر زوايا الخيارات

  @override
  void onInit() {
    super.onInit();
    _loadPreferences();
  }

  void _loadPreferences() {
    // تحميل الإعدادات الحالية
    viewMode.value = _prefsService.getString('view_mode', defaultVal: 'grid');
    showImages.value = _prefsService.getBool('show_images', defaultVal: true);
    useAnimations.value =
        _prefsService.getBool('use_animations', defaultVal: true);
    showOrderButton.value =
        _prefsService.getBool('show_order_button', defaultVal: true);

    // تحميل إعدادات مظهر خيارات الهوم سكرين
    useTransparentCardBackground.value = _prefsService
        .getBool('use_transparent_card_background', defaultVal: true);
    optionTextColor.value =
        _prefsService.getString('option_text_color', defaultVal: '#000000');
    optionIconColor.value =
        _prefsService.getString('option_icon_color', defaultVal: '#546E7A');
    optionTextSize.value =
        _prefsService.getDouble('option_text_size', defaultVal: 16.0);
    useCustomIconColors.value =
        _prefsService.getBool('use_custom_icon_colors', defaultVal: false);
    optionBorderColor.value =
        _prefsService.getString('option_border_color', defaultVal: '#546E7A');

    // تحميل خيارات حجم الخط
    productTitleFontSize.value =
        _prefsService.getDouble('product_title_font_size', defaultVal: 16.0);
    productPriceFontSize.value =
        _prefsService.getDouble('product_price_font_size', defaultVal: 14.0);
    productButtonFontSize.value =
        _prefsService.getDouble('product_button_font_size', defaultVal: 14.0);

    // تحميل خيارات حجم عناصر الواجهة
    productCardWidth.value =
        _prefsService.getDouble('product_card_width', defaultVal: 180.0);
    productCardHeight.value =
        _prefsService.getDouble('product_card_height', defaultVal: 220.0);
    productImageHeight.value =
        _prefsService.getDouble('product_image_height', defaultVal: 120.0);

    // تحميل إعدادات الشاشات الصغيرة
    useSmallScreenSettings.value =
        _prefsService.getBool('use_small_screen_settings', defaultVal: false);
    smallScreenOptionTextColor.value = _prefsService
        .getString('small_screen_option_text_color', defaultVal: '#000000');
    smallScreenOptionIconColor.value = _prefsService
        .getString('small_screen_option_icon_color', defaultVal: '#546E7A');
    smallScreenOptionBorderColor.value = _prefsService
        .getString('small_screen_option_border_color', defaultVal: '#546E7A');
    smallScreenOptionTextSize.value = _prefsService
        .getDouble('small_screen_option_text_size', defaultVal: 14.0);

    // تحميل الإعدادات الجديدة
    optionBackgroundColor.value = 
      _prefsService.getString('option_background_color', defaultVal: '#FFFFFF');
    optionBackgroundOpacity.value = 
      _prefsService.getDouble('option_background_opacity', defaultVal: 0.2);
    useOptionShadows.value = 
      _prefsService.getBool('use_option_shadows', defaultVal: false);
    optionWidth.value = 
      _prefsService.getDouble('option_width', defaultVal: 0.0);
    optionHeight.value = 
      _prefsService.getDouble('option_height', defaultVal: 60.0);
    optionSpacing.value = 
      _prefsService.getDouble('option_spacing', defaultVal: 8.0);
    optionPadding.value = 
      _prefsService.getDouble('option_padding', defaultVal: 16.0);
    optionCornerRadius.value = 
      _prefsService.getDouble('option_corner_radius', defaultVal: 12.0);
  }

  // دوال مساعدة لتحويل اللون من نص إلى كائن Color
  Color getColorFromHex(String hexString) {
    hexString = hexString.replaceAll("#", "");
    if (hexString.length == 6) {
      hexString = "FF" + hexString;
    }
    return Color(int.parse(hexString, radix: 16));
  }

  // دوال حفظ إعدادات مظهر خيارات الهوم سكرين
  void saveCardBackgroundType(bool isTransparent) {
    useTransparentCardBackground.value = isTransparent;
    _prefsService.setBool('use_transparent_card_background', isTransparent);
    update(['home_options_list', 'landscape_options']);
  }

  void saveOptionTextColor(String colorHex) {
    optionTextColor.value = colorHex;
    _prefsService.setString('option_text_color', colorHex);
    update(['home_options_list', 'landscape_options']);
  }

  void saveOptionIconColor(String colorHex) {
    optionIconColor.value = colorHex;
    _prefsService.setString('option_icon_color', colorHex);
    update(['home_options_list']);
  }

  void saveOptionBorderColor(String colorHex) {
    optionBorderColor.value = colorHex;
    _prefsService.setString('option_border_color', colorHex);
    update(['home_options_list', 'landscape_options']);
  }

  void saveOptionTextSize(double size) {
    optionTextSize.value = size;
    _prefsService.setDouble('option_text_size', size);
    update(['home_options_list', 'landscape_options']);
  }

  void saveUseCustomIconColors(bool useCustom) {
    useCustomIconColors.value = useCustom;
    _prefsService.setBool('use_custom_icon_colors', useCustom);
    update(['home_options_list', 'landscape_options']);
  }

  // حفظ وضع العرض
  void saveViewMode(String mode) {
    viewMode.value = mode;
    _prefsService.setString('view_mode', mode);
  }

  // حفظ إعداد عرض الصور
  void saveShowImages(bool show) {
    showImages.value = show;
    _prefsService.setBool('show_images', show);
  }

  // حفظ إعداد استخدام التأثيرات الحركية
  void saveUseAnimations(bool use) {
    useAnimations.value = use;
    _prefsService.setBool('use_animations', use);
  }

  // حفظ إعداد عرض زر الطلب
  void saveShowOrderButton(bool show) {
    showOrderButton.value = show;
    _prefsService.setBool('show_order_button', show);
  }

  // دوال حفظ خيارات حجم الخط
  void saveProductTitleFontSize(double size) {
    productTitleFontSize.value = size;
    _prefsService.setDouble('product_title_font_size', size);
  }

  void saveProductPriceFontSize(double size) {
    productPriceFontSize.value = size;
    _prefsService.setDouble('product_price_font_size', size);
  }

  void saveProductButtonFontSize(double size) {
    productButtonFontSize.value = size;
    _prefsService.setDouble('product_button_font_size', size);
  }

  // دوال حفظ خيارات حجم عناصر الواجهة
  void saveProductCardWidth(double width) {
    productCardWidth.value = width;
    _prefsService.setDouble('product_card_width', width);
  }

  void saveProductCardHeight(double height) {
    productCardHeight.value = height;
    _prefsService.setDouble('product_card_height', height);
  }

  void saveProductImageHeight(double height) {
    productImageHeight.value = height;
    _prefsService.setDouble('product_image_height', height);
  }

  // إضافة دوال للتحكم في إعدادات الشاشات الصغيرة
  void saveUseSmallScreenSettings(bool useSmall) {
    useSmallScreenSettings.value = useSmall;
    _prefsService.setBool('use_small_screen_settings', useSmall);
    update(['home_options_list']);
  }

  void saveSmallScreenOptionTextColor(String colorHex) {
    smallScreenOptionTextColor.value = colorHex;
    _prefsService.setString('small_screen_option_text_color', colorHex);
    update(['home_options_list']);
  }

  void saveSmallScreenOptionIconColor(String colorHex) {
    smallScreenOptionIconColor.value = colorHex;
    _prefsService.setString('small_screen_option_icon_color', colorHex);
    update(['home_options_list']);
  }

  void saveSmallScreenOptionBorderColor(String colorHex) {
    smallScreenOptionBorderColor.value = colorHex;
    _prefsService.setString('small_screen_option_border_color', colorHex);
    update(['home_options_list']);
  }

  void saveSmallScreenOptionTextSize(double size) {
    smallScreenOptionTextSize.value = size;
    _prefsService.setDouble('small_screen_option_text_size', size);
    update(['home_options_list']);
  }

  // إضافة هذه الدوال لدعم خيارات الشاشات الصغيرة بشكل صحيح

  // الحصول على لون أو حجم النص المناسب حسب حجم الشاشة
  String getOptionTextColor(bool isSmallScreen) {
    if (isSmallScreen && useSmallScreenSettings.value) {
      return smallScreenOptionTextColor.value;
    }
    return optionTextColor.value;
  }

  String getOptionIconColor(bool isSmallScreen) {
    if (isSmallScreen && useSmallScreenSettings.value) {
      return smallScreenOptionIconColor.value;
    }
    return optionIconColor.value;
  }

  String getOptionBorderColor(bool isSmallScreen) {
    if (isSmallScreen && useSmallScreenSettings.value) {
      return smallScreenOptionBorderColor.value;
    }
    return optionBorderColor.value;
  }

  double getOptionTextSize(bool isSmallScreen) {
    if (isSmallScreen && useSmallScreenSettings.value) {
      return smallScreenOptionTextSize.value;
    }
    return optionTextSize.value;
  }

  // دوال لحفظ الإعدادات الجديدة
  void saveOptionBackgroundColor(String colorHex) {
    optionBackgroundColor.value = colorHex;
    _prefsService.setString('option_background_color', colorHex);
    update(['home_options_list', 'landscape_options']);
  }

  void saveOptionBackgroundOpacity(double opacity) {
    optionBackgroundOpacity.value = opacity;
    _prefsService.setDouble('option_background_opacity', opacity);
    update(['home_options_list', 'landscape_options']);
  }

  void saveUseOptionShadows(bool useShadows) {
    useOptionShadows.value = useShadows;
    _prefsService.setBool('use_option_shadows', useShadows);
    update(['home_options_list', 'landscape_options']);
  }

  void saveOptionWidth(double width) {
    optionWidth.value = width;
    _prefsService.setDouble('option_width', width);
    update(['home_options_list', 'landscape_options']);
  }

  void saveOptionHeight(double height) {
    optionHeight.value = height;
    _prefsService.setDouble('option_height', height);
    update(['home_options_list', 'landscape_options']);
  }

  void saveOptionSpacing(double spacing) {
    optionSpacing.value = spacing;
    _prefsService.setDouble('option_spacing', spacing);
    update(['home_options_list', 'landscape_options']);
  }

  void saveOptionPadding(double padding) {
    optionPadding.value = padding;
    _prefsService.setDouble('option_padding', padding);
    update(['home_options_list', 'landscape_options']);
  }

  void saveOptionCornerRadius(double radius) {
    optionCornerRadius.value = radius;
    _prefsService.setDouble('option_corner_radius', radius);
    update(['home_options_list', 'landscape_options']);
  }

  // حفظ جميع الإعدادات دفعة واحدة
  void saveAllSettings() {
    _prefsService.setString('view_mode', viewMode.value);
    _prefsService.setBool('show_images', showImages.value);
    _prefsService.setBool('use_animations', useAnimations.value);
    _prefsService.setBool('show_order_button', showOrderButton.value);

    // حفظ إعدادات مظهر خيارات الهوم سكرين
    _prefsService.setBool(
        'use_transparent_card_background', useTransparentCardBackground.value);
    _prefsService.setString('option_text_color', optionTextColor.value);
    _prefsService.setString('option_icon_color', optionIconColor.value);
    _prefsService.setDouble('option_text_size', optionTextSize.value);
    _prefsService.setBool('use_custom_icon_colors', useCustomIconColors.value);
    _prefsService.setString('option_border_color', optionBorderColor.value);

    // حفظ إعدادات حجم الخط
    _prefsService.setDouble(
        'product_title_font_size', productTitleFontSize.value);
    _prefsService.setDouble(
        'product_price_font_size', productPriceFontSize.value);
    _prefsService.setDouble(
        'product_button_font_size', productButtonFontSize.value);

    // حفظ إعدادات حجم عناصر الواجهة
    _prefsService.setDouble('product_card_width', productCardWidth.value);
    _prefsService.setDouble('product_card_height', productCardHeight.value);
    _prefsService.setDouble('product_image_height', productImageHeight.value);

    // حفظ إعدادات الشاشات الصغيرة
    _prefsService.setBool(
        'use_small_screen_settings', useSmallScreenSettings.value);
    _prefsService.setString(
        'small_screen_option_text_color', smallScreenOptionTextColor.value);
    _prefsService.setString(
        'small_screen_option_icon_color', smallScreenOptionIconColor.value);
    _prefsService.setString(
        'small_screen_option_border_color', smallScreenOptionBorderColor.value);
    _prefsService.setDouble(
        'small_screen_option_text_size', smallScreenOptionTextSize.value);

    // حفظ الإعدادات الجديدة
    _prefsService.setString('option_background_color', optionBackgroundColor.value);
    _prefsService.setDouble('option_background_opacity', optionBackgroundOpacity.value);
    _prefsService.setBool('use_option_shadows', useOptionShadows.value);
    _prefsService.setDouble('option_width', optionWidth.value);
    _prefsService.setDouble('option_height', optionHeight.value);
    _prefsService.setDouble('option_spacing', optionSpacing.value);
    _prefsService.setDouble('option_padding', optionPadding.value);
    _prefsService.setDouble('option_corner_radius', optionCornerRadius.value);
  }
}
