import 'dart:io';
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/auth_controller.dart';
import 'package:gpr_coffee_shop/controllers/feedback_controller.dart';
import 'package:gpr_coffee_shop/controllers/menu_options_controller.dart';
import 'package:gpr_coffee_shop/controllers/order_controller.dart';
import 'package:gpr_coffee_shop/controllers/settings_controller.dart';
import 'package:gpr_coffee_shop/models/app_settings.dart';
import 'package:gpr_coffee_shop/models/order.dart';
import 'package:gpr_coffee_shop/screens/admin/order_management_screen.dart';
import 'package:gpr_coffee_shop/services/shared_preferences_service.dart';
import 'package:gpr_coffee_shop/services/app_translation_service.dart';
import 'package:gpr_coffee_shop/utils/logger_util.dart';
import 'package:gpr_coffee_shop/utils/responsive_helper.dart';
import 'package:gpr_coffee_shop/widgets/home/components/home_drawer.dart'
    as drawer;

// Import our new refactored components
import 'package:gpr_coffee_shop/widgets/home/components/date_time_widget.dart';
import 'package:gpr_coffee_shop/layouts/portrait_layout.dart';
import 'package:gpr_coffee_shop/layouts/landscape_layout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // Define unique keys for each component
  final GlobalKey _backgroundKey =
      GlobalKey(debugLabel: 'background_container');
  final GlobalKey _contentKey = GlobalKey(debugLabel: 'content_container');

  // Controllers
  final AuthController authController = Get.find<AuthController>();
  final SettingsController settingsController = Get.find<SettingsController>();
  final OrderController orderController = Get.find<OrderController>();
  late final FeedbackController feedbackController =
      Get.find<FeedbackController>();
  late final MenuOptionsController menuOptionsController;
  late AnimationController _animationController;
  bool _reducedMotion = false;
  // View options variables
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

    // Load non-UI-dependent preferences here
    _loadNonUIPreferences();

    // Schedule MediaQuery-dependent code for after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadViewPreferences();
      }
    });

    // Start timer to update date and time each second
    _dateTimeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentDateTime = DateTime.now();
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Safe place to use MediaQuery after widget is inserted into the tree
    _loadViewPreferences();
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

  // Load preferences that don't depend on UI/MediaQuery
  void _loadNonUIPreferences() {
    // Load home view mode but apply based on screen size later
    final savedHomeViewMode = _prefsService.getString('home_view_mode');
    if (savedHomeViewMode.isNotEmpty) {
      _homeViewMode = savedHomeViewMode;
    }
  }

  // Load preferences that depend on UI/MediaQuery (screen size)
  void _loadViewPreferences() {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;

    setState(() {
      // For small screens, always use grid view regardless of saved preferences
      if (isSmallScreen) {
        _homeViewMode = 'grid';
      }
      // For larger screens, we already loaded the preference in _loadNonUIPreferences
    });
  }

  // Toggle home screen view mode between grid and list
  void _toggleHomeViewMode() {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;

    // Don't allow toggling on small screens - maintain grid view
    if (isSmallScreen) {
      return;
    }

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
    );
  }

  @override
  Widget build(BuildContext context) {
    final metrics = ResponsiveHelper.getScreenMetrics(context);

    return GetBuilder<SettingsController>(
      builder: (controller) {
        final backgroundType = controller.backgroundType;
        final backgroundColor = controller.backgroundColor;
        final backgroundImagePath = controller.backgroundImagePath;

        // Variables for improved responsiveness on various screen sizes
        final isSmallScreen = metrics['isSmallScreen'] as bool;
        final isTablet = metrics['isTablet'] as bool;
        final isDesktop = metrics['isDesktop'] as bool;
        return Scaffold(
          drawer: drawer.HomeDrawer.buildMainDrawer(context),
          appBar: AppBar(
            // Leading element in AppBar contains the side menu icon in a decorated Container
            leading: Builder(
              builder: (context) => Container(
                padding: EdgeInsets.only(
                    left: 2.0,
                    bottom: 8.0,
                    top: isSmallScreen ? 8.0 : 10.0,
                    right: 2.0),
                margin:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 9.0),
                decoration: BoxDecoration(
                  color: authController.isLoggedIn.value
                      ? const Color.fromARGB(255, 39, 178, 48).withOpacity(0.3)
                      : const Color.fromARGB(255, 124, 124, 124)
                          .withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: const Color.fromARGB(255, 200, 200, 200)
                        .withOpacity(0.6),
                    width: 0.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: isSmallScreen ? 22 : 24,
                    weight: 900,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  tooltip: 'فتح القائمة',
                  splashColor: Colors.white38,
                ),
              ),
            ),

            // Add clock before title
            titleSpacing: 0,
            title: Row(
              children: [
                // Clock element
                Padding(
                  padding: EdgeInsets.only(
                      left: 0.0,
                      bottom: 8.0,
                      top: isSmallScreen ? 8.0 : 10.0,
                      right: 0.0),
                  child: DateTimeWidget(currentDateTime: _currentDateTime),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: isSmallScreen ? 10.0 : 15.0),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                ),
              ],
            ),

            actions: [
              // Menu customization button
              Padding(
                padding: EdgeInsets.only(top: isSmallScreen ? 10.0 : 15.0),
                child: GetBuilder<MenuOptionsController>(builder: (controller) {
                  return IconButton(
                    icon: Icon(
                      controller.isEditMode.value ? Icons.check : Icons.edit,
                      color: controller.isEditMode.value
                          ? const Color.fromARGB(255, 46, 207, 51)
                          : Colors.white,
                      size: isSmallScreen ? 20 : 24,
                    ),
                    tooltip: controller.isEditMode.value
                        ? 'انتهاء من التخصيص'
                        : 'تخصيص القائمة',
                    onPressed: () => controller.toggleEditMode(),
                  );
                }),
              ),

              // Reset to defaults button - shown only in edit mode
              Padding(
                padding: EdgeInsets.only(top: isSmallScreen ? 10.0 : 15.0),
                child: GetBuilder<MenuOptionsController>(builder: (controller) {
                  return Visibility(
                    visible: controller.isEditMode.value,
                    child: IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: isSmallScreen ? 20 : 24,
                      ),
                      tooltip: 'استعادة الإعدادات الافتراضية',
                      onPressed: () => controller.resetToDefaults(),
                    ),
                  );
                }),
              ),

              // Bell icon for orders (admin only)
              if (authController.isAdmin.value)
                GetBuilder<OrderController>(builder: (controller) {
                  final pendingOrdersCount = controller.getPendingOrdersCount();
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
                }), // Language switch toggle
              Padding(
                padding: EdgeInsets.only(top: isSmallScreen ? 10.0 : 15.0),
                child: GetBuilder<AppTranslationService>(
                    id: 'language_switcher',
                    builder: (translationService) {
                      final isArabic =
                          translationService.currentLocale.value.languageCode ==
                              'ar';
                      return IconButton(
                        icon: Image.asset(
                          'assets/images/bahrain_flag.png',
                          width: isSmallScreen ? 20 : 24,
                          height: isSmallScreen ? 20 : 24,
                        ),
                        onPressed: () {
                          // Toggle between Arabic and English
                          final newLang = isArabic ? 'en' : 'ar';
                          translationService.changeLocale(newLang);
                        },
                        tooltip: 'تغيير اللغة',
                      );
                    }),
              ),

              // View toggle button - tablets and desktops only
              if (isTablet || isDesktop)
                Padding(
                  padding: EdgeInsets.only(top: isSmallScreen ? 10.0 : 15.0),
                  child: IconButton(
                    icon: Icon(
                      _homeViewMode == 'grid'
                          ? Icons.view_list
                          : Icons.grid_view,
                      size: isTablet ? 28 : 24,
                      color: Colors.white,
                    ),
                    iconSize: isTablet ? 28 : 24,
                    tooltip:
                        _homeViewMode == 'grid' ? 'عرض كقائمة' : 'عرض كشبكة',
                    onPressed: _toggleHomeViewMode,
                    // Expand tap area for tablet use
                    splashRadius: isTablet ? 24 : 20,
                  ),
                ),

              // Order management button (admin only)
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
          // Set background directly on Scaffold
          backgroundColor:
              backgroundType == BackgroundType.color ? backgroundColor : null,

          body: Container(
            key: _backgroundKey,
            // Apply background based on selected type
            decoration: _buildBackgroundDecoration(
              backgroundType,
              backgroundColor,
              backgroundImagePath,
            ),
            child: SafeArea(
              child: Container(
                key: _contentKey,
                child: OrientationBuilder(
                  builder: (context, orientation) {
                    return Stack(
                      children: [
                        // Remove default moving background if user selected custom background
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

                        // Add subtle effect for custom background
                        if (backgroundType == BackgroundType.default_bg)
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Container(
                              color: const Color.fromARGB(255, 241, 240, 240)
                                  .withAlpha(25),
                            ),
                          ),

                        // Switch between portrait and landscape layouts
                        orientation == Orientation.portrait
                            ? PortraitLayout(reducedMotion: _reducedMotion)
                            : const LandscapeLayout(),
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
        return BoxDecoration(
          image: DecorationImage(
            image: FileImage(File(imagePath!)),
            fit: BoxFit.cover,
          ),
        );
      case BackgroundType.default_bg:
        return const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8F8F8), Color(0xFFF0F0F0)],
          ),
        );
    }
  }

  // Show popup with processing orders
  void _showOrdersPopup(BuildContext context) {
    final processingOrders = orderController.getProcessingOrders();

    // Don't show popup if no processing orders
    if (processingOrders.isEmpty) {
      Get.snackbar(
        'لا توجد طلبات',
        'لا توجد طلبات قيد المعالجة حاليًا',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey.shade200,
      );
      return;
    }

    // Calculate screen size for responsive display
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final isVerySmallScreen = screenSize.width < 320;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.notifications_active,
                color: AppTheme.primaryColor),
            SizedBox(width: 8),
            Text('الطلبات قيد المعالجة'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: isVerySmallScreen
              ? 200
              : isSmallScreen
                  ? 250
                  : 300,
          child: ListView.builder(
            itemCount: processingOrders.length,
            itemBuilder: (context, index) {
              final order = processingOrders[index];
              final totalItems =
                  order.items.fold(0, (prev, item) => prev + item.quantity);
              // Calculate elapsed time
              final now = DateTime.now();
              final orderTime =
                  order.createdAt; // Using createdAt instead of creationTime
              final difference = now.difference(orderTime);
              final elapsedMinutes = difference.inMinutes;

              // Format creation time
              final creationTime =
                  '${orderTime.hour.toString().padLeft(2, '0')}:${orderTime.minute.toString().padLeft(2, '0')}';

              return Card(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  title: Text(
                    'طلب #${order.id.substring(0, 6)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.items
                            .map((item) => '${item.name} (${item.quantity}x)')
                            .join(', '),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Icon(Icons.timer_outlined,
                              size: 14, color: _getTimeColor(elapsedMinutes)),
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
                  // Responsive action buttons
                  trailing: _buildResponsiveOrderActions(
                      order, isSmallScreen, isVerySmallScreen),
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
            label: const Text('إدارة الطلبات'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 12),
            ),
          ),
        ],
      ),
    );
  }

  // Complete an order
  Future<void> _completeOrder(Order order) async {
    try {
      // Show loading indicator
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      // Call the appropriate method in orderController to change order status to completed
      final success = await orderController.completeOrder(order.id);

      // Close loading indicator
      if (Get.isDialogOpen == true) Get.back();

      // Show success or error message
      if (success) {
        Navigator.of(context).pop();
        Get.snackbar(
          'تم إكمال الطلب',
          'تم تغيير حالة الطلب إلى مكتمل',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'خطأ',
          'حدث خطأ أثناء تغيير حالة الطلب',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Close loading indicator in case of exception
      if (Get.isDialogOpen == true) Get.back();

      LoggerUtil.logger.e('خطأ في إكمال الطلب: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تغيير حالة الطلب: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Cancel an order
  Future<void> _cancelOrder(Order order) async {
    try {
      // Show confirmation dialog before cancellation
      final confirm = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('تأكيد الإلغاء'),
          content: Text('هل تريد إلغاء الطلب #${order.id.substring(0, 6)}؟'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('لا'),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('نعم، إلغاء'),
            ),
          ],
        ),
      );

      // If user didn't confirm, don't proceed
      if (confirm != true) return;

      // Show loading indicator
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      // Call appropriate method in orderController to change order status to cancelled
      final success = await orderController.cancelOrder(order.id);

      // Close loading indicator
      if (Get.isDialogOpen == true) Get.back();

      // Show success or error message
      if (success) {
        Navigator.of(context).pop();
        Get.snackbar(
          'تم إلغاء الطلب',
          'تم تغيير حالة الطلب إلى ملغي',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'خطأ',
          'حدث خطأ أثناء تغيير حالة الطلب',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Close loading indicator in case of exception
      if (Get.isDialogOpen == true) Get.back();

      LoggerUtil.logger.e('خطأ في إلغاء الطلب: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تغيير حالة الطلب: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Helper to build responsive action buttons
  Widget _buildResponsiveOrderActions(
      Order order, bool isSmallScreen, bool isVerySmallScreen) {
    // Adjust button height based on screen size
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
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: buttonHeight,
            child: ElevatedButton.icon(
              icon: Icon(Icons.check, size: iconSize),
              label: Text(
                'إكمال',
                style: TextStyle(fontSize: fontSize),
              ),
              onPressed: () => _completeOrder(order),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: buttonHeight,
            child: TextButton.icon(
              icon: Icon(Icons.cancel_outlined, size: iconSize),
              label: Text(
                'إلغاء',
                style: TextStyle(fontSize: fontSize),
              ),
              onPressed: () => _cancelOrder(order),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to determine text color based on elapsed time
  Color _getTimeColor(int minutes) {
    if (minutes <= 5) return Colors.green;
    if (minutes <= 10) return Colors.orange;
    if (minutes <= 15) return Colors.deepOrange;
    return Colors.red;
  }
}
