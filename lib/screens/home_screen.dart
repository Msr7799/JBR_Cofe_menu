import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'package:gpr_coffee_shop/controllers/view_options_controller.dart';
import 'package:gpr_coffee_shop/screens/admin/order_management_screen.dart';
import 'package:gpr_coffee_shop/screens/location_screen.dart';
import 'package:gpr_coffee_shop/services/app_translation_service.dart';
import 'package:gpr_coffee_shop/utils/logger_util.dart';
import 'package:intl/intl.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart'; // أضف هذا السطر
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/auth_controller.dart';
import 'package:gpr_coffee_shop/controllers/feedback_controller.dart';
import 'package:gpr_coffee_shop/controllers/settings_controller.dart';
import 'package:gpr_coffee_shop/models/app_settings.dart';
import 'package:gpr_coffee_shop/screens/admin/admin_dashboard.dart';
import 'package:gpr_coffee_shop/screens/admin/login_screen.dart';
import 'package:gpr_coffee_shop/screens/customer/menu_screen.dart';
import 'package:gpr_coffee_shop/screens/customer/rate_screen.dart';
import 'package:gpr_coffee_shop/screens/settings_screen.dart';
import 'package:gpr_coffee_shop/services/shared_preferences_service.dart';
import 'package:gpr_coffee_shop/screens/view_options_screen.dart';
import 'package:gpr_coffee_shop/screens/about_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/image_helper.dart';
import 'package:gpr_coffee_shop/controllers/order_controller.dart';
import 'package:gpr_coffee_shop/models/order.dart';
import 'package:gpr_coffee_shop/controllers/menu_options_controller.dart';
import 'package:gpr_coffee_shop/models/menu_option.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // تعريف مفاتيح فريدة لكل مكون
  final GlobalKey _backgroundKey =
      GlobalKey(debugLabel: 'background_container');
  final GlobalKey _contentKey = GlobalKey(debugLabel: 'content_container');

  final AuthController authController = Get.find<AuthController>();
  final SettingsController settingsController = Get.find<SettingsController>();
  final OrderController orderController =
      Get.find<OrderController>(); // Add this line
  late final FeedbackController feedbackController =
      Get.find<FeedbackController>();
  late final MenuOptionsController menuOptionsController;
  late AnimationController _animationController;
  bool _reducedMotion = false;

  // View options variables
  String _viewMode = 'grid'; // Default value: grid view
  bool _showImages = true; // Default value: show images

  // Home layout view mode (grid or list)
  String _homeViewMode = 'grid'; // Options: 'grid' or 'list'

  // Add service reference for preferences
  final _prefsService = Get.find<SharedPreferencesService>();

  // Time and date update timer
  late Timer _dateTimeTimer;
  DateTime _currentDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    menuOptionsController = Get.put(MenuOptionsController());
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    if (!_reducedMotion) {
      _animationController.repeat();
    }

    _checkPerformance();
    _loadViewPreferences();

    // Start timer to update date and time each second
    _dateTimeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentDateTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _dateTimeTimer.cancel(); // Cancel timer when disposing
    super.dispose();
  }

  void _checkPerformance() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          if (Platform.isWindows) {
            _reducedMotion = true;
            _animationController.stop();
          }
        });
      }
    });
  }

  void _loadViewPreferences() {
    setState(() {
      _viewMode = _prefsService.getString('view_mode');
      _showImages = _prefsService.getBool('show_images');
      _homeViewMode = _prefsService.getString('home_view_mode');
    });
  }

  // Toggle home screen view mode between grid and list
  void _toggleHomeViewMode() {
    setState(() {
      _homeViewMode = _homeViewMode == 'grid' ? 'list' : 'grid';
      _prefsService.setString('home_view_mode', _homeViewMode);
    });

    // Show confirmation
    Get.snackbar(
      'تم تغيير العرض',
      _homeViewMode == 'grid'
          ? 'تم التغيير إلى العرض الشبكي'
          : 'تم التغيير إلى عرض القائمة',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: AppTheme.primaryColor.withAlpha(200),
      colorText: Colors.white,
    );
  }

  void _showViewOptionsDialog(BuildContext context) {
    final RxString viewMode = _viewMode.obs;
    final RxBool showImages = _showImages.obs;

    Get.dialog(
      AlertDialog(
        title: const Text('خيارات العرض'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'طريقة عرض المنتجات:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(() => RadioListTile<String>(
                  title: const Text('عرض شبكي'),
                  value: 'grid',
                  groupValue: viewMode.value,
                  onChanged: (value) => viewMode.value = value!,
                )),
            Obx(() => RadioListTile<String>(
                  title: const Text('عرض قائمة'),
                  value: 'list',
                  groupValue: viewMode.value,
                  onChanged: (value) => viewMode.value = value!,
                )),
            Obx(() => RadioListTile<String>(
                  title: const Text('عرض مدمج'),
                  value: 'compact',
                  groupValue: viewMode.value,
                  onChanged: (value) => viewMode.value = value!,
                )),
            const Divider(),
            Obx(() => SwitchListTile(
                  title: const Text('عرض الصور'),
                  value: showImages.value,
                  onChanged: (value) => showImages.value = value,
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              // Save the settings locally
              setState(() {
                _viewMode = viewMode.value;
                _showImages = showImages.value;
              });

              // Persist the settings
              _prefsService.setString('view_mode', _viewMode);
              _prefsService.setBool('show_images', _showImages);

              // Close the dialog
              Get.back();

              // Show confirmation message
              Get.snackbar(
                'تم الحفظ',
                'تم حفظ إعدادات العرض بنجاح',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green.withAlpha(180),
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // استخدام GetBuilder بدلاً من Obx لتجنب التحديثات المتعددة
    return GetBuilder<SettingsController>(
      builder: (controller) {
        // استخراج إعدادات الخلفية من المتحكم
        final backgroundType = controller.backgroundType;
        final backgroundImagePath = controller.backgroundImagePath;
        final backgroundColor = controller.backgroundColor;
        final textColor = controller.textColor;

        // إضافة متغيرات لتحسين التجاوب مع مختلف أحجام الشاشات
        final Size screenSize = MediaQuery.of(context).size;
        final bool isSmallScreen = screenSize.width < 360;
        final bool isVerySmallScreen = screenSize.width < 320;
        final bool isTablet = screenSize.width >= 600 && screenSize.width < 900;
        final bool isDesktop = screenSize.width >= 900;

        return Scaffold(
          // تطبيق الخلفية بناءً على النوع المختار
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            // زيادة ارتفاع الـ toolbar للحصول على مساحة أكبر
            toolbarHeight: isSmallScreen ? 60 : 70,
            // إضافة مساحة بين الشعار والساعة في الأعلى
            leading: Padding(
              padding: EdgeInsets.only(
                  left: 4.0,
                  bottom: 8.0,
                  top: isSmallScreen ? 10.0 : 15.0,
                  right: 4.0),
              child: _buildDateTimeWidget(context),
            ),
            leadingWidth: isSmallScreen
                ? 120
                : isVerySmallScreen
                    ? 100
                    : 160,
            title: Padding(
              padding: EdgeInsets.only(top: isSmallScreen ? 10.0 : 15.0),
              child: Text(
                'JBR Coffee Shop',
                style: TextStyle(
                  color: AppTheme.textLightColor,
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 16 : 18,
                ),
              ),
            ),
            centerTitle: true,
            actions: [
              // زر تخصيص القائمة - أضف هذه الأكواد هنا
              Padding(
                padding: EdgeInsets.only(top: isSmallScreen ? 10.0 : 15.0),
                child: GetBuilder<MenuOptionsController>(builder: (controller) {
                  return IconButton(
                    icon: Icon(
                      controller.isEditMode.value ? Icons.check : Icons.edit,
                      color: controller.isEditMode.value
                          ? Colors.green
                          : Colors.white,
                      size: isSmallScreen ? 20 : 24,
                    ),
                    tooltip: controller.isEditMode.value
                        ? 'انتهاء من التخصيص'
                        : 'تخصيص القائمة',
                    onPressed: () {
                      controller.toggleEditMode();
                    },
                  );
                }),
              ),

              // زر إعادة الأوضاع الافتراضية - يظهر فقط في وضع التحرير
              Padding(
                padding: EdgeInsets.only(top: isSmallScreen ? 10.0 : 15.0),
                child: GetBuilder<MenuOptionsController>(builder: (controller) {
                  return controller.isEditMode.value
                      ? IconButton(
                          icon: const Icon(
                            Icons.restore,
                            color: Colors.amber,
                          ),
                          tooltip: 'استعادة الخيارات الافتراضية',
                          onPressed: () {
                            Get.dialog(
                              AlertDialog(
                                title:
                                    const Text('استعادة الخيارات الافتراضية'),
                                content: const Text(
                                    'هل أنت متأكد من إعادة ضبط جميع خيارات القائمة إلى الوضع الافتراضي؟'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('إلغاء'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                      controller.resetAllOptions();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.amber),
                                    child: const Text('استعادة'),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : const SizedBox.shrink();
                }),
              ),

              // باقي الأزرار الموجودة
              // زر الجرس للطلبات (يظهر فقط للمسؤولين)
              if (authController.isAdmin.value)
                Obx(() {
                  final pendingOrdersCount =
                      orderController.getProcessingOrders().length;
                  return Padding(
                    padding: EdgeInsets.only(top: isSmallScreen ? 10.0 : 15.0),
                    child: Stack(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.notifications,
                            color: Colors.white,
                            size: isSmallScreen ? 22 : 24,
                          ),
                          tooltip: 'الطلبات الجديدة',
                          onPressed: () {
                            _showOrdersPopup(context);
                          },
                        ),
                        if (pendingOrdersCount > 0)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                '$pendingOrdersCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              // Language Switch Toggle - تصميم محدث
              Padding(
                padding: EdgeInsets.only(top: isSmallScreen ? 10.0 : 15.0),
                child: _buildLanguageSwitcher(),
              ),
              Padding(
                padding: EdgeInsets.only(top: isSmallScreen ? 10.0 : 15.0),
                child: IconButton(
                  icon: Icon(
                    _homeViewMode == 'grid' ? Icons.view_list : Icons.grid_view,
                    size: isSmallScreen ? 20 : 24,
                  ),
                  tooltip: _homeViewMode == 'grid' ? 'عرض كقائمة' : 'عرض كشبكة',
                  onPressed: _toggleHomeViewMode,
                ),
              ),
              // زر إدارة الطلبات (يظهر فقط للمسؤولين)
              if (authController.isAdmin.value)
                Padding(
                  padding: EdgeInsets.only(
                    top: isSmallScreen ? 10.0 : 15.0,
                    right: 8.0,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.receipt_long),
                    tooltip: 'إدارة الطلبات',
                    onPressed: () =>
                        Get.to(() => const OrderManagementScreen()),
                  ),
                ),
            ],
          ),
          // تطبيق الخلفية مباشرة على الـ Scaffold
          backgroundColor:
              backgroundType == BackgroundType.color ? backgroundColor : null,
          body: Container(
            key: _backgroundKey, // استخدام مفتاح فريد
            // تطبيق الخلفية بناءً على النوع المختار
            decoration: _buildBackgroundDecoration(
              backgroundType,
              backgroundColor,
              backgroundImagePath,
            ),
            child: SafeArea(
              child: Container(
                key: _contentKey, // استخدام مفتاح فريد
                child: OrientationBuilder(
                  builder: (context, orientation) {
                    return Stack(
                      children: [
                        // إزالة الخلفية الإفتراضية المتحركة إذا كان المستخدم قد اختار خلفية مخصصة
                        if (backgroundType == BackgroundType.default_bg)
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: const [
                                      Color(0xFF7D6E83),
                                      Color(0xFFD0B8A8),
                                      Color(0xFFF8EDE3),
                                    ],
                                    stops: [
                                      _animationController.value * 0.3,
                                      _animationController.value * 0.7,
                                      _animationController.value,
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                        // إضافة تأثير خفيف للخلفية إذا كان المستخدم قد اختار خلفية مخصصة
                        if (backgroundType == BackgroundType.default_bg)
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Container(
                              color: Colors.white.withAlpha(25),
                            ),
                          ),
                        orientation == Orientation.portrait
                            ? _buildPortraitLayout(context)
                            : _buildLandscapeLayout(context),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  BoxDecoration _buildBackgroundDecoration(
    BackgroundType type,
    Color backgroundColor,
    String? imagePath,
  ) {
    switch (type) {
      case BackgroundType.color:
        return BoxDecoration(color: backgroundColor);

      case BackgroundType.image:
        if (imagePath != null && File(imagePath).existsSync()) {
          return BoxDecoration(
            image: DecorationImage(
              image: FileImage(File(imagePath)),
              fit: BoxFit.cover,
            ),
          );
        }
        // إذا كانت الصورة غير متوفرة، ارجع للخلفية الافتراضية
        return const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8F8F8), Color(0xFFF0F0F0)],
          ),
        );

      case BackgroundType.default_bg:
        return const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8F8F8), Color(0xFFF0F0F0)],
          ),
        );
    }
  }

  Widget _buildPortraitLayout(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = MediaQuery.of(context).padding;
    final textColor = settingsController.textColor;

    // تحديد حجم الشاشة لتطبيق التنسيقات المناسبة
    final bool isSmallScreen = screenWidth < 360;
    final bool isVerySmallScreen = screenWidth < 320;
    final bool isLargeScreen = screenWidth >= 600;

    // تعديل أحجام العناصر بناءً على حجم الشاشة
    final double logoSize = isVerySmallScreen
        ? screenWidth * 0.28
        : isSmallScreen
            ? screenWidth * 0.30
            : screenWidth * 0.35;

    final double titleFontSize = isVerySmallScreen
        ? screenWidth * 0.052
        : isSmallScreen
            ? screenWidth * 0.055
            : screenWidth * 0.06;

    final double descriptionFontSize = isVerySmallScreen
        ? screenWidth * 0.032
        : isSmallScreen
            ? screenWidth * 0.035
            : screenWidth * 0.04;

    // زيادة المسافة بين اللوغو والعنوان والوصف وبين أزرار التنقل
    final double spacingAfterLogo = isVerySmallScreen
        ? screenHeight * 0.03
        : isSmallScreen
            ? screenHeight * 0.035
            : screenHeight * 0.04;

    return SafeArea(
      // استخدام ClipRRect لمنع تجاوز العناصر حدود الشاشة
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: AnimationLimiter(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight - padding.vertical,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // تحسين المسافات تحت اللوغو بشكل متناسب مع حجم الشاشة
                  !_reducedMotion
                      ? SizedBox(
                          height: isSmallScreen
                              ? screenHeight * 0.20
                              : screenHeight * 0.22,
                          child: AnimationConfiguration.synchronized(
                            duration: const Duration(milliseconds: 800),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildLogoSection(
                                        logoSize,
                                        isSmallScreen,
                                        TextStyle(
                                            fontSize: titleFontSize,
                                            fontWeight: FontWeight.bold,
                                            color: textColor),
                                        TextStyle(
                                            fontSize: descriptionFontSize,
                                            color: textColor),
                                        textColor),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          // استخدام ارتفاع متناسب بشكل أفضل
                          height: isSmallScreen
                              ? screenHeight * 0.18
                              : screenHeight * 0.20,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildLogoSection(
                                  logoSize,
                                  isSmallScreen,
                                  TextStyle(
                                      fontSize: titleFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: textColor),
                                  TextStyle(
                                      fontSize: descriptionFontSize,
                                      color: textColor),
                                  textColor),
                            ],
                          ),
                        ),

                  // إضافة مسافة إضافية بعد قسم اللوغو والعنوان
                  SizedBox(height: spacingAfterLogo),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: isSmallScreen
                          ? screenHeight * 0.01
                          : screenHeight * 0.015,
                    ),
                    child: AnimationLimiter(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 600),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            horizontalOffset: 50.0,
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: [
                            _buildReorderableOptionsList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildBenefitPayQrSection(context, isPortrait: true),
                  _buildFeaturedFeedbacks(context,
                      isPortrait: true), // تأكد من إضافة هذا
                  // أزرار طلبات وجاهز بتصميم ثلاثي الأبعاد
                  Align(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: screenWidth * 0.08,
                          bottom: screenHeight * 0.01),
                      child: _buildDeliveryButtons(context),
                    ),
                  ),

                  // خط فاصل وحقوق النشر
                  AnimationConfiguration.synchronized(
                    duration: const Duration(milliseconds: 1000),
                    child: FadeInAnimation(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Divider(
                            color: Colors.brown.withAlpha(128),
                            thickness: 1,
                            indent: screenWidth * 0.1,
                            endIndent: screenWidth * 0.1,
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            'copyright'.tr,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 10 : 12,
                              fontWeight: FontWeight.w400,
                              color: textColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final textColor = settingsController.textColor;

    // تحديد حجم الشاشة لتحسين التجاوب
    final bool isSmallScreen = screenWidth < 600;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    final bool isDesktop = screenWidth >= 1024;

    // تعديل نسب العرض بناءً على حجم الشاشة
    final int leftColumnFlex = isSmallScreen ? 1 : 2;
    final int rightColumnFlex = isSmallScreen ? 2 : 3;

    return SafeArea(
      child: Row(
        children: [
          // العمود الأيسر - الشعار والمعلومات (لم يتغير)
          Expanded(
            flex: leftColumnFlex,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // لم يتغير هذا الجزء - الشعار والمعلومات
                  // ...
                  AnimationConfiguration.synchronized(
                    duration: const Duration(milliseconds: 1200),
                    child: SlideAnimation(
                      horizontalOffset: -50.0,
                      child: FadeInAnimation(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // شعار التطبيق
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.02),
                              child: Neumorphic(
                                style: NeumorphicStyle(
                                  depth: 8,
                                  intensity: 0.8,
                                  shape: NeumorphicShape.concave,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(screenHeight * 0.04),
                                  ),
                                  lightSource: LightSource.topLeft,
                                  color: Colors.white.withAlpha(217),
                                ),
                                child: Container(
                                  width: isSmallScreen
                                      ? screenHeight * 0.18
                                      : screenHeight * 0.25,
                                  height: isSmallScreen
                                      ? screenHeight * 0.18
                                      : screenHeight * 0.25,
                                  padding: EdgeInsets.all(screenHeight * 0.02),
                                  child: GestureDetector(
                                    onTap: () => _showLogoSelectionDialog(),
                                    child: ImageHelper.buildImage(
                                      settingsController.logoPath ??
                                          'assets/images/logo.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // ... باقي الكود لم يتغير
                          ],
                        ),
                      ),
                    ),
                  ),
                  // ... باقي الكود لم يتغير
                  // إضافة قسم BenefitPay QR هنا
                  _buildBenefitPayQrSection(context, isPortrait: false),

                  // إضافة قسم آراء العملاء هنا
                  _buildFeaturedFeedbacks(context, isPortrait: false),
                ],
              ),
            ),
          ),
          // خط فاصل
          Container(
            height: screenHeight * 0.7,
            width: 1,
            color: Colors.brown.withAlpha(76),
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
          ),

          // العمود الأيمن - أزرار التطبيق في وضع Landscape
          Expanded(
            flex: rightColumnFlex,
            child: Padding(
              // إضافة padding أكبر في الجزء العلوي
              padding: EdgeInsets.fromLTRB(
                screenHeight * 0.02, // left
                screenHeight * 0.04, // top - زيادة الهامش العلوي
                screenHeight * 0.02, // right
                screenHeight * 0.02, // bottom
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // عرض الخيارات بشكل GridView مع GetBuilder للاستجابة لتغييرات خيارات العرض
                  Expanded(
                    child: GetBuilder<MenuOptionsController>(
                      id: 'landscape_options', // استخدام معرف جديد
                      builder: (controller) {
                        return Obx(() {
                          if (controller.isEditMode.value) {
                            // وضع التحرير...
                            return GridView.count(
                              crossAxisCount: isSmallScreen ? 2 : 3,
                              childAspectRatio: isSmallScreen ? 2.8 : 3.2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              children: controller.visibleOptions.asMap().entries.map((entry) {
                                final index = entry.key;
                                final option = entry.value;
                                return _buildLandscapeOptionWithDismissible(
                                  option: option,
                                  controller: controller,
                                  isSmallScreen: isSmallScreen,
                                  key: Key('editable_landscape_option_${option.id}'),
                                );
                              }).toList(),
                            );
                          } else {
                            // وضع العرض العادي...
                            return GridView.count(
                              crossAxisCount: isSmallScreen ? 2 : 3,
                              childAspectRatio: isSmallScreen ? 2.8 : 3.2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              children: controller.visibleOptions.map((option) {
                                return _buildLandscapeButton(
                                  title: option.title.tr,
                                  icon: option.icon,
                                  color: option.color,
                                  onTap: () =>
                                      controller.navigateToOption(option.route),
                                );
                              }).toList(),
                            );
                          }
                        });
                      },
                    ),
                  ),

                  // عرض قائمة الخيارات المخفية (تظهر فقط في وضع التحرير)
                  GetBuilder<MenuOptionsController>(builder: (controller) {
                    return Obx(() {
                      if (controller.isEditMode.value &&
                          controller.hiddenOptions.isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(thickness: 1),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'الخيارات المخفية',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(
                              height:
                                  80, // تحديد ارتفاع ثابت لقسم الخيارات المخفية
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.hiddenOptions.length,
                                itemBuilder: (context, index) {
                                  final option =
                                      controller.hiddenOptions[index];
                                  return Card(
                                    key: Key(
                                        'hidden_landscape_option_${option.id}'),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: InkWell(
                                      onTap: () =>
                                          controller.showOption(option.id),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: option.color,
                                              radius: 16,
                                              child: Icon(option.icon,
                                                  color: Colors.white,
                                                  size: 16),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(option.title.tr,
                                                style: const TextStyle(
                                                    fontSize: 10)),
                                            const Icon(Icons.add_circle,
                                                color: Colors.green, size: 14)
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    });
                  }),

                  // أزرار طلبات وجاهز في الزاوية السفلية (لم يتغير)
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.02,
                        bottom: screenHeight * 0.01,
                      ),
                      child: _buildDeliveryButtons(context),
                    ),
                  ),

                  // حقوق النشر في الأسفل (لم يتغير)
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                    child: AnimationConfiguration.synchronized(
                      duration: const Duration(milliseconds: 1000),
                      child: FadeInAnimation(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Divider(
                              color: Colors.brown.withAlpha(128),
                              thickness: 1,
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              'copyright'.tr,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 9 : 10,
                                fontWeight: FontWeight.w400,
                                color: textColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitPayQrSection(BuildContext context,
      {required bool isPortrait}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GetBuilder<SettingsController>(
      builder: (controller) {
        final qrCodeUrl = controller.benefitPayQrCodeUrl;

        if (qrCodeUrl == null || qrCodeUrl.isEmpty) {
          return const SizedBox.shrink();
        }

        // تقليل هوامش المربع لجعله أصغر
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isPortrait ? screenWidth * 0.08 : screenHeight * 0.05,
            vertical: isPortrait ? screenHeight * 0.015 : screenHeight * 0.02,
          ),
          child: AnimationConfiguration.synchronized(
            duration: const Duration(milliseconds: 800),
            child: SlideAnimation(
              verticalOffset: 30.0,
              child: FadeInAnimation(
                child: Neumorphic(
                  style: NeumorphicStyle(
                    depth: 8,
                    intensity: 0.7,
                    shape: NeumorphicShape.flat,
                    boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.circular(16),
                    ),
                    color: Colors.white.withAlpha(230),
                    lightSource: LightSource.topLeft,
                    shadowDarkColor: Colors.black45,
                    shadowLightColor: Colors.transparent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0), // تقليل الحشو الداخلي
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.qr_code_2,
                              color: Colors.purple,
                              size: 20, // تصغير حجم الأيقونة
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'pay_with_benefitpay'.tr,
                                style: TextStyle(
                                  fontSize:
                                      isPortrait ? 14 : 12, // تصغير حجم الخط
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple.shade800,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10), // تقليل المسافة
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            // تقليل الحد الأقصى للعرض والارتفاع بنسبة كبيرة
                            maxWidth: isPortrait
                                ? screenWidth * 0.5 // تصغير من 0.7 إلى 0.5
                                : screenHeight * 0.3, // تصغير من 0.4 إلى 0.3
                            maxHeight: isPortrait
                                ? screenWidth * 0.5 // تصغير من 0.7 إلى 0.5
                                : screenHeight * 0.3, // تصغير من 0.4 إلى 0.3
                          ),
                          child: Image.file(
                            File(qrCodeUrl),
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 36, // تصغير حجم أيقونة الخطأ
                                      color: Colors.red.shade300,
                                    ),
                                    const SizedBox(height: 6), // تقليل المسافة
                                    Text(
                                      'error_loading_qr'.tr,
                                      style: const TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 12, // تصغير حجم الخط
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8), // تقليل المسافة
                        Text(
                          'scan_qr_to_pay'.tr,
                          style: TextStyle(
                            fontSize: isPortrait ? 12 : 10, // تصغير حجم الخط
                            color: Colors.grey.shade800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeaturedFeedbacks(BuildContext context,
      {required bool isPortrait}) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GetBuilder<FeedbackController>(
      builder: (controller) {
        final featuredFeedbacks = controller.featuredFeedbacks;

        if (featuredFeedbacks.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isPortrait ? screenWidth * 0.05 : screenHeight * 0.05,
            vertical: isPortrait ? screenHeight * 0.02 : screenHeight * 0.03,
          ),
          child: AnimationConfiguration.synchronized(
            duration: const Duration(milliseconds: 800),
            child: SlideAnimation(
              verticalOffset: 30.0,
              child: FadeInAnimation(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(230),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.format_quote,
                              color: AppTheme.primaryColor,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'customer_feedback'.tr,
                              style: TextStyle(
                                fontSize: isPortrait ? 18 : 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...featuredFeedbacks.map((feedback) =>
                            _buildFeedbackItem(feedback, isPortrait)),
                        const SizedBox(height: 12),
                        Center(
                          child: TextButton.icon(
                            icon: const Icon(Icons.rate_review, size: 18),
                            label: Text('share_your_feedback'.tr),
                            onPressed: () => Get.to(() => const RateScreen()),
                            style: TextButton.styleFrom(
                              foregroundColor: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeedbackItem(FeedbackItem feedback, bool isPortrait) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.brown.shade50.withAlpha(153),
        borderRadius: BorderRadius.circular(12),
        // Eliminada la propiedad border que añadía un sutil efecto de sombra
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < feedback.rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  );
                }),
              ),
              const Spacer(),
              Text(
                _formatFeedbackDate(feedback.timestamp),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            feedback.message,
            style: TextStyle(
              fontSize: isPortrait ? 14 : 12,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatFeedbackDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;

    return '$year/$month/$day';
  }

  Widget _buildNavigationButton({
    required MenuOption option,
    required bool isEditing,
    VoidCallback? onDelete,
    required Key key, // جعل الـ key مطلوب
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;
    final isVerySmallScreen = screenWidth < 320;

    // تعديل ارتفاع الأزرار بناءً على حجم الشاشة
    final buttonHeight = isVerySmallScreen
        ? screenHeight * 0.06
        : isSmallScreen
            ? screenHeight * 0.065
            : screenHeight * 0.07;

    // اختيار حجم الأيقونة المناسب
    final iconSize =
        isVerySmallScreen ? buttonHeight * 0.38 : buttonHeight * 0.4;

    // اختيار حجم الخط المناسب
    final fontSize = isVerySmallScreen
        ? screenWidth * 0.036
        : isSmallScreen
            ? screenWidth * 0.037
            : screenWidth * 0.038;

    final isDarkBackground =
        settingsController.backgroundType == BackgroundType.color &&
            settingsController.backgroundColor.computeLuminance() < 0.5;

    final textColor = isDarkBackground ? Colors.white : Colors.brown.shade900;

    return Padding(
      key: key, // نضع الـ key هنا
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Dismissible(
        key: Key('dismiss_${option.id}'), // تأكيد على استخدام key فريد
        direction:
            isEditing ? DismissDirection.endToStart : DismissDirection.none,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          color: Colors.red,
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        confirmDismiss: isEditing
            ? (direction) async {
                return await Get.dialog<bool>(
                      AlertDialog(
                        title: const Text('إخفاء الخيار'),
                        content: Text(
                            'هل تريد إخفاء "${option.title.tr}" من القائمة؟'),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(result: false),
                            child: const Text('إلغاء'),
                          ),
                          ElevatedButton(
                            onPressed: () => Get.back(result: true),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            child: const Text('إخفاء'),
                          ),
                        ],
                      ),
                    ) ??
                    false;
              }
            : null,
        onDismissed: isEditing
            ? (direction) {
                if (onDelete != null) {
                  onDelete();
                }
              }
            : null,
        child: GestureDetector(
          onTap: isEditing
              ? null
              : () {
                  // استخدام الدالة الجديدة بدلاً من التنقل المباشر
                  menuOptionsController.navigateToOption(option.route);
                },
          child: Neumorphic(
            style: NeumorphicStyle(
              depth: isSmallScreen ? 6 : 8,
              intensity: 0.7,
              shape: NeumorphicShape.flat,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
              color: Colors.white.withAlpha(isDarkBackground ? 150 : 245),
              lightSource: LightSource.topLeft,
              shadowDarkColor: Colors.black45,
              shadowLightColor: Colors.transparent,
            ),
            child: Container(
              width: double.infinity,
              height: buttonHeight,
              padding:
                  EdgeInsets.symmetric(horizontal: isSmallScreen ? 10 : 12),
              child: Row(
                children: [
                  Neumorphic(
                    style: NeumorphicStyle(
                      depth: isSmallScreen ? 4 : 6,
                      intensity: 0.7,
                      shape: NeumorphicShape.convex,
                      boxShape: const NeumorphicBoxShape.circle(),
                      color: option.color,
                      lightSource: LightSource.topLeft,
                      shadowDarkColor: Colors.black45,
                      shadowLightColor: Colors.transparent,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                      child: Icon(
                        option.icon,
                        color: Colors.white,
                        size: iconSize,
                      ),
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 10 : 12),
                  Expanded(
                    child: Text(
                      option.title.tr,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isEditing)
                    const Icon(Icons.drag_handle, color: Colors.grey)
                  else
                    Icon(
                      Icons.arrow_forward_ios,
                      color: textColor.withOpacity(0.7),
                      size: isSmallScreen ? 12 : 14,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLandscapeButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isDarkBackground =
        settingsController.backgroundType == BackgroundType.color &&
            settingsController.backgroundColor.computeLuminance() < 0.5;

    // تعديل حجم الأيقونة والخط بناءً على حجم الشاشة
    final iconSize = isSmallScreen ? screenHeight * 0.03 : screenHeight * 0.035;
    final fontSize =
        isSmallScreen ? screenHeight * 0.018 : screenHeight * 0.023;
    final textColor = isDarkBackground ? Colors.white : Colors.brown.shade900;

    return GestureDetector(
      onTap: onTap,
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: isSmallScreen ? 4 : 6,
          intensity: 0.7,
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(
              BorderRadius.circular(isSmallScreen ? 9 : 12)),
          color: Colors.white.withAlpha(isDarkBackground ? 150 : 245),
          lightSource: LightSource.topLeft,
          shadowDarkColor: Colors.black45,
          shadowLightColor: Colors.transparent,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 8 : 12,
              vertical: isSmallScreen ? 6 : 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Neumorphic(
                style: NeumorphicStyle(
                  depth: isSmallScreen ? 3 : 4,
                  intensity: 0.7,
                  shape: NeumorphicShape.convex,
                  boxShape: const NeumorphicBoxShape.circle(),
                  color: color,
                  lightSource: LightSource.topLeft,
                  shadowDarkColor: Colors.black45,
                  shadowLightColor: Colors.transparent,
                ),
                child: Container(
                  padding: EdgeInsets.all(isSmallScreen ? 4 : 6),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: iconSize,
                  ),
                ),
              ),
              SizedBox(width: isSmallScreen ? 6 : 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required Gradient gradient,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 8,
          intensity: 0.8,
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
          color: const Color.fromARGB(212, 255, 255, 255).withAlpha(217),
          lightSource: LightSource.topLeft,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.15,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 36,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Color.fromARGB(222, 255, 255, 255),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة للحصول على لون خلفية متكيف مع خلفية الشاشة
  Color _getAdaptiveBackgroundColor() {
    final backgroundType = settingsController.backgroundType;
    final backgroundColor = settingsController.backgroundColor;

    // للخلفيات الملونة، نتحقق من سطوع اللون
    if (backgroundType == BackgroundType.color) {
      // إذا كانت الخلفية داكنة، نرجع خلفية فاتحة للكروت
      if (backgroundColor.computeLuminance() < 0.5) {
        return Colors.white.withAlpha(220);
      }
      // إذا كانت الخلفية فاتحة، نرجع خلفية أغمق قليلاً للكروت لتمييزها
      else {
        return Colors.white.withAlpha(245);
      }
    }
    // لخلفيات الصور، نفترض أنها قد تكون مختلطة الألوان، فنستخدم خلفية شبه شفافة
    else if (backgroundType == BackgroundType.image) {
      return Colors.white.withAlpha(230);
    }
    // للخلفية الافتراضية
    else {
      return Colors.white.withAlpha(217);
    }
  }

  // دالة للحصول على لون النص المتكيف مع الخلفية
  Color _getAdaptiveTextColor() {
    final backgroundType = settingsController.backgroundType;
    final backgroundColor = settingsController.backgroundColor;

    // للخلفيات الملونة
    if (backgroundType == BackgroundType.color) {
      // إذا كانت الخلفية داكنة، نستخدم نص فاتح
      if (backgroundColor.computeLuminance() < 0.5) {
        return Colors.white;
      }
      // إذا كانت الخلفية فاتحة، نستخدم نصاً داكناً
      else {
        return Colors.brown.shade900;
      }
    }
    // للخلفيات الأخرى، نستخدم لون النص المحدد في الإعدادات
    else {
      return settingsController.textColor;
    }
  }

  // دالة لعرض مربع حوار لاختيار اللوغو
  void _showLogoSelectionDialog() {
    // قائمة شعارات التطبيق المتوفرة
    final List<String> availableLogos = [
      'assets/images/logo.png',
      'assets/images/logo1.png',
      'assets/images/logo2.png',
      'assets/images/logo3.png',
      'assets/images/logo4.png',
      'assets/images/logo5.png',
      'assets/images/logo6.png',
      'assets/images/logo7.png',
      'assets/images/logo8.png',
    ];

    // الحصول على مسار الشعار الحالي
    final currentLogo = settingsController.logoPath ?? 'assets/images/logo.png';

    // استخدام showModalBottomSheet بدلاً من dialog لتجنب مشاكل العرض
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'تغيير شعار التطبيق',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'اختر شعارًا أو قم بتحميل صورة مخصصة:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 20),

                // شبكة الشعارات المتوفرة
                SizedBox(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...availableLogos.map((logo) => _buildLogoOption(logo)),
                      _buildCustomLogoOption(),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                Center(
                  child: TextButton.icon(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.check_circle,
                        color: AppTheme.primaryColor),
                    label: const Text('تم',
                        style: TextStyle(color: AppTheme.primaryColor)),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }

  // تعديل دالة _buildLogoOption
  Widget _buildLogoOption(String imagePath) {
    final isSelected = (settingsController.logoPath ?? 'assets/images/logo.png') == imagePath;
    
    // تحديد ما إذا كانت الشاشة صغيرة لعرض اللوغو بشكل دائري
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return GestureDetector(
      onTap: () {
        settingsController.setLogoPath(imagePath);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 80,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(isSmallScreen ? 40 : 10), // دائري للشاشات الصغيرة
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(isSmallScreen ? 30 : 8), // دائري للشاشات الصغيرة
              child: Image.asset(
                imagePath,
                height: 60,
                width: 60,
                fit: BoxFit.contain,
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppTheme.primaryColor, size: 16),
          ],
        ),
      ),
    );
  }

  // تحسين خيار الشعار المخصص
  Widget _buildCustomLogoOption() {
    return GestureDetector(
      onTap: () async {
        // إغلاق نافذة الاختيار أولاً
        Navigator.pop(context);

        try {
          // عرض مؤشر التحميل
          Get.dialog(
            const Center(child: CircularProgressIndicator()),
            barrierDismissible: false,
          );

          // استدعاء دالة اختيار وتطبيق اللوغو المخصص
          await settingsController.pickAndSetCustomLogo();

          // إغلاق مؤشر التحميل
          if (Get.isDialogOpen == true) Get.back();
        } catch (e) {
          // إغلاق مؤشر التحميل في حالة الخطأ
          if (Get.isDialogOpen == true) Get.back();

          LoggerUtil.logger.e('خطأ أثناء اختيار الشعار المخصص: $e');
          Get.snackbar(
            'خطأ',
            'حدث خطأ أثناء تحميل الصورة',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withAlpha(200),
            colorText: Colors.white,
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [Colors.grey.shade100, Colors.grey.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              size: 30,
              color: AppTheme.primaryColor,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 2,
                  offset: const Offset(1, 1),
                )
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              'تحميل صورة',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Widget to display date, time with seconds, day name, and Bahrain flag - Fully responsive
  Widget _buildDateTimeWidget(BuildContext context) {
    final textColor = settingsController.textColor;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isVerySmallScreen = screenWidth < 320;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // تعديل تنسيق الوقت بناءً على حجم الشاشة والاتجاه
    final dateFormat = DateFormat(isVerySmallScreen ? 'MM/dd' : 'yyyy/MM/dd');
    final timeFormat =
        DateFormat(isVerySmallScreen || isLandscape ? 'HH:mm' : 'HH:mm:ss');
    final dayName = _getArabicDayName(_currentDateTime.weekday);

    return Container(
      padding: EdgeInsets.symmetric(
          vertical: isVerySmallScreen ? 0 : 2,
          horizontal: isVerySmallScreen ? 2 : 3),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 0, 0).withAlpha(200),
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: AppTheme.primaryColor.withAlpha(120), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 0.5,
          ),
        ],
      ),
      // تحديد الحجم الأقصى للمنع من تجاوز المساحة المتاحة
      constraints: BoxConstraints(
        maxWidth: isVerySmallScreen
            ? 100
            : isSmallScreen
                ? 140
                : 160,
        maxHeight: isVerySmallScreen
            ? 32
            : isSmallScreen
                ? 36
                : 40,
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // الصف العلوي مع العلم واسم اليوم
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // علم البحرين
                Container(
                  height: isVerySmallScreen ? 12 : 14,
                  width: isVerySmallScreen ? 16 : 18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/bahrain_flag.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 3),
                Text(
                  dayName,
                  style: TextStyle(
                    color: Colors.amber[200],
                    fontSize: isVerySmallScreen ? 8 : 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // إظهار الساعة
            Text(
              timeFormat.format(_currentDateTime),
              style: TextStyle(
                fontSize: isVerySmallScreen ? 10 : 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // إظهار التاريخ
            Text(
              dateFormat.format(_currentDateTime),
              style: TextStyle(
                fontSize: isVerySmallScreen ? 8 : 9,
                fontWeight: FontWeight.w400,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Obtener nombre del día en árabe
  String _getArabicDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'الإثنين';
      case DateTime.tuesday:
        return 'الثلاثاء';
      case DateTime.wednesday:
        return 'الأربعاء';
      case DateTime.thursday:
        return 'الخميس';
      case DateTime.friday:
        return 'الجمعة';
      case DateTime.saturday:
        return 'السبت';
      case DateTime.sunday:
        return 'الأحد';
      default:
        return '';
    }
  }

  // Language switcher widget - Circle toggle that slides left/right to switch languages
  Widget _buildLanguageSwitcher() {
    // Use a safer approach with GetBuilder that handles rebuilds better
    return GetBuilder<AppTranslationService>(
      id: 'language_switcher',
      builder: (translationService) {
        // Get current locale from translation service
        final isArabic =
            translationService.currentLocale.value.languageCode == 'ar';

        return Container(
          width: 60,
          height: 36,
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          // Use Stack with AnimatedPositioned for the sliding effect
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Material(
              color: const Color.fromARGB(0, 255, 255, 255),
              child: Stack(
                children: [
                  // The sliding indicator
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    left: isArabic ? 2 : 30,
                    top: 2,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 125, 122, 160),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 20, 20, 20)
                                .withOpacity(0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Language text options with improved tap targets
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Arabic option
                      Expanded(
                        child: InkWell(
                          onTap: () => _changeLanguageSafely('ar'),
                          child: Center(
                            child: Text(
                              'AR',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isArabic
                                    ? const Color.fromARGB(255, 0, 0, 0)
                                    : const Color.fromARGB(137, 255, 255, 255),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // English option
                      Expanded(
                        child: InkWell(
                          onTap: () => _changeLanguageSafely('en'),
                          child: Center(
                            child: Text(
                              'EN',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: !isArabic
                                    ? const Color.fromARGB(255, 0, 0, 0)
                                    : const Color.fromARGB(137, 254, 254, 254),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Change application language with error handling and debouncing
  void _changeLanguageSafely(String languageCode) async {
    try {
      // Prevent multiple quick taps that could cause layout issues
      DateTime? lastTap;
      final now = DateTime.now();

      // Debounce language switching to prevent multiple rapid changes
      if (lastTap != null &&
          now.difference(lastTap) < const Duration(seconds: 2)) {
        LoggerUtil.logger
            .i('تم تجاهل تغيير اللغة - التغيير الأخير كان منذ وقت قصير');
        return;
      }
      lastTap = now;

      // Get the AppTranslationService
      final appTranslationService = Get.find<AppTranslationService>();

      // Don't change if already using this language
      if (appTranslationService.currentLocale.value.languageCode ==
          languageCode) {
        return;
      }

      // Show loading indicator to prevent user interaction during transition
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      // Small delay to ensure loading dialog appears
      await Future.delayed(const Duration(milliseconds: 50));

      // Change language
      await appTranslationService.changeLocale(languageCode);

      // Close loading dialog
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    } catch (e) {
      // Close loading dialog if open
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      LoggerUtil.logger.e('خطأ في تغيير اللغة: $e');

      // Show error message
      Get.snackbar(
        'error'.tr,
        'language_change_failed'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  // إضافة هذه الدالة إلى كلاس _HomeScreenState
  void _showOrdersPopup(BuildContext context) {
    final processingOrders = orderController.getProcessingOrders();

    // لا تعرض الشاشة المنبثقة إذا لم تكن هناك طلبات قيد المعالجة
    if (processingOrders.isEmpty) {
      Get.snackbar(
        'لا توجد طلبات',
        'لا توجد طلبات قيد المعالجة حاليًا',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withAlpha(200),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // حساب حجم الشاشة لجعل العرض متجاوب
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final isVerySmallScreen = screenSize.width < 320;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.notifications_active,
                  color: AppTheme.primaryColor),
              const SizedBox(width: 10),
              Text('الطلبات الجديدة (${processingOrders.length})'),
            ],
          ),
          contentPadding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
          content: Container(
            width: double.maxFinite,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: processingOrders.length,
              itemBuilder: (context, index) {
                final order = processingOrders[index];
                final totalItems =
                    order.items.fold(0, (sum, item) => sum + item.quantity);

                // حساب الوقت المنقضي منذ إنشاء الطلب
                final elapsedMinutes =
                    DateTime.now().difference(order.createdAt).inMinutes;
                final creationTime =
                    DateFormat('HH:mm').format(order.createdAt);

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        title: Text(
                          'طلب #${order.id.substring(0, 6)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.items
                                  .map((item) =>
                                      '${item.name} (${item.quantity}x)')
                                  .join(', '),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                Icon(Icons.timer_outlined,
                                    size: 14,
                                    color: _getTimeColor(elapsedMinutes)),
                                const SizedBox(width: 4),
                                Text(
                                  '$elapsedMinutes دقيقة منذ $creationTime',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _getTimeColor(elapsedMinutes),
                                    fontWeight: elapsedMinutes > 15
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        leading: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.primaryColor.withOpacity(0.2),
                          ),
                          child: Center(
                            child: Text(
                              '$totalItems',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // أزرار الإجراءات - متجاوبة مع أحجام الشاشات
                      _buildResponsiveOrderActions(
                          order, isSmallScreen, isVerySmallScreen),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إغلاق'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                Get.to(() => const OrderManagementScreen());
              },
              icon: Icon(Icons.receipt_long, size: isSmallScreen ? 16 : 18),
              label: const Text('إدارة جميع الطلبات'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 8 : 12,
                  vertical: isSmallScreen ? 6 : 8,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // دالة لإكمال الطلب
  Future<void> _completeOrder(Order order) async {
    try {
      // عرض مؤشر التحميل
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // استدعاء الدالة المناسبة في orderController لتغيير حالة الطلب إلى مكتمل
      final success = await orderController.completeOrder(order.id);

      // إغلاق مؤشر التحميل
      if (Get.isDialogOpen == true) Get.back();

      // إظهار رسالة نجاح أو فشل
      if (success) {
        Get.snackbar(
          'تم الإكمال',
          'تم إكمال الطلب بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // إغلاق نافذة الطلبات بعد الإكمال
        Navigator.of(context).pop();
      } else {
        Get.snackbar(
          'خطأ',
          'حدث خطأ أثناء إكمال الطلب',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      // إغلاق مؤشر التحميل في حالة حدوث استثناء
      if (Get.isDialogOpen == true) Get.back();

      LoggerUtil.logger.e('خطأ في إكمال الطلب: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ غير متوقع أثناء إكمال الطلب',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // دالة لإلغاء الطلب
  Future<void> _cancelOrder(Order order) async {
    try {
      // عرض مربع حوار تأكيد قبل الإلغاء
      final confirm = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('تأكيد الإلغاء'),
          content: const Text('هل أنت متأكد من رغبتك في إلغاء هذا الطلب؟'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('لا'),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('نعم، إلغاء الطلب'),
            ),
          ],
        ),
      );

      // إذا لم يؤكد المستخدم، لا نكمل العملية
      if (confirm != true) return;

      // عرض مؤشر التحميل
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // استدعاء الدالة المناسبة في orderController لتغيير حالة الطلب إلى ملغي
      final success = await orderController.cancelOrder(order.id);

      // إغلاق مؤشر التحميل
      if (Get.isDialogOpen == true) Get.back();

      // إظهار رسالة نجاح أو فشل
      if (success) {
        Get.snackbar(
          'تم الإلغاء',
          'تم إلغاء الطلب بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.amber,
          colorText: Colors.black,
          duration: const Duration(seconds: 2),
        );

        // إغلاق نافذة الطلبات بعد الإلغاء
        Navigator.of(context).pop();
      } else {
        Get.snackbar(
          'خطأ',
          'حدث خطأ أثناء إلغاء الطلب',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      // إغلاق مؤشر التحميل في حالة حدوث استثناء
      if (Get.isDialogOpen == true) Get.back();

      LoggerUtil.logger.e('خطأ في إلغاء الطلب: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ غير متوقع أثناء إلغاء الطلب',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // دالة مساعدة لبناء أزرار الإجراءات بشكل متجاوب
  Widget _buildResponsiveOrderActions(
      Order order, bool isSmallScreen, bool isVerySmallScreen) {
    // تعديل حجم الأزرار بناءً على حجم الشاشة
    final buttonHeight = isVerySmallScreen
        ? 32.0
        : isSmallScreen
            ? 36.0
            : 40.0;
    final iconSize = isVerySmallScreen
        ? 16.0
        : isSmallScreen
            ? 18.0
            : 20.0;
    final fontSize = isVerySmallScreen
        ? 11.0
        : isSmallScreen
            ? 12.0
            : 14.0;

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: 10, vertical: isSmallScreen ? 5 : 8),
      child: Row(
        children: [
          // زر إكمال الطلب
          Expanded(
            child: SizedBox(
              height: buttonHeight,
              child: ElevatedButton.icon(
                onPressed: () => _completeOrder(order),
                icon: Icon(Icons.check_circle,
                    size: iconSize, color: Colors.white),
                label: Text(
                  'إكمال',
                  style: TextStyle(fontSize: fontSize),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 12),
                ),
              ),
            ),
          ),
          SizedBox(width: isSmallScreen ? 6 : 10),
          // زر إلغاء الطلب
          Expanded(
            child: SizedBox(
              height: buttonHeight,
              child: ElevatedButton.icon(
                onPressed: () => _cancelOrder(order),
                icon: Icon(Icons.cancel, size: iconSize, color: Colors.white),
                label: Text(
                  'إلغاء',
                  style: TextStyle(fontSize: fontSize),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لتحديد لون النص بناءً على الوقت المنقضي
  Color _getTimeColor(int minutes) {
    if (minutes <= 5) return Colors.green;
    if (minutes <= 10) return Colors.orange;
    if (minutes <= 15) return Colors.deepOrange;
    return Colors.red;
  }   
   Widget _buildLogoSection(double logoSize, bool isSmallScreen,
        TextStyle titleStyle, TextStyle subtitleStyle, Color textColor) {
      return GetBuilder<SettingsController>(
        id: 'app_logo',
        builder: (controller) {
          final logoPath = controller.logoPath ?? 'assets/images/logo.png';
          
          return StatefulBuilder(
            builder: (context, setState) {
              // تعريف متغيرات داخل دالة البناء
              bool isHovering = false;
              final screenWidth = MediaQuery.of(context).size.width;
              final screenHeight = MediaQuery.of(context).size.height;
              final isSmallScreen = screenWidth < 600;
              
              // ضبط الأبعاد بشكل أفضل مع مراعاة ارتفاع الشاشة
              // تقليل الحجم في الشاشات الصغيرة أكثر
              final adjustedLogoPadding = isSmallScreen ? 4.0 : 8.0;
              
              // تصغير حجم اللوغو بنسبة أكبر للشاشات الصغيرة
              final adjustedLogoSize = isSmallScreen 
                  ? min(logoSize * 1.2, screenHeight * 0.18) 
                  : min(logoSize * 1.3, screenHeight * 0.19);
              
              // تقليل المسافات للتناسب مع المساحة المتاحة
              final topMargin = isSmallScreen ? 5.0 : 12.0;
              final bottomMargin = isSmallScreen ? 10.0 : 20.0;
              
              // استخدام ConstrainedBox للتأكد من عدم تجاوز العنصر للمساحة المتاحة
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: isSmallScreen ? screenHeight * 0.15 : screenHeight * 0.20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: topMargin),
                    
                    // اللوغو نفسه مع ضبط الأبعاد
                    InkWell(
                      onTap: () {
                        _showLogoSelectionDialog();
                      },
                      onHover: (hovering) {
                        setState(() => isHovering = hovering);
                      },
                      child: Neumorphic(
                        style: NeumorphicStyle(
                          depth: 0.3,
                          intensity: 0.15,
                          shape: NeumorphicShape.convex,
                          boxShape: isSmallScreen
                              ? const NeumorphicBoxShape.circle()
                              : NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(6)),
                          lightSource: LightSource.topLeft,
                          color: const Color.fromARGB(44, 19, 19, 19),
                        ),
                        child: Container(
                          width: adjustedLogoSize,
                          height: adjustedLogoSize,
                          padding: EdgeInsets.all(adjustedLogoPadding),
                          decoration: BoxDecoration(
                            color: isHovering
                                ? Colors.transparent
                                : const Color.fromARGB(125, 0, 0, 0),
                            borderRadius: isSmallScreen
                                ? BorderRadius.circular(adjustedLogoSize)
                                : BorderRadius.circular(5),
                          ),
                          child: ClipRRect(
                            borderRadius: isSmallScreen
                                ? BorderRadius.circular(adjustedLogoSize)
                                : BorderRadius.circular(4),
                            child: ImageHelper.buildImage(
                              logoPath,
                              fit: BoxFit.contain,
                              isCircular: isSmallScreen,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // تقليل المسافة السفلية
                    SizedBox(height: bottomMargin),
                  ],
                ),
              );
            },
          );
        },
      );
    }

  // دالة لإنشاء أزرار طلبات وجاهز بتصميم ثلاثي الأبعاد مع مراعاة اللغة الحالية
  Widget _buildDeliveryButtons(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isVerySmallScreen = screenWidth < 320;

    final buttonSize = isVerySmallScreen
        ? 32.0
        : isSmallScreen
            ? 36.0
            : 40.0;
    final iconSize = isVerySmallScreen
        ? 16.0
        : isSmallScreen
            ? 18.0
            : 20.0;
    final fontSize = isVerySmallScreen
        ? 10.0
        : isSmallScreen
            ? 11.0
            : 12.0;

    // الحصول على اللغة الحالية للتطبيق
    final appTranslationService = Get.find<AppTranslationService>();
    final isArabic =
        appTranslationService.currentLocale.value.languageCode == 'ar';

    return GetBuilder<AppTranslationService>(
        id: 'language_switcher',
        builder: (translationService) {
          final isArabic =
              translationService.currentLocale.value.languageCode == 'ar';

          // إنشاء القائمة بالترتيب الصحيح حسب اللغة
          final buttonsList = isArabic
              ? [
                  // للغة العربية: جاهز ثم طلبات (من اليمين إلى اليسار)
                  _buildJahezButton(buttonSize, fontSize),
                  const SizedBox(width: 10),
                  _buildTalabatButton(buttonSize, fontSize),
                ]
              : [
                  // للغة الإنجليزية: طلبات ثم جاهز (من اليسار إلى اليمين)
                  _buildTalabatButton(buttonSize, fontSize),
                  const SizedBox(width: 10),
                  _buildJahezButton(buttonSize, fontSize),
                ];

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                isArabic ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0, right: 8.0, left: 8.0),
                child: Text(
                  'order_now_with_delivery'.tr,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 255, 255, 255), // تغيير لون النص للأبيض
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 2,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
              // أزرار التوصيل في صف
              Row(
                mainAxisSize: MainAxisSize.min,
                children: buttonsList,
              ),
            ],
          );
        });
  }

  // دالة مساعدة لإنشاء زر طلبات
  Widget _buildTalabatButton(double buttonSize, double fontSize) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 3,
        intensity: 0.3,
        shape: NeumorphicShape.convex,
        boxShape:
            NeumorphicBoxShape.roundRect(BorderRadius.circular(buttonSize / 2)),
        color: const Color.fromARGB(255, 255, 115, 0).withOpacity(0.75), // خلفية سوداء مع شفافية
      ),
      child: GestureDetector(
        onTap: () async {
          final talabatUrl = Uri.parse(
              'https://www.talabat.com/bahrain/restaurant/755906/jbr-cafe-alhajiyat?aid=1031');
          if (await canLaunchUrl(talabatUrl)) {
            await launchUrl(talabatUrl, mode: LaunchMode.externalApplication);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(buttonSize / 2),
            border: Border.all(
              color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.7), // حدود بلون طلبات مع شفافية
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.delivery_dining, color: Color.fromARGB(255, 230, 227, 226), size: 16),
              const SizedBox(width: 4),
              Text(
                'talabat'.tr,
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255), // نص بلون طلبات
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة مساعدة لإنشاء زر جاهز
    Widget _buildJahezButton(double buttonSize, double fontSize) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 3,
        intensity: 0.3,
        lightSource: LightSource.topLeft,
        shape: NeumorphicShape.convex,
        boxShape:
            NeumorphicBoxShape.roundRect(BorderRadius.circular(buttonSize / 2)),
        color: const Color.fromARGB(255, 198, 0, 0).withOpacity(0.75), // خلفية سوداء مع شفافية
      ),
      child: GestureDetector(
        onTap: () async {
          final jahezUrl = Uri.parse(
              'https://www.instagram.com/jahezbh/?locale=slot%2Bdemo%2Bpg%2Bmahjong%2B3%E3%80%90777ONE.IN%E3%80%91.dgxn&hl=en');
          if (await canLaunchUrl(jahezUrl)) {
            await launchUrl(jahezUrl, mode: LaunchMode.externalApplication);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(buttonSize / 2),
            border: Border.all(
              color: const Color.fromARGB(255, 239, 239, 239).withOpacity(0.7), // حدود بلون جاهز مع شفافية
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'J',
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255), // لون جاهز
                  fontSize: fontSize + 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'Jahez',
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255), // لون جاهز
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildReorderableOptionsList() {
    return GetBuilder<MenuOptionsController>(
      id: 'home_options_list',
      builder: (controller) {
        // تحديد ما إذا كانت الشاشة صغيرة
        final screenWidth = MediaQuery.of(context).size.width;
        final isSmallScreen = screenWidth < 360;

        // تقسيم الخيارات إلى مجموعات (مثال: أساسية وثانوية)
        List<MenuOption> primaryOptions = [];
        List<MenuOption> secondaryOptions = [];

        if (controller.visibleOptions.length > 4) {
          primaryOptions = controller.visibleOptions.sublist(0, 4);
          secondaryOptions = controller.visibleOptions.sublist(4);
        } else {
          primaryOptions = controller.visibleOptions;
        }

        // لا تقم بتعريف activeTabIndex هنا، استخدم المتغير من المتحكم
        // RxInt activeTabIndex = 0.obs; ← احذف هذا السطر

        return Column(
          children: [
            // علامات التبويب إذا وجدت خيارات ثانوية
            if (secondaryOptions.isNotEmpty)
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTabButton(
                        // استخدام أيقونة بدلاً من النص
                        icon: Icons.home_outlined,
                        isActive: controller.activeTabIndex.value ==
                            0, // استخدم متغير المتحكم
                        onTap: () => controller.activeTabIndex.value =
                            0, // استخدم متغير المتحكم
                      ),
                      SizedBox(width: 16),
                      _buildTabButton(
                        // استخدام أيقونة بدلاً من النص
                        icon: Icons.more_horiz,
                        isActive: controller.activeTabIndex.value ==
                            1, // استخدم متغير المتحكم
                        onTap: () => controller.activeTabIndex.value =
                            1, // استخدم متغير المتحكم
                      ),
                    ],
                  )),

            SizedBox(height: 12),

            // عرض الخيارات المناسبة حسب علامة التبويب النشطة
            Obx(() {
              List<MenuOption> currentOptions =
                  controller.activeTabIndex.value == 0 // استخدم متغير المتحكم
                      ? primaryOptions
                      : secondaryOptions;

              // تعيين ارتفاع ثابت للحاوية
              return Container(
                height: isSmallScreen ? 300 : 320,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white.withOpacity(0.1),
                ),
                child: controller.isEditMode.value
                    ? ReorderableListView.builder(
                        itemCount: currentOptions.length,
                        onReorder: (oldIndex, newIndex) {
                          if (controller.activeTabIndex.value == 0) {
                            controller.reorderPrimaryOptions(
                                oldIndex, newIndex, primaryOptions);
                          } else {
                            controller.reorderSecondaryOptions(oldIndex,
                                newIndex, secondaryOptions, primaryOptions);
                          }
                        },
                        itemBuilder: (context, index) {
                          final option = currentOptions[index];
                          return _buildSlimOptionCard(
                            key: Key('menu_option_${option.id}'),
                            option: option,
                            isEditing: true,
                            onDelete: () => controller.hideOption(option.id),
                            isSmallScreen: isSmallScreen,
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: currentOptions.length,
                        itemBuilder: (context, index) {
                          final option = currentOptions[index];
                          // تمييز الخيار النشط
                          final bool isActive =
                              controller.isRouteActive(option.route);

                          return _buildSlimOptionCard(
                            key: Key('menu_option_${option.id}'),
                            option: option,
                            isEditing: false,
                            isSmallScreen: isSmallScreen,
                            isActive:
                                isActive, // إضافة معلمة لتحديد الخيار النشط
                          );
                        },
                      ),
              );
            }),

            // عرض قائمة الخيارات المخفية (تظهر فقط في وضع التحرير)
            if (controller.isEditMode.value)
              Obx(() {
                if (controller.hiddenOptions.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'hidden_options'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallScreen ? 14 : 16,
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.hiddenOptions.length,
                          itemBuilder: (context, index) {
                            final option = controller.hiddenOptions[index];
                            return Container(
                              width: 80,
                              margin: const EdgeInsets.only(right: 8),
                              child: Column(
                                children: [
                                  NeumorphicButton(
                                    style: NeumorphicStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      depth: 2,
                                      intensity: 0.6,
                                      shape: NeumorphicShape.flat,
                                      boxShape: NeumorphicBoxShape.circle(),
                                    ),
                                    onPressed: () =>
                                        controller.showOption(option.id),
                                    padding: EdgeInsets.all(12),
                                    child: Icon(option.icon,
                                        color: option.color, size: 24),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    option.title.tr,
                                    style: const TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'tap_to_show'.tr,
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.green),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
          ],
        );
      },
    );
  }

  // تعديل دالة _buildTabButton لدعم استخدام الأيقونات بدلاً من النص
  Widget _buildTabButton({
    String? title,
    IconData? icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: title != null ? 16 : 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              isActive ? AppTheme.primaryColor : Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: icon != null
            ? Container(
                width: 24,
                height: 24,
                child: Icon(
                  icon,
                  color: isActive ? Colors.white : Colors.grey.shade700,
                  size: 16,
                ),
              )
            : Text(
                title!,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey.shade700,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }

  // بطاقة خيار نحيفة
  Widget _buildSlimOptionCard({
    required MenuOption option,
    required bool isEditing,
    VoidCallback? onDelete,
    required Key key,
    required bool isSmallScreen,
    bool isActive = false, // إضافة معلمة جديدة
  }) {
    // الحصول على متحكم خيارات العرض
    final viewOptionsController = Get.find<ViewOptionsController>();
    final menuOptionsController = Get.find<MenuOptionsController>();

    // استخراج الإعدادات من المتحكم
    final Color textColor = viewOptionsController.getColorFromHex(
        viewOptionsController.getOptionTextColor(isSmallScreen));
    final Color borderColor = viewOptionsController.getColorFromHex(
        viewOptionsController.getOptionBorderColor(isSmallScreen));
    final Color iconColor = viewOptionsController.useCustomIconColors.value
        ? viewOptionsController.getColorFromHex(viewOptionsController.getOptionIconColor(isSmallScreen))
        : option.color;
    final double fontSize = viewOptionsController.getOptionTextSize(isSmallScreen);
    
    // استخراج إعدادات الخلفية والتباعد
    final Color bgColor = viewOptionsController.getColorFromHex(viewOptionsController.optionBackgroundColor.value);
    final double bgOpacity = viewOptionsController.optionBackgroundOpacity.value;
    final bool useOptionShadows = viewOptionsController.useOptionShadows.value;
    final double optionHeight = viewOptionsController.optionHeight.value;
    final double optionPadding = viewOptionsController.optionPadding.value;
    final double optionCornerRadius = viewOptionsController.optionCornerRadius.value;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: viewOptionsController.optionSpacing.value / 2,
      ),
      key: key,
      child: Dismissible(
        key: Key('dismiss_${option.id}'),
        direction: isEditing ? DismissDirection.endToStart : DismissDirection.none,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          color: Colors.red,
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        confirmDismiss: isEditing 
          ? (direction) async {
              // إضافة منطق التأكيد قبل الإخفاء
              return await Get.dialog<bool>(
                AlertDialog(
                  title: const Text('إخفاء الخيار'),
                  content: Text(
                      'هل تريد إخفاء "${option.title.tr}" من القائمة؟'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(result: false),
                      child: const Text('إلغاء'),
                    ),
                    ElevatedButton(
                      onPressed: () => Get.back(result: true),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red),
                      child: const Text('إخفاء'),
                    ),
                  ],
                ),
              ) ?? false;
            } 
          : null,
        onDismissed: isEditing 
          ? (direction) {
              // إضافة منطق الإخفاء
              menuOptionsController.hideOption(option.id);
              
              // إظهار رسالة تأكيد
              Get.snackbar(
                'تم الإخفاء',
                'تم إخفاء "${option.title.tr}" من القائمة',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.grey.shade800,
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
                mainButton: TextButton(
                  onPressed: () {
                    menuOptionsController.showOption(option.id);
                    Get.closeCurrentSnackbar();
                  },
                  child: const Text(
                    'تراجع',
                    style: TextStyle(color: Colors.amber),
                  ),
                ),
              );
            } 
          : null,
        child: GestureDetector(
          onTap: isEditing ? null : () => Get.find<MenuOptionsController>().navigateToOption(option.route),
          child: Container(
            height: optionHeight,
            decoration: BoxDecoration(
              color: bgColor.withOpacity(bgOpacity),
              borderRadius: BorderRadius.circular(optionCornerRadius),
              border: Border.all(
                color: isActive ? AppTheme.primaryColor : borderColor,
                width: isActive ? 2.0 : 1.0,
              ),
              boxShadow: useOptionShadows ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ] : null,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: optionPadding,
              vertical: 8,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor,
                    shape: BoxShape.circle,
                    boxShadow: useOptionShadows ? [
                      BoxShadow(
                        color: iconColor.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ] : null,
                  ),
                  child: Icon(
                    option.icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: optionPadding / 2),
                Expanded(
                  child: Text(
                    option.title.tr,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                      color: textColor,
                      shadows: null,
                    ),
                  ),
                ),
                if (!isEditing)
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16,
                  ),
                if (isEditing)
                  const Icon(
                    Icons.drag_handle,
                    color: Colors.grey,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLandscapeOptionWithDismissible(
      {required MenuOption option,
      required MenuOptionsController controller,
      required bool isSmallScreen,
      required Key key}) {
    return Dismissible(
      key: key,
      direction: DismissDirection
          .up, // تغيير الاتجاه إلى الأعلى لمزيد من الملاءمة في شبكة
      background: Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(bottom: 10.0),
        color: const Color.fromARGB(255, 0, 0, 0),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        return await Get.dialog<bool>(
              AlertDialog(
                title: const Text('إخفاء الخيار'),
                content: Text('هل تريد إخفاء "${option.title.tr}" من القائمة؟'),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(result: false),
                    child: const Text('إلغاء'),
                  ),
                  ElevatedButton(
                    onPressed: () => Get.back(result: true),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('إخفاء'),
                  ),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (direction) {
        controller.hideOption(option.id);
      },
      child: _buildLandscapeEditableButton(
        title: option.title.tr,
        icon: option.icon,
        color: option.color,
      ),
    );
  }

  // دالة مساعدة لإنشاء زر قابل للتحرير في GridView
  Widget _buildLandscapeEditableButton({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
  
    // الحصول على متحكم خيارات العرض
    final viewOptionsController = Get.find<ViewOptionsController>();
  
    // استخراج الإعدادات من المتحكم
    final bool useTransparentBackground = viewOptionsController.useTransparentCardBackground.value;
    final Color textColor = viewOptionsController.getColorFromHex(viewOptionsController.optionTextColor.value);
    final Color borderColor = viewOptionsController.getColorFromHex(viewOptionsController.optionBorderColor.value);
    final Color iconColor = viewOptionsController.useCustomIconColors.value
        ? viewOptionsController.getColorFromHex(viewOptionsController.optionIconColor.value)
        : color;
    final double fontSize = viewOptionsController.optionTextSize.value;
  
    // تحديد مستوى الشفافية
    final double backgroundOpacity = useTransparentBackground ? 0.2 : 1.0;

    return Container(
      decoration: BoxDecoration(
        // استخدام خلفية شفافة أو بيضاء حسب الإعداد
        color: useTransparentBackground
            ? Colors.white.withOpacity(backgroundOpacity)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        // استخدام لون الحدود المحدد في الإعدادات
        border: Border.all(
          color: borderColor,
          width: 1.0,
        ),
        // إضافة ظل خفيف
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: isSmallScreen ? 3 : 4,
            offset: Offset(0, isSmallScreen ? 1 : 2),
          )
        ],
      ),
      padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 8 : 12,
          vertical: isSmallScreen ? 6 : 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: isSmallScreen ? 30 : 38,
            height: isSmallScreen ? 30 : 38,
            decoration: BoxDecoration(
              // استخدام اللون المخصص أو اللون الأصلي
              color: viewOptionsController.useCustomIconColors.value ? iconColor : color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (viewOptionsController.useCustomIconColors.value ? iconColor : color).withOpacity(0.5),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: isSmallScreen ? 16 : 20,
            ),
          ),
          SizedBox(width: isSmallScreen ? 6 : 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      // استخدام حجم الخط المحدد في الإعدادات
                      fontSize: isSmallScreen ? fontSize - 2 : fontSize,
                      fontWeight: FontWeight.w600,
                      // استخدام لون النص المحدد في الإعدادات
                      color: textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.unfold_more, color: borderColor, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final double animation;
  BackgroundPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown.withAlpha(13)
      ..style = PaintingStyle.fill;

    final path = Path();
    for (int i = 1; i <= 3; i++) {
      double factor = i * 0.2;
      double offset = animation * 200 * factor;
      path.moveTo(0, size.height * (0.2 + 0.15 * i) + offset);
      path.quadraticBezierTo(
        size.width * 0.25,
        size.height * (0.3 + 0.15 * i) + offset,
        size.width * 0.5,
        size.height * (0.2 + 0.15 * i) + offset,
      );
      path.quadraticBezierTo(
        size.width * 0.75,
        size.height * (0.1 + 0.15 * i) + offset,
        size.width,
        size.height * (0.2 + 0.15 * i) + offset,
      );
      canvas.drawPath(path, paint);
      path.reset();
    }
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) =>
      oldDelegate.animation != animation;
}
