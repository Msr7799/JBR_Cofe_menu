import 'package:get/get.dart';
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

  // خصائص جديدة لتحجيم النصوص
  final RxDouble productTitleFontSize = 16.0.obs; // حجم خط عنوان المنتج
  final RxDouble productPriceFontSize = 14.0.obs; // حجم خط سعر المنتج
  final RxDouble productButtonFontSize = 14.0.obs; // حجم خط زر الطلب

  // خصائص جديدة لتحجيم عناصر الواجهة
  final RxDouble productCardWidth = 180.0.obs; // عرض بطاقة المنتج
  final RxDouble productCardHeight = 220.0.obs; // ارتفاع بطاقة المنتج
  final RxDouble productImageHeight = 120.0.obs; // ارتفاع صورة المنتج

  @override
  void onInit() {
    super.onInit();
    _loadPreferences();
  }

  void _loadPreferences() {
    // تصحيح استخدام defaultVal بدلاً من defaultValue
    viewMode.value = _prefsService.getString('view_mode', defaultVal: 'grid');
    showImages.value = _prefsService.getBool('show_images', defaultVal: true);
    useAnimations.value =
        _prefsService.getBool('use_animations', defaultVal: true);
    showOrderButton.value =
        _prefsService.getBool('show_order_button', defaultVal: true);

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

  // حفظ جميع الإعدادات دفعة واحدة
  void saveAllSettings() {
    _prefsService.setString('view_mode', viewMode.value);
    _prefsService.setBool('show_images', showImages.value);
    _prefsService.setBool('use_animations', useAnimations.value);
    _prefsService.setBool('show_order_button', showOrderButton.value);

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
  }
}
