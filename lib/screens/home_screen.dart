import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gpr_coffee_shop/services/app_translation_service.dart';
import 'package:gpr_coffee_shop/utils/logger_util.dart';
import 'package:intl/intl.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
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
import '../utils/image_helper.dart';

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
  late final FeedbackController feedbackController =
      Get.find<FeedbackController>();
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
              // Language Switch Toggle
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
              Padding(
                padding: EdgeInsets.only(
                    top: isSmallScreen ? 10.0 : 15.0, right: 8.0),
                child: IconButton(
                  icon: Icon(
                    Icons.view_list,
                    size: isSmallScreen ? 20 : 24,
                  ),
                  tooltip: 'خيارات العرض',
                  onPressed: () => Get.to(() => ViewOptionsScreen()),
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
                                    Container(
                                      width: logoSize,
                                      height: logoSize,
                                      padding:
                                          EdgeInsets.all(screenWidth * 0.035),
                                      decoration: BoxDecoration(
                                          color: Colors.white.withAlpha(220),
                                          borderRadius: BorderRadius.circular(
                                              logoSize * 0.25),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 5,
                                              spreadRadius: 1,
                                            )
                                          ]),
                                      child: GestureDetector(
                                        onTap: () => _showLogoSelectionDialog(),
                                        child: ImageHelper.buildImage(
                                          settingsController.logoPath ??
                                              'assets/images/logo.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    // استخدام مسافة متناسبة مع حجم الشاشة
                                    SizedBox(height: screenHeight * 0.018),
                                    Text(
                                      'app_name'.tr,
                                      style: TextStyle(
                                        fontSize: titleFontSize,
                                        fontWeight: FontWeight.bold,
                                        color: _getAdaptiveTextColor(),
                                        shadows: [
                                          Shadow(
                                            offset: const Offset(1.5, 1.5),
                                            blurRadius: 3.0,
                                            color: Colors.black.withAlpha(66),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // إضافة مسافة متناسبة فوق العنوان الفرعي
                                    SizedBox(
                                        height: isVerySmallScreen
                                            ? screenHeight * 0.006
                                            : screenHeight * 0.01),
                                    Text(
                                      'app_description_short'.tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: descriptionFontSize,
                                        fontWeight: FontWeight.w500,
                                        color: textColor,
                                      ),
                                    ),
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
                              Neumorphic(
                                style: NeumorphicStyle(
                                  depth: 8,
                                  intensity: 0.8,
                                  shape: NeumorphicShape.concave,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(logoSize * 0.25),
                                  ),
                                  lightSource: LightSource.topLeft,
                                  color: Colors.white.withAlpha(217),
                                ),
                                child: Container(
                                  width: logoSize,
                                  height: logoSize,
                                  padding: EdgeInsets.all(screenWidth * 0.035),
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              // استخدام مسافة متناسبة مع حجم الشاشة
                              SizedBox(height: screenHeight * 0.018),
                              Text(
                                'app_name'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: titleFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                  shadows: [
                                    Shadow(
                                      offset: const Offset(1.5, 1.5),
                                      blurRadius: 3.0,
                                      color: Colors.black.withAlpha(66),
                                    ),
                                  ],
                                ),
                              ),
                              // إضافة مسافة متناسبة قبل العنوان الفرعي
                              SizedBox(
                                  height: isVerySmallScreen
                                      ? screenHeight * 0.006
                                      : screenHeight * 0.01),
                              Text(
                                'app_description_short'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: descriptionFontSize,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                  // إضافة مسافة إضافية بعد قسم اللوغو والعنوان
                  SizedBox(height: spacingAfterLogo),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      // تعديل المسافة العمودية بناءً على حجم الشاشة
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
                            _buildNavigationButton(
                                title: 'menu'.tr,
                                icon: Icons.coffee,
                                onTap: () => Get.to(() => MenuScreen()),
                                color: const Color(0xFF8b0000)),
                            SizedBox(
                                height: isSmallScreen
                                    ? screenHeight * 0.014
                                    : screenHeight * 0.018),
                            _buildNavigationButton(
                              title: 'rate'.tr,
                              icon: Icons.star_rate,
                              onTap: () => Get.to(() => const RateScreen()),
                              color: const Color(0xFF8b0000),
                            ),
                            SizedBox(
                                height: isSmallScreen
                                    ? screenHeight * 0.014
                                    : screenHeight * 0.018),
                            _buildNavigationButton(
                              title: 'admin_panel'.tr,
                              icon: Icons.admin_panel_settings,
                              onTap: () {
                                if (authController.isAdmin.value) {
                                  Get.to(() => const AdminDashboard());
                                } else {
                                  Get.to(() => LoginScreen());
                                }
                              },
                              color: const Color(0xFF8b0000),
                            ),
                            SizedBox(
                                height: isSmallScreen
                                    ? screenHeight * 0.014
                                    : screenHeight * 0.018),
                            _buildNavigationButton(
                              title: 'display_options'.tr,
                              icon: Icons.view_list,
                              onTap: () => Get.to(() => ViewOptionsScreen()),
                              color: const Color(0xFF50727B),
                            ),
                            SizedBox(
                                height: isSmallScreen
                                    ? screenHeight * 0.014
                                    : screenHeight * 0.018),
                            _buildNavigationButton(
                              title: 'settings'.tr,
                              icon: Icons.settings,
                              onTap: () => Get.to(() => const SettingsScreen()),
                              color: const Color(0xFF50727B),
                            ),
                            SizedBox(
                                height: isSmallScreen
                                    ? screenHeight * 0.014
                                    : screenHeight * 0.018),
                            _buildNavigationButton(
                              title: 'about_app_title'.tr,
                              icon: Icons.info_outline,
                              onTap: () => Get.to(() => const AboutScreen()),
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildBenefitPayQrSection(context, isPortrait: true),
                  _buildFeaturedFeedbacks(context, isPortrait: true),
                  Padding(
                    padding: EdgeInsets.only(
                      top: screenHeight * 0.015,
                      bottom: screenHeight * 0.02,
                    ),
                    child: AnimationConfiguration.synchronized(
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

    // تحديد عدد الأعمدة في شبكة الأزرار
    final int gridCrossAxisCount = isSmallScreen
        ? 1
        : isTablet
            ? 2
            : 3;
    final double gridChildAspectRatio = isSmallScreen ? 3.5 : 2.5;

    return SafeArea(
      child: Row(
        children: [
          // العمود الأيسر - الشعار والمعلومات
          Expanded(
            flex: leftColumnFlex,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                            SizedBox(height: screenHeight * 0.01),
                            // اسم التطبيق
                            Text(
                              'app_name'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isSmallScreen
                                    ? screenHeight * 0.03
                                    : screenHeight * 0.04,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(1.5, 1.5),
                                    blurRadius: 3.0,
                                    color: Colors.black.withAlpha(66),
                                  ),
                                ],
                              ),
                            ),
                            // وصف التطبيق
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.02,
                                vertical: screenHeight * 0.01,
                              ),
                              child: Text(
                                'app_description_short'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isSmallScreen
                                      ? screenHeight * 0.02
                                      : screenHeight * 0.025,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // قسم BenefitPay QR
                  _buildBenefitPayQrSection(context, isPortrait: false),
                  // قسم آراء العملاء
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
          // العمود الأيمن - أزرار التطبيق
          Expanded(
            flex: rightColumnFlex,
            child: Padding(
              padding: EdgeInsets.all(screenHeight * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // شبكة الأزرار
                  Expanded(
                    child: AnimationLimiter(
                      child: GridView.count(
                        crossAxisCount: gridCrossAxisCount,
                        childAspectRatio: gridChildAspectRatio,
                        crossAxisSpacing: isSmallScreen ? 8 : 12,
                        mainAxisSpacing: isSmallScreen ? 8 : 12,
                        padding: EdgeInsets.all(screenWidth * 0.01),
                        physics: const BouncingScrollPhysics(),
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 600),
                          childAnimationBuilder: (widget) => ScaleAnimation(
                            scale: 0.9,
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: [
                            _buildLandscapeButton(
                              title: 'menu'.tr,
                              icon: Icons.coffee,
                              onTap: () => Get.to(() => MenuScreen()),
                              color: const Color(0xFF8b0000),
                            ),
                            _buildLandscapeButton(
                              title: 'rate'.tr,
                              icon: Icons.star_rate,
                              onTap: () => Get.to(() => RateScreen()),
                              color: const Color(0xFF8b0000),
                            ),
                            _buildLandscapeButton(
                              title: 'admin_panel'.tr,
                              icon: Icons.admin_panel_settings,
                              onTap: () {
                                if (authController.isAdmin.value) {
                                  Get.to(() => const AdminDashboard());
                                } else {
                                  Get.to(() => LoginScreen());
                                }
                              },
                              color: const Color(0xFF8b0000),
                            ),
                            _buildLandscapeButton(
                              title: 'display_options'.tr,
                              icon: Icons.view_list,
                              onTap: () => Get.to(() => ViewOptionsScreen()),
                              color: const Color(0xFF50727B),
                            ),
                            _buildLandscapeButton(
                              title: 'settings'.tr,
                              icon: Icons.settings,
                              onTap: () => Get.to(() => const SettingsScreen()),
                              color: const Color(0xFF50727B),
                            ),
                            _buildLandscapeButton(
                              title: 'about_app_title'.tr,
                              icon: Icons.info_outline,
                              onTap: () => Get.to(() => const AboutScreen()),
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // حقوق النشر في الأسفل
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
                    padding: const EdgeInsets.all(16.0),
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
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'pay_with_benefitpay'.tr,
                                style: TextStyle(
                                  fontSize: isPortrait ? 16 : 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple.shade800,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: isPortrait
                                ? screenWidth * 0.7
                                : screenHeight * 0.4,
                            maxHeight: isPortrait
                                ? screenWidth * 0.7
                                : screenHeight * 0.4,
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
                                      size: 48,
                                      color: Colors.red.shade300,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'error_loading_qr'.tr,
                                      style: const TextStyle(
                                          color: Colors.redAccent),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'scan_qr_to_pay'.tr,
                          style: TextStyle(
                            fontSize: isPortrait ? 14 : 12,
                            color: Colors.grey.shade700,
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
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
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

    return GestureDetector(
      onTap: onTap,
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
          padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 10 : 12),
          child: Row(
            children: [
              Neumorphic(
                style: NeumorphicStyle(
                  depth: isSmallScreen ? 4 : 6,
                  intensity: 0.7,
                  shape: NeumorphicShape.convex,
                  boxShape: const NeumorphicBoxShape.circle(),
                  color: color,
                  lightSource: LightSource.topLeft,
                  shadowDarkColor: Colors.black45,
                  shadowLightColor: Colors.transparent,
                ),
                child: Container(
                  padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: iconSize,
                  ),
                ),
              ),
              SizedBox(width: isSmallScreen ? 10 : 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: textColor.withOpacity(0.7),
                size: isSmallScreen ? 12 : 14,
              ),
            ],
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

  Widget _buildMainOptions() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildOptionCard(
              title: 'القائمة',
              icon: Icons.restaurant_menu,
              onTap: () => Get.to(() => MenuScreen()),
              gradient: const LinearGradient(
                colors: [Colors.amber, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            _buildOptionCard(
              title: 'تقييم',
              icon: Icons.star,
              onTap: () => Get.to(() => RateScreen()),
              gradient: const LinearGradient(
                colors: [Colors.lightBlue, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildOptionCard(
              title: 'الإعدادات',
              icon: Icons.settings,
              onTap: () => Get.to(() => SettingsScreen()),
              gradient: const LinearGradient(
                colors: [Colors.purple, Colors.deepPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            _buildOptionCard(
              title: 'خيارات العرض',
              icon: Icons.visibility,
              onTap: () => Get.to(() => ViewOptionsScreen()),
              gradient: const LinearGradient(
                colors: [Colors.teal, Colors.green],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ],
        ),
      ],
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
    Get.dialog(
      AlertDialog(
        title: const Text('تغيير شعار التطبيق'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('اختر صورة الشعار:'),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  _buildLogoOption('assets/images/logo.png'),
                  _buildLogoOption('assets/images/JBR.png'),
                  _buildLogoOption('assets/images/JBR1.png'),
                  _buildLogoOption('assets/images/JBR2.png'),
                  _buildLogoOption('assets/images/JBR3.png'),
                  _buildCustomLogoOption(),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }

  // خيار لوغو
  Widget _buildLogoOption(String imagePath) {
    return GestureDetector(
      onTap: () {
        settingsController.setLogoPath(imagePath);
        Get.back();
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  // خيار إضافة شعار مخصص
  Widget _buildCustomLogoOption() {
    return GestureDetector(
      onTap: () async {
        // يمكن هنا إضافة خيار لتحميل صورة مخصصة
        Get.back();
        Get.snackbar(
          'ملاحظة',
          'سيتم إضافة دعم تحميل صورة مخصصة في الإصدارات القادمة',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.amber.withOpacity(0.8),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade100,
        ),
        padding: const EdgeInsets.all(8),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate, size: 30),
            SizedBox(height: 5),
            Text('تحميل', style: TextStyle(fontSize: 10)),
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
                        color: const Color(0xFF8b0000),
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
                              'عر',
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
