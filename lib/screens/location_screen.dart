import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gpr_coffee_shop/constants/colors.dart';
import 'package:gpr_coffee_shop/screens/home_screen.dart';

/// شاشة موقع المقهى والمعلومات
class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // هنا أضفنا PopScope حول الـ Scaffold
    return PopScope(
      canPop: Navigator.of(context).canPop(),
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          Get.offAll(() => const HomeScreen());
        }
      },
      child: Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        appBar: AppBar(
          title: const Text(
            'موقعنا',
            style: TextStyle(
              color: AppColors.accent,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.accent),
            onPressed: () => Get.back(),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // صورة خريطة الموقع
                _buildMap(),
                const SizedBox(height: 24),

                // معلومات الموقع
                _buildLocationInfo(),
                const SizedBox(height: 24),

                // ساعات العمل
                _buildOpeningHours(),
                const SizedBox(height: 24),

                // أزرار التواصل
                _buildContactButtons(),
                const SizedBox(height: 24),

                // معلومات التوصيل
                _buildDeliveryInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// بناء قسم خريطة الموقع
  Widget _buildMap() {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 4,
        intensity: 0.7,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
      ),
      child: SizedBox(
        height: 200,
        child: Stack(
          children: [
            // صورة الخريطة (يمكن استبدالها بخريطة حقيقية)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/map_placeholder.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),

            // زر فتح الخريطة
            Positioned(
              right: 10,
              bottom: 10,
              child: NeumorphicButton(
                style: NeumorphicStyle(
                  depth: 2,
                  intensity: 0.7,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
                  color: AppColors.accent,
                ),
                onPressed: _openMapsApp,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      Icon(Icons.map, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'افتح في الخرائط',
                        style: TextStyle(
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
    );
  }

  /// بناء قسم معلومات الموقع
  Widget _buildLocationInfo() {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 4,
        intensity: 0.7,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.location_on, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  'عنواننا',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'مجمع السيف، المنامة، مملكة البحرين',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'الطابق الأول، بالقرب من المدخل الرئيسي',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(Icons.directions, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  'كيفية الوصول',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'يمكنك الوصول إلينا عبر مواقف السيارات الشمالية، أو من خلال المدخل الرئيسي للمجمع.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// بناء قسم ساعات العمل
  Widget _buildOpeningHours() {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 4,
        intensity: 0.7,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.access_time, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  'ساعات العمل',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildOpeningHoursRow('السبت - الخميس', '8:00 ص - 11:00 م'),
            const SizedBox(height: 8),
            _buildOpeningHoursRow('الجمعة', '2:00 م - 11:00 م'),
          ],
        ),
      ),
    );
  }

  /// بناء صف في ساعات العمل
  Widget _buildOpeningHoursRow(String days, String hours) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            days,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            hours,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  /// بناء أزرار التواصل
  Widget _buildContactButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildContactButton(
            icon: Icons.call,
            title: 'call_us'.tr,
            onTap: () => _launchPhone('+97312345678'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildContactButton(
            icon: Icons.email,
            title: 'email_us'.tr,
            onTap: () => _launchEmail('info@gprcoffee.com'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildContactButton(
            icon: Icons.chat,
            title: 'whatsapp_us'.tr,
            onTap: () => _launchWhatsapp('+97312345678'),
          ),
        ),
      ],
    );
  }

  /// بناء زر التواصل
  Widget _buildContactButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return NeumorphicButton(
      style: NeumorphicStyle(
        depth: 4,
        intensity: 0.7,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      onPressed: onTap,
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// بناء قسم معلومات التوصيل
  Widget _buildDeliveryInfo() {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 4,
        intensity: 0.7,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.delivery_dining, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  'خدمة التوصيل',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'نوفر خدمة التوصيل إلى المناطق التالية:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            _buildDeliveryArea('المنامة', '15-20 دقيقة', '1.000 د.ب'),
            _buildDeliveryArea('المحرق', '20-30 دقيقة', '2.000 د.ب'),
            _buildDeliveryArea('سار', '25-35 دقيقة', '2.000 د.ب'),
            _buildDeliveryArea('الرفاع', '30-40 دقيقة', '3.000 د.ب'),
            const SizedBox(height: 8),
            const Text(
              'الحد الأدنى للطلب: 5.000 د.ب',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'يمكنك طلب التوصيل عبر تطبيقنا أو عن طريق الاتصال بنا.',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// بناء صف في مناطق التوصيل
  Widget _buildDeliveryArea(String area, String time, String fee) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(Icons.location_city, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              area,
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              fee,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  /// فتح تطبيق الخرائط
  void _openMapsApp() async {
    // إحداثيات المقهى (مثال)
    const latitude = 26.2235;
    const longitude = 50.5876;
    const label = 'GPR Coffee Shop';

    final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude&query_place_id=$label');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar(
        'خطأ',
        'لا يمكن فتح تطبيق الخرائط',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// فتح تطبيق الهاتف للاتصال
  void _launchPhone(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  /// فتح تطبيق البريد الإلكتروني
  void _launchEmail(String email) async {
    final uri = Uri.parse('mailto:$email?subject=استفسار من تطبيق GPR Coffee');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  /// فتح تطبيق واتساب
  void _launchWhatsapp(String phoneNumber) async {
    final uri = Uri.parse('https://wa.me/$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
