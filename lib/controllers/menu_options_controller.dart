import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/models/menu_option.dart';
import 'package:gpr_coffee_shop/services/shared_preferences_service.dart';
import 'package:gpr_coffee_shop/screens/customer/menu_screen.dart';
import 'package:gpr_coffee_shop/screens/customer/rate_screen.dart';
import 'package:gpr_coffee_shop/screens/admin/admin_dashboard.dart';
import 'package:gpr_coffee_shop/screens/location_screen.dart';
import 'package:gpr_coffee_shop/screens/view_options_screen.dart';
import 'package:gpr_coffee_shop/screens/settings_screen.dart';
import 'package:gpr_coffee_shop/screens/about_screen.dart';
import 'package:gpr_coffee_shop/screens/admin/order_management_screen.dart';
import 'package:gpr_coffee_shop/utils/logger_util.dart';

class MenuOptionsController extends GetxController {
  final _prefsService = Get.find<SharedPreferencesService>();
  static const String _storageKey = 'menu_options';

  // خيارات القائمة الظاهرة والمخفية
  final RxList<MenuOption> visibleOptions = <MenuOption>[].obs;
  final RxList<MenuOption> hiddenOptions = <MenuOption>[].obs;

  // حالة وضع التحرير
  final RxBool isEditMode = false.obs;

  // الخيارات الافتراضية
  final List<MenuOption> _defaultOptions = [
    const MenuOption(
      id: 'menu',
      title: 'menu',
      icon: Icons.coffee,
      route: '/menu',
      color: Color.fromARGB(255, 0, 0, 0),
      sortOrder: 0,
    ),
    const MenuOption(
      id: 'rate',
      title: 'rate',
      icon: Icons.star_rate,
      route: '/rate',
      color: Color.fromARGB(255, 0, 0, 0),
      sortOrder: 1,
    ),
    const MenuOption(
      id: 'admin',
      title: 'admin_panel',
      icon: Icons.admin_panel_settings,
      route: '/admin',
      color: Color.fromARGB(255, 0, 0, 0),
      sortOrder: 2,
    ),
    const MenuOption(
      id: 'orders',
      title: 'order_management',
      icon: Icons.chevron_right,
      route: '/order-management',
      color:  Color.fromARGB(255, 0, 0, 0),
      sortOrder: 3,
    ),
    const MenuOption(
      id: 'location',
      title: 'location',
      icon: Icons.location_on,
      route: '/location',
      color:  Color.fromARGB(255, 0, 0, 0),
      sortOrder: 4,
    ),
    const MenuOption(
      id: 'view-options',
      title: 'display_options',
      icon: Icons.view_list,
      route: '/view-options',
      color:  Color.fromARGB(255, 0, 0, 0),
      sortOrder: 5,
    ),
    const MenuOption(
      id: 'settings',
      title: 'settings',
      icon: Icons.settings,
      route: '/settings',
      color: const Color.fromARGB(255, 0, 0, 0),
      sortOrder: 6,
    ),
    const MenuOption(
      id: 'about',
      title: 'about_app_title',
      icon: Icons.info_outline,
      route: '/about',
      color:  Color.fromARGB(255, 0, 0, 0),
      sortOrder: 7,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _loadOptions();
  }

  // تحميل خيارات القائمة من التخزين المحلي
  void _loadOptions() {
    try {
      final String? storedOptions = _prefsService.getString(_storageKey);

      if (storedOptions != null && storedOptions.isNotEmpty) {
        try {
          final List<dynamic> decodedList = jsonDecode(storedOptions);
          final List<MenuOption> allOptions =
              decodedList.map((item) => MenuOption.fromMap(item)).toList();

          // فرز الخيارات حسب الترتيب
          allOptions.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

          // فصل الخيارات الظاهرة عن المخفية
          visibleOptions.value =
              allOptions.where((option) => option.isVisible).toList();
          hiddenOptions.value =
              allOptions.where((option) => !option.isVisible).toList();
        } catch (jsonError) {
          LoggerUtil.logger.e('خطأ في تفسير بيانات خيارات القائمة: $jsonError');
          _resetToDefaults();
        }
      } else {
        // إذا لم توجد خيارات مخزنة، استخدم الخيارات الافتراضية
        LoggerUtil.logger.i(
            'لم يتم العثور على خيارات مخزنة، سيتم استخدام الخيارات الافتراضية');
        _resetToDefaults();
      }
    } catch (e) {
      LoggerUtil.logger.e('خطأ في تحميل خيارات القائمة: $e');
      _resetToDefaults();
    }
  }

  // حفظ خيارات القائمة في التخزين المحلي
  void _saveOptions() {
    try {
      final List<MenuOption> allOptions = [...visibleOptions, ...hiddenOptions];
      final List<Map<String, dynamic>> encodedList =
          allOptions.map((option) => option.toMap()).toList();
      final String encodedOptions = jsonEncode(encodedList);

      _prefsService.setString(_storageKey, encodedOptions);
      update(); // تحديث الواجهة
    } catch (e) {
      LoggerUtil.logger.e('خطأ في حفظ خيارات القائمة: $e');
    }
  }

  // إعادة تعيين الخيارات إلى الوضع الافتراضي
  void _resetToDefaults() {
    visibleOptions.value = List.from(_defaultOptions);
    hiddenOptions.clear();
    _saveOptions();
  }

  // تبديل وضع التحرير
  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
    update();
  }

  // إعادة ترتيب الخيارات الظاهرة
  void reorderVisibleOptions(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final MenuOption item = visibleOptions.removeAt(oldIndex);
    visibleOptions.insert(newIndex, item);

    // تحديث ترتيب العناصر
    for (int i = 0; i < visibleOptions.length; i++) {
      visibleOptions[i] = visibleOptions[i].copyWith(sortOrder: i);
    }

    _saveOptions();
  }

  // إخفاء خيار (نقله إلى القائمة المخفية)
  void hideOption(String id) {
    final int index = visibleOptions.indexWhere((option) => option.id == id);
    if (index != -1) {
      final MenuOption option = visibleOptions.removeAt(index);
      final MenuOption updatedOption = option.copyWith(isVisible: false);
      hiddenOptions.add(updatedOption);

      // تحديث ترتيب العناصر
      for (int i = 0; i < visibleOptions.length; i++) {
        visibleOptions[i] = visibleOptions[i].copyWith(sortOrder: i);
      }

      _saveOptions();

      // عرض رسالة تأكيد
      Get.snackbar(
        'تم إخفاء الخيار',
        'يمكنك استعادته من القائمة المخفية',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.withAlpha(200),
        colorText: Colors.black,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // إظهار خيار (إعادته إلى القائمة الظاهرة)
  void showOption(String id) {
    final int index = hiddenOptions.indexWhere((option) => option.id == id);
    if (index != -1) {
      final MenuOption option = hiddenOptions.removeAt(index);
      final MenuOption updatedOption = option.copyWith(
        isVisible: true,
        sortOrder: visibleOptions.length, // وضعه في آخر القائمة
      );
      visibleOptions.add(updatedOption);
      _saveOptions();

      // عرض رسالة تأكيد
      Get.snackbar(
        'تمت استعادة الخيار',
        '${updatedOption.title.tr} تمت إضافته إلى القائمة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withAlpha(200),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // الحصول على شاشة مناسبة بناءً على مسار الخيار
  Widget getScreenForRoute(String route) {
    switch (route) {
      case '/menu':
        return MenuScreen();
      case '/rate':
        return const RateScreen();
      case '/admin':
        return const AdminDashboard();
      case '/order-management':
        return const OrderManagementScreen();
      case '/location':
        return const LocationScreen();
      case '/view-options':
        return ViewOptionsScreen();
      case '/settings':
        return const SettingsScreen();
      case '/about':
        return const AboutScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  // إعادة ضبط جميع الخيارات للوضع الافتراضي
  void resetAllOptions() {
    _resetToDefaults();

    // عرض رسالة تأكيد
    Get.snackbar(
      'تم إعادة الضبط',
      'تمت استعادة خيارات القائمة الافتراضية',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withAlpha(200),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  // أضف هذه الدوال إلى فئة MenuOptionsController

  // إعادة ترتيب الخيارات الأساسية
  void reorderPrimaryOptions(
      int oldIndex, int newIndex, List<MenuOption> primaryOptions) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final option = primaryOptions[oldIndex];
    List<MenuOption> updatedOptions = List.from(visibleOptions);

    // حساب المواقع الفعلية في القائمة الكاملة
    int actualOldIndex = visibleOptions.indexOf(option);

    // إزالة الخيار من موقعه القديم
    updatedOptions.removeAt(actualOldIndex);

    // إضافة الخيار في موقعه الجديد
    updatedOptions.insert(newIndex, option);

    // تحديث القائمة
    updateVisibleOptions(updatedOptions);
  }

  // إعادة ترتيب الخيارات الثانوية
  void reorderSecondaryOptions(int oldIndex, int newIndex,
      List<MenuOption> secondaryOptions, List<MenuOption> primaryOptions) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final option = secondaryOptions[oldIndex];
    List<MenuOption> updatedOptions = List.from(visibleOptions);

    // حساب المواقع الفعلية في القائمة الكاملة
    int actualOldIndex = visibleOptions.indexOf(option);
    int actualNewIndex = primaryOptions.length + newIndex;
    if (actualNewIndex > updatedOptions.length) {
      actualNewIndex = updatedOptions.length;
    }

    // إزالة الخيار من موقعه القديم
    updatedOptions.removeAt(actualOldIndex);

    // إضافة الخيار في موقعه الجديد
    updatedOptions.insert(actualNewIndex, option);

    // تحديث القائمة
    updateVisibleOptions(updatedOptions);
  }

  // دالة مساعدة لتحديث الخيارات المرئية
  void updateVisibleOptions(List<MenuOption> updatedOptions) {
    visibleOptions.value = updatedOptions;
    _saveOptions();
    update();
  }

  // إضافة هذه الدالة للتحقق من الصفحة النشطة حاليًا
  bool isRouteActive(String route) {
    return currentRoute.value == route;
  }

  // إضافة متغير للتحكم في الصفحة الحالية
  final RxString currentRoute = ''.obs;

  // تعديل دالة الانتقال للاحتفاظ بحالة القائمة
  void navigateToOption(String route) {
    final screen = getScreenForRoute(route);

    // استخدام to لكن مع حفظ المسار وتخزين حالة القائمة
    currentRoute.value = route;

    // استخدام هذا الأسلوب البديل للانتقال
    Navigator.of(Get.context!)
        .push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
        maintainState: true, // هذا هو المهم - الاحتفاظ بالحالة
      ),
    )
        .then((_) {
      // عند العودة، تأكد من تحديث القائمة
      // القيمة الحالية لـ activeTabIndex ستبقى كما هي
      update(['home_options_list']);
    });
  }

  // إضافة متغير لتتبع علامة التبويب النشطة
  final RxInt activeTabIndex = 0.obs;
}
