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

  // حفظ جميع الإعدادات دفعة واحدة
  void saveAllSettings() {
    _prefsService.setString('view_mode', viewMode.value);
    _prefsService.setBool('show_images', showImages.value);
    _prefsService.setBool('use_animations', useAnimations.value);
    _prefsService.setBool('show_order_button', showOrderButton.value);
  }
}
