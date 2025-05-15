import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/screens/home_screen.dart';
import 'package:gpr_coffee_shop/controllers/settings_controller.dart';

// Only import Google Maps when on supported platforms
import 'dart:async';
import 'package:gpr_coffee_shop/widgets/platform_map_widget.dart';

/// شاشة موقع المقهى والمعلومات
class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  // إحداثيات مقهى JBR الحقيقية
  static const double latitude = 26.1363942;
  static const double longitude = 50.5714665;

  // Controller for theme settings
  final SettingsController settingsController = Get.find<SettingsController>();

  // متغير للتحكم في حالة تحميل الخريطة
  final RxBool _isMapReady = false.obs;

  @override
  void initState() {
    super.initState();
    // تأخير قصير لتظهير الخريطة
    Future.delayed(const Duration(milliseconds: 500), () {
      _isMapReady.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // قياس حجم الشاشة لجعل الشاشة متجاوبة
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 360;
    final bool isLargeScreen = screenSize.width > 600;
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // تعيين ارتفاع الخريطة بناءً على الشاشة
    final double mapHeight = isLandscape
        ? screenSize.height * 0.6
        : isLargeScreen
            ? 400
            : isSmallScreen
                ? 200
                : 300;

    return PopScope(
      canPop: Navigator.of(context).canPop(),
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          Get.offAll(() => const HomeScreen());
        }
      },
      child: GetBuilder<SettingsController>(
        builder: (controller) {
          // تطبيق الثيم بناءً على إعدادات المتحكم
          // استخدام الثيم الحالي مباشرة بدلاً من تحديد الألوان يدويًا
          final ThemeData activeTheme = Theme.of(context);
          final Color primaryColor = activeTheme.colorScheme.primary;
          final Color textColor = activeTheme.colorScheme.onSurface;
          final Color backgroundColor = activeTheme.scaffoldBackgroundColor;

          return Theme(
            data: activeTheme,
            child: Scaffold(
              backgroundColor: activeTheme.scaffoldBackgroundColor,
              appBar: AppBar(
                title: Text(
                  'our_location'.tr,
                  style: TextStyle(
                    color: activeTheme.appBarTheme.foregroundColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                backgroundColor: activeTheme.appBarTheme.backgroundColor,
                elevation: 2,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios,
                      color: activeTheme.appBarTheme.foregroundColor),
                  onPressed: () => Get.back(),
                ),
              ),
              body: _buildResponsiveLayout(
                  context,
                  primaryColor,
                  textColor,
                  backgroundColor,
                  activeTheme,
                  isLandscape,
                  isSmallScreen,
                  isLargeScreen,
                  mapHeight),
            ),
          );
        },
      ),
    );
  }

  /// بناء التخطيط المتجاوب للشاشة
  Widget _buildResponsiveLayout(
      BuildContext context,
      Color primaryColor,
      Color textColor,
      Color backgroundColor,
      ThemeData theme,
      bool isLandscape,
      bool isSmallScreen,
      bool isLargeScreen,
      double mapHeight) {
    // تخطيط أفقي للشاشات في وضع landscape
    if (isLandscape) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // قسم الخريطة (يأخذ نصف الشاشة)
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildMap(context, primaryColor, theme, mapHeight),
              ),
            ),
          ),
          // قسم المعلومات (يأخذ نصف الشاشة)
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize:
                      MainAxisSize.min, // To avoid unbounded height issues
                  children: [
                    _buildLocationInfo(
                        primaryColor, textColor, backgroundColor, theme),
                    const SizedBox(height: 16),
                    _buildOpeningHours(
                        primaryColor, textColor, backgroundColor, theme),
                    const SizedBox(height: 16),
                    _buildContactButtons(
                        primaryColor,
                        theme,
                        isSmallScreen,
                        MediaQuery.of(context).size.width / 2 -
                            32), // نصف عرض الشاشة مع هامش
                    const SizedBox(height: 16),
                    _buildDeliveryInfo(
                        primaryColor, textColor, backgroundColor, theme),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      // التخطيط العمودي العادي للشاشات في الوضع الطبيعي
      return SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.all(isSmallScreen ? 12 : (isLargeScreen ? 24 : 16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min, // To avoid unbounded height issues
            children: [
              // قسم الخريطة
              _buildMap(context, primaryColor, theme, mapHeight),
              const SizedBox(height: 20),

              // معلومات الموقع
              _buildLocationInfo(
                  primaryColor, textColor, backgroundColor, theme),
              const SizedBox(height: 20),

              // ساعات العمل
              _buildOpeningHours(
                  primaryColor, textColor, backgroundColor, theme),
              const SizedBox(height: 20),

              // أزرار التواصل
              _buildContactButtons(
                  primaryColor,
                  theme,
                  isSmallScreen,
                  MediaQuery.of(context).size.width -
                      (isSmallScreen ? 24 : (isLargeScreen ? 48 : 32))),
              const SizedBox(height: 20),

              // معلومات التوصيل
              _buildDeliveryInfo(
                  primaryColor, textColor, backgroundColor, theme),
            ],
          ),
        ),
      );
    }
  }

  /// بناء قسم خريطة الموقع
  Widget _buildMap(BuildContext context, Color primaryColor, ThemeData theme,
      double mapHeight) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 4,
        intensity: 0.7,
        color: theme.cardTheme.color,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: mapHeight,
          child: Stack(
            children: [
              // استخدام PlatformMapWidget الذي يتعامل مع توافق المنصات
              PlatformMapWidget(
                latitude: latitude,
                longitude: longitude,
                isMapReady: _isMapReady.value,
              ),

              // مؤشر التحميل - يظهر حتى تكون الخريطة جاهزة
              Obx(() => _isMapReady.value
                  ? const SizedBox.shrink()
                  : Container(
                      color: theme.brightness == Brightness.dark
                          ? Colors.black.withOpacity(0.7)
                          : Colors.white.withOpacity(0.7),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    )),

              // زر فتح Google Maps
              Positioned(
                right: 10,
                bottom: 10,
                child: NeumorphicButton(
                  style: NeumorphicStyle(
                    depth: 2,
                    intensity: 0.7,
                    color: primaryColor,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
                  ),
                  onPressed: _openMapsApp,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.map,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'open_in_maps'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }

  /// بناء قسم معلومات الموقع
  Widget _buildLocationInfo(Color primaryColor, Color textColor,
      Color backgroundColor, ThemeData theme) {
    final bool isDarkTheme = theme.brightness == Brightness.dark;
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 4,
        intensity: 0.7,
        color: theme.cardTheme.color,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: primaryColor),
                const SizedBox(width: 8),
                Text(
                  'address'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'location_address_full'.tr,
              style: TextStyle(
                fontSize: 16,
                color: theme.textTheme.bodyLarge?.color ?? textColor,
              ),
            ),
            const SizedBox(height: 12),
            Divider(
                color:
                    isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade300),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.directions, color: primaryColor),
                const SizedBox(width: 8),
                Text(
                  'directions'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'East Riffa, Hajiyat\nKingdom of Bahrain'.tr,
              style: TextStyle(
                fontSize: 14,
                color: (theme.textTheme.bodyMedium?.color ?? textColor)
                    .withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// بناء قسم ساعات العمل
  Widget _buildOpeningHours(Color primaryColor, Color textColor,
      Color backgroundColor, ThemeData theme) {
    final bool isDarkTheme = theme.brightness == Brightness.dark;
    final hoursBgColor =
        isDarkTheme ? Colors.grey.shade800 : Colors.grey.shade100;

    return Neumorphic(
      style: NeumorphicStyle(
        depth: 4,
        intensity: 0.7,
        color: theme.cardTheme.color,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time, color: primaryColor),
                const SizedBox(width: 8),
                Text(
                  'opening_hours'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // الأحد إلى الخميس
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: hoursBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'sunday_to_thursday'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.bodyMedium?.color ?? textColor,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'weekday_hours'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.textTheme.bodyMedium?.color ?? textColor,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // الجمعة والسبت
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: hoursBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'friday_saturday'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.bodyMedium?.color ?? textColor,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'weekend_hours'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.textTheme.bodyMedium?.color ?? textColor,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// بناء قسم أزرار التواصل - تم التحديث ليكون متجاوبًا
  Widget _buildContactButtons(Color primaryColor, ThemeData theme,
      bool isSmallScreen, double screenWidth) {
    // تحديد لون خلفية الأزرار بناء على الثيم
    final bool isDarkTheme = theme.brightness == Brightness.dark;
    // تعديل لون الفونت بناء على الثيم كما هو مطلوب
    final iconTitleColor =
        isDarkTheme ? Colors.grey.shade100 : Colors.grey.shade800;
    // حساب عدد الأزرار في الصف بناءً على حجم الشاشة
    final int buttonsPerRow =
        screenWidth < 360 ? 2 : (screenWidth > 600 ? 4 : 3);

    // حساب حجم الأزرار بناءً على العرض
    final double buttonHeight =
        isSmallScreen ? 90.0 : (screenWidth > 600 ? 120.0 : 100.0);

    // تعريف أزرار التواصل
    final List<Map<String, dynamic>> contactButtons = [
      {
        'title': 'call'.tr,
        'icon': Icons.call,
        'onTap': () => _launchURL('tel:+97333223344'),
      },
      {
        'title': 'whatsapp'.tr,
        'icon': Icons.chat_bubble,
        'onTap': () => _launchURL('https://wa.me/97333223344'),
      },
      {
        'title': 'instagram'.tr,
        'icon': Icons.camera_alt,
        'onTap': () => _launchURL('https://www.instagram.com/jbrcafe.bh/'),
      },
      {
        'title': 'website'.tr,
        'icon': Icons.language,
        'onTap': () =>
            _launchURL('https://www.jbrcoffee.com'), // Will be updated later
      },
    ];

    // تنظيم الأزرار في صفوف بناءً على عدد الأزرار في الصف
    List<Widget> rows = [];
    for (var i = 0; i < contactButtons.length; i += buttonsPerRow) {
      final List<Widget> rowButtons = [];

      for (var j = i; j < i + buttonsPerRow && j < contactButtons.length; j++) {
        final button = contactButtons[j];
        rowButtons.add(
          Expanded(
            child: _buildContactButton(
              title: button['title'],
              icon: button['icon'],
              onTap: button['onTap'],
              primaryColor: primaryColor,
              theme: theme,
              isSmallScreen: isSmallScreen,
            ),
          ),
        );

        // إضافة مسافة بين الأزرار داخل الصف
        if (j < i + buttonsPerRow - 1 && j < contactButtons.length - 1) {
          rowButtons.add(const SizedBox(width: 12));
        }
      }

      // إضافة الصف كاملًا
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: rowButtons,
        ),
      );

      // إضافة مسافة بين الصفوف إذا كان هناك صف تالي
      if (i + buttonsPerRow < contactButtons.length) {
        rows.add(const SizedBox(height: 12));
      }
    }

    return SizedBox(
      height: buttonsPerRow < contactButtons.length
          ? buttonHeight * 2 + 12
          : buttonHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: rows,
      ),
    );
  }

  /// بناء زر اتصال واحد - تحديث التصميم والحجم
  Widget _buildContactButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required Color primaryColor,
    required ThemeData theme,
    required bool isSmallScreen,
  }) {
    final double iconSize = isSmallScreen ? 22.0 : 28.0;
    final double fontSize = isSmallScreen ? 12.0 : 14.0;

    return NeumorphicButton(
      style: NeumorphicStyle(
        depth: 4,
        intensity: 0.7,
        color: theme.cardTheme.color,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
      ),
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
      onPressed: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: primaryColor,
            size: iconSize,
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          Text(
            title,
            style: TextStyle(
              color: primaryColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// بناء قسم معلومات التوصيل
  Widget _buildDeliveryInfo(Color primaryColor, Color textColor,
      Color backgroundColor, ThemeData theme) {
    final bool isDarkTheme = theme.brightness == Brightness.dark;

    return Neumorphic(
      style: NeumorphicStyle(
        depth: 4,
        intensity: 0.7,
        color: theme.cardTheme.color,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.delivery_dining, color: primaryColor),
                const SizedBox(width: 8),
                Text(
                  'delivery_service'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'we_deliver_to_following_areas'.tr,
              style: TextStyle(
                fontSize: 14,
                color: (theme.textTheme.bodyMedium?.color ?? textColor)
                    .withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 12),

            // الحد الأدنى للطلب
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(isDarkTheme ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: primaryColor.withOpacity(isDarkTheme ? 0.4 : 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'minimum_order'.tr + ': 1.000 ' + 'currency'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // معلومات خدمات التوصيل - جعلها متجاوبة
            LayoutBuilder(
              builder: (context, constraints) {
                // إذا كان عرض الشاشة صغيرًا، نعرض العناصر في أعمدة
                final bool useColumn = constraints.maxWidth < 400;

                if (useColumn) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize:
                        MainAxisSize.min, // To avoid unbounded height issues
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.delivery_dining,
                            size: 16,
                            color:
                                (theme.textTheme.bodyMedium?.color ?? textColor)
                                    .withOpacity(0.6),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'delivery_service_apps_message'.tr,
                              style: TextStyle(
                                fontSize: 13,
                                color: (theme.textTheme.bodyMedium?.color ??
                                        textColor)
                                    .withOpacity(0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'order_now_from'.tr,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFFF5A00),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // أزرار الطلب
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildDeliveryButton(
                            'طلبات',
                            const Color(0xFFFF5A00),
                            'https://www.talabat.com/bahrain/restaurant/755906/jbr-cafe-alhajiyat?aid=1031',
                          ),
                          const SizedBox(width: 10),
                          _buildDeliveryButton(
                            'جاهز',
                            const Color(0xFFD30017),
                            'https://www.instagram.com/jahezbh/?locale=slot%2Bdemo%2Bpg%2Bmahjong%2B3%E3%80%90777ONE.IN%E3%80%91.dgxn&hl=en',
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  // للشاشات الكبيرة، نعرض بالتخطيط الأصلي
                  return Row(
                    children: [
                      Icon(
                        Icons.delivery_dining,
                        size: 16,
                        color: (theme.textTheme.bodyMedium?.color ?? textColor)
                            .withOpacity(0.6),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'نقدم خدمات التوصيل عبر تطبيقات جاهز وطلبات',
                              style: TextStyle(
                                fontSize: 13,
                                color: (theme.textTheme.bodyMedium?.color ??
                                        textColor)
                                    .withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text(
                                  'أطلب الآن من طلبات:',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFFF5A00),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                _buildDeliveryButton(
                                  'طلبات',
                                  const Color(0xFFFF5A00),
                                  'https://www.talabat.com/bahrain/restaurant/755906/jbr-cafe-alhajiyat?aid=1031',
                                ),
                                const SizedBox(width: 10),
                                _buildDeliveryButton(
                                  'جاهز',
                                  const Color(0xFFD30017),
                                  'https://www.instagram.com/jahezbh/?locale=slot%2Bdemo%2Bpg%2Bmahjong%2B3%E3%80%90777ONE.IN%E3%80%91.dgxn&hl=en',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // زر اختيار تطبيق التوصيل
  Widget _buildDeliveryButton(String label, Color color, String url) {
    return InkWell(
      onTap: () async {
        final launchUrl = Uri.parse(url);
        if (await canLaunchUrl(launchUrl)) {
          launchUrl;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// فتح تطبيق الخرائط
  void _openMapsApp() async {
    final Uri googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    }
  }

  /// فتح رابط URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar(
        'error'.tr,
        'cantOpen'.tr + ' $url',
      );
    }
  }
}
