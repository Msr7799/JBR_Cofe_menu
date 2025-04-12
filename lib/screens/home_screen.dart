import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
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

  // Add service reference for preferences
  final _prefsService = Get.find<SharedPreferencesService>();

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
      _viewMode = _prefsService.getString('view_mode') ?? 'grid';
      _showImages = _prefsService.getBool('show_images') ?? true;
    });
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
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

        return Scaffold(
          // تطبيق الخلفية بناءً على النوع المختار
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'JBR Coffee Shop',
              style: TextStyle(
                color: AppTheme.textLightColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.view_list),
                tooltip: 'خيارات العرض',
                onPressed: () => _showViewOptionsDialog(context),
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
      default:
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

    return SafeArea(
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
                !_reducedMotion
                    ? SizedBox(
                        height: screenHeight * 0.25,
                        child: AnimationConfiguration.synchronized(
                          duration: const Duration(milliseconds: 800),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Neumorphic(
                                    style: NeumorphicStyle(
                                      depth: 10,
                                      intensity: 0.9,
                                      shape: NeumorphicShape.concave,
                                      boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.circular(
                                            screenWidth * 0.08),
                                      ),
                                      lightSource: LightSource.topLeft,
                                      color: Colors.white.withAlpha(217),
                                    ),
                                    child: Container(
                                      width: screenWidth * 0.35,
                                      height: screenWidth * 0.35,
                                      padding:
                                          EdgeInsets.all(screenWidth * 0.04),
                                      child: Image.asset(
                                        'assets/images/logo.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'app_name'.tr,
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.06,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                      shadows: [
                                        Shadow(
                                          offset: const Offset(2, 2),
                                          blurRadius: 3.0,
                                          color: Colors.black.withAlpha(76),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'app_description_short'.tr,
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.04,
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
                        height: screenHeight * 0.25,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Neumorphic(
                              style: NeumorphicStyle(
                                depth: 10,
                                intensity: 0.9,
                                shape: NeumorphicShape.concave,
                                boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(screenWidth * 0.08),
                                ),
                                lightSource: LightSource.topLeft,
                                color: Colors.white.withAlpha(217),
                              ),
                              child: Container(
                                width: screenWidth * 0.35,
                                height: screenWidth * 0.35,
                                padding: EdgeInsets.all(screenWidth * 0.04),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'app_name'.tr,
                              style: TextStyle(
                                fontSize: screenWidth * 0.06,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(2, 2),
                                    blurRadius: 3.0,
                                    color: Colors.black.withAlpha(76),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'app_description_short'.tr,
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w500,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.01,
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
                            color: const Color(0xFF6F4E37),
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          _buildNavigationButton(
                            title: 'rate'.tr,
                            icon: Icons.star_rate,
                            onTap: () => Get.to(() => const RateScreen()),
                            color: const Color(0xFFB85C38),
                          ),
                          SizedBox(height: screenHeight * 0.015),
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
                            color: const Color(0xFF4D4546),
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          _buildNavigationButton(
                            title: 'خيارات العرض',
                            icon: Icons.view_list,
                            onTap: () => _showViewOptionsDialog(context),
                            color: const Color(0xFF50727B),
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          _buildNavigationButton(
                            title: 'settings'.tr,
                            icon: Icons.settings,
                            onTap: () => Get.to(() => const SettingsScreen()),
                            color: const Color(0xFF5E5B52),
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          _buildNavigationButton(
                            title: 'حول البرنامج',
                            icon: Icons.info_outline,
                            onTap: () => Get.to(() => const AboutScreen()),
                            color: const Color(0xFF795548),
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
                    top: screenHeight * 0.02,
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
                              fontSize: 12,
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
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final textColor = settingsController.textColor;

    return SafeArea(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AnimationConfiguration.synchronized(
                    duration: const Duration(milliseconds: 1200),
                    child: SlideAnimation(
                      horizontalOffset: -50.0,
                      child: FadeInAnimation(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Neumorphic(
                              style: NeumorphicStyle(
                                depth: 10,
                                intensity: 0.9,
                                shape: NeumorphicShape.concave,
                                boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(24),
                                ),
                                lightSource: LightSource.topLeft,
                                color: Colors.white.withAlpha(217),
                              ),
                              child: Container(
                                width: screenHeight * 0.25,
                                height: screenHeight * 0.25,
                                padding: EdgeInsets.all(screenHeight * 0.03),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Text(
                              'app_name'.tr,
                              style: TextStyle(
                                fontSize: screenHeight * 0.04,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(2, 2),
                                    blurRadius: 3.0,
                                    color: Colors.black.withAlpha(76),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'app_description_short'.tr,
                              style: TextStyle(
                                fontSize: screenHeight * 0.025,
                                fontWeight: FontWeight.w500,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildBenefitPayQrSection(context, isPortrait: false),
                  _buildFeaturedFeedbacks(context, isPortrait: false),
                ],
              ),
            ),
          ),
          Container(
            height: screenHeight * 0.7,
            width: 1,
            color: Colors.brown.withAlpha(76),
            margin: const EdgeInsets.symmetric(horizontal: 10),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(screenHeight * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: AnimationLimiter(
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 2.5,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        padding: const EdgeInsets.all(8.0),
                        physics: const NeverScrollableScrollPhysics(),
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
                              color: const Color(0xFF6F4E37),
                            ),
                            _buildLandscapeButton(
                              title: 'rate'.tr,
                              icon: Icons.star_rate,
                              onTap: () => Get.to(() => RateScreen()),
                              color: const Color(0xFFB85C38),
                            ),
                            _buildLandscapeButton(
                              title: 'admin_panel'.tr,
                              icon: Icons.admin_panel_settings,
                              onTap: () {
                                if (authController.isAdmin.value) {
                                  Get.to(() => AdminDashboard());
                                } else {
                                  Get.to(() => LoginScreen());
                                }
                              },
                              color: const Color(0xFF4D4546),
                            ),
                            _buildLandscapeButton(
                              title: 'خيارات العرض',
                              icon: Icons.view_list,
                              onTap: () => _showViewOptionsDialog(context),
                              color: const Color(0xFF50727B),
                            ),
                            _buildLandscapeButton(
                              title: 'settings'.tr,
                              icon: Icons.settings,
                              onTap: () => Get.to(() => SettingsScreen()),
                              color: const Color(0xFF5E5B52),
                            ),
                            _buildLandscapeButton(
                              title: 'حول البرنامج',
                              icon: Icons.info_outline,
                              onTap: () => Get.to(() => const AboutScreen()),
                              color: const Color(0xFF795548),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
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
                            const SizedBox(height: 4),
                            Text(
                              'copyright'.tr,
                              style: TextStyle(
                                fontSize: 10,
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
                    shape: NeumorphicShape.concave,
                    boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.circular(16),
                    ),
                    color: Colors.white.withAlpha(230),
                    lightSource: LightSource.topLeft,
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
                              Icons.qr_code_2,
                              color: Colors.purple,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'ادفع مع بنفت بي',
                              style: TextStyle(
                                fontSize: isPortrait ? 18 : 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple.shade800,
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
                                    const Text(
                                      "خطأ في تحميل صورة الباركود",
                                      style: TextStyle(color: Colors.redAccent),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'امسح الباركود للدفع عبر تطبيق بنفت بي',
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
                child: Neumorphic(
                  style: NeumorphicStyle(
                    depth: 8,
                    intensity: 0.7,
                    shape: NeumorphicShape.concave,
                    boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.circular(16),
                    ),
                    color: Colors.white.withAlpha(230),
                    lightSource: LightSource.topLeft,
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
                              'آراء الزبائن',
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
                            label: const Text('شاركنا رأيك'),
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
        border: Border.all(
          color: Colors.brown.shade200.withAlpha(128),
          width: 1,
        ),
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
    final buttonHeight = MediaQuery.of(context).size.height * 0.07;

    return GestureDetector(
      onTap: onTap,
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 8,
          intensity: 0.8,
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
          color: Colors.white.withAlpha(217),
          lightSource: LightSource.topLeft,
        ),
        child: Container(
          width: double.infinity,
          height: buttonHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Neumorphic(
                style: NeumorphicStyle(
                  depth: 6,
                  intensity: 0.7,
                  shape: NeumorphicShape.convex,
                  boxShape: const NeumorphicBoxShape.circle(),
                  color: color,
                  lightSource: LightSource.topLeft,
                ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: buttonHeight * 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w600,
                    color: Colors.brown.shade900,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.brown.shade700,
                size: 16,
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

    return GestureDetector(
      onTap: onTap,
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 6,
          intensity: 0.8,
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
          color: Colors.white.withAlpha(217),
          lightSource: LightSource.topLeft,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Neumorphic(
                style: NeumorphicStyle(
                  depth: 4,
                  intensity: 0.7,
                  shape: NeumorphicShape.convex,
                  boxShape: const NeumorphicBoxShape.circle(),
                  color: color,
                  lightSource: LightSource.topLeft,
                ),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: screenHeight * 0.035,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: screenHeight * 0.023,
                    fontWeight: FontWeight.w600,
                    color: Colors.brown.shade900,
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
          color: Colors.white.withAlpha(217),
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
                  color: Colors.white,
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
