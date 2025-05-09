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
    
    return PopScope(
      canPop: Navigator.of(context).canPop(),
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          Get.offAll(() => const HomeScreen());
        }
      },
      child: GetBuilder<SettingsController>(
        builder: (controller) {
          // Apply theme based on controller settings
          ThemeData activeTheme;
          Color primaryColor;
          Color textColor;
          Color backgroundColor;
          
          switch (controller.themeMode) {
            case 'dark':
              activeTheme = AppTheme.darkTheme;
              primaryColor = const Color(0xFFAB7F52); // Dark theme primary
// Dark theme secondary
              textColor = Colors.white;
              backgroundColor = const Color(0xFF1E1E1E);
              break;
            case 'coffee':
              activeTheme = AppTheme.coffeeTheme;
              primaryColor = AppTheme.coffeePrimaryColor;
              textColor = AppTheme.coffeePrimaryColor;
              backgroundColor = AppTheme.coffeeBackgroundColor;
              break;
            case 'sweet':
              activeTheme = AppTheme.sweetTheme;
              primaryColor = AppTheme.sweetPrimaryColor;
              textColor = AppTheme.sweetPrimaryColor;
              backgroundColor = AppTheme.sweetBackgroundColor;
              break;
            default: // light
              activeTheme = AppTheme.lightTheme;
              primaryColor = AppTheme.primaryColor;
              textColor = AppTheme.textPrimaryColor;
              backgroundColor = AppTheme.backgroundColor;
          }

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
              body: SingleChildScrollView(
                child: Padding(
                  // ضبط الهوامش بناءً على حجم الشاشة
                  padding: EdgeInsets.all(isSmallScreen ? 12 : (isLargeScreen ? 24 : 16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // صورة خريطة الموقع - ضبط ارتفاعها بناءً على حجم الشاشة
                      _buildMap(context, primaryColor, activeTheme, isLargeScreen ? 300.0 : 220.0),
                      SizedBox(height: isSmallScreen ? 16 : 24),

                      // معلومات الموقع
                      _buildLocationInfo(primaryColor, textColor, backgroundColor, activeTheme),
                      SizedBox(height: isSmallScreen ? 16 : 24),

                      // ساعات العمل
                      _buildOpeningHours(primaryColor, textColor, backgroundColor, activeTheme),
                      SizedBox(height: isSmallScreen ? 16 : 24),

                      // أزرار التواصل - تعديل الحجم وإضافة التجاوب
                      _buildContactButtons(primaryColor, activeTheme, isSmallScreen, screenSize.width),
                      SizedBox(height: isSmallScreen ? 16 : 24),

                      // معلومات التوصيل
                      _buildDeliveryInfo(primaryColor, textColor, backgroundColor, activeTheme),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// بناء قسم خريطة الموقع
  Widget _buildMap(BuildContext context, Color primaryColor, ThemeData theme, double mapHeight) {
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
                      color: theme.brightness == Brightness.dark ? 
                        Colors.black.withOpacity(0.7) :
                        Colors.white.withOpacity(0.7),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.map, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'open_in_maps'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
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
  Widget _buildLocationInfo(Color primaryColor, Color textColor, Color backgroundColor, ThemeData theme) {
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
              'الرفاع الشرقي، مملكة البحرين',
              style: TextStyle(
                fontSize: 16,
                color: theme.textTheme.bodyLarge?.color ?? textColor,
              ),
            ),
            const SizedBox(height: 12),
            Divider(color: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade300),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.directions, color: primaryColor),
                const SizedBox(width: 8),
                Text(
                  'directions'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'يمكنك الوصول إلينا عبر الطرق الرئيسية في الرفاع الشرقي ويمكنكم الطريق برنامج جاهز أو طلبات للتوصيل',
              style: TextStyle(
                fontSize: 14,
                color: (theme.textTheme.bodyMedium?.color ?? textColor).withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// بناء قسم ساعات العمل
  Widget _buildOpeningHours(Color primaryColor, Color textColor, Color backgroundColor, ThemeData theme) {
    final bool isDarkTheme = theme.brightness == Brightness.dark;
    final hoursBgColor = isDarkTheme ? Colors.grey.shade800 : Colors.grey.shade100;

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
                    flex: 5,
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: primaryColor, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'الأحد إلي الخميس',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.titleMedium?.color ?? textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.access_time, color: primaryColor, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'ص - 1:00 ص 6:00',
                          style: TextStyle(
                            color: (theme.textTheme.bodyMedium?.color ?? textColor).withOpacity(0.8),
                          ),
                        ),
                      ],
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
                    flex: 5,
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: primaryColor, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'الجمعة والسبت',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.titleMedium?.color ?? textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.access_time, color: primaryColor, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          '8:00 ص - 1:00 ص',
                          style: TextStyle(
                            color: (theme.textTheme.bodyMedium?.color ?? textColor).withOpacity(0.8),
                          ),
                        ),
                      ],
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
  Widget _buildContactButtons(Color primaryColor, ThemeData theme, bool isSmallScreen, double screenWidth) {
    // حساب عدد الأزرار في الصف بناءً على حجم الشاشة
    final int buttonsPerRow = screenWidth < 360 ? 2 : (screenWidth > 600 ? 4 : 3);
    
    // حساب حجم الأزرار بناءً على العرض
    final double buttonHeight = isSmallScreen ? 90.0 : (screenWidth > 600 ? 120.0 : 100.0);
    
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
        'onTap': () => _launchURL('https://www.instagram.com/jbrcafe/'),
      },
      {
        'title': 'الموقع الإلكتروني',
        'icon': Icons.language,
        'onTap': () => _launchURL('https://www.jbrcoffee.com'), // سيتم تحديث الرابط لاحقًا
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
      height: buttonsPerRow < contactButtons.length ? buttonHeight * 2 + 12 : buttonHeight,
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
  Widget _buildDeliveryInfo(Color primaryColor, Color textColor, Color backgroundColor, ThemeData theme) {
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
                color: (theme.textTheme.bodyMedium?.color ?? textColor).withOpacity(0.8),
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
                    'الحد الأدنى للطلب: 1.000 د.ب',
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
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.delivery_dining, 
                            size: 16, 
                            color: (theme.textTheme.bodyMedium?.color ?? textColor).withOpacity(0.6),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'نقدم خدمات التوصيل عبر تطبيقات جاهز وطلبات',
                              style: TextStyle(
                                fontSize: 13,
                                color: (theme.textTheme.bodyMedium?.color ?? textColor).withOpacity(0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'أطلب الآن من:',
                        style: TextStyle(
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
                        color: (theme.textTheme.bodyMedium?.color ?? textColor).withOpacity(0.6),
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
                                color: (theme.textTheme.bodyMedium?.color ?? textColor).withOpacity(0.8),
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
        'خطأ'.tr,
        'لا يمكن فتح $url'.tr,
      );
    }
  }
}
