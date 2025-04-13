import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/settings_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:gpr_coffee_shop/screens/admin/login_screen.dart';
import 'package:gpr_coffee_shop/screens/home_screen.dart';
import 'package:gpr_coffee_shop/models/app_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsController settingsController = Get.find<SettingsController>();
  final appVersion = '1.0.0';

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Navigator.of(context).canPop(),
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          Get.offAll(() => const HomeScreen());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'settings'.tr,
            style: const TextStyle(
              color: AppTheme.textLightColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          if (settingsController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App appearance section
                _buildSectionHeader('appearance'.tr),
                _buildCard(
                  child: Column(
                    children: [
                      _buildThemeSelector(),
                      const Divider(height: 16),
                      _buildLanguageSelector(),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Logo settings section - New section for logo selection
                _buildSectionHeader('شعار التطبيق'),
                _buildCard(
                  child: _buildLogoSelector(),
                ),

                const SizedBox(height: 24),

                // Background settings section
                _buildSectionHeader('خلفية الشاشة الرئيسية'),
                _buildCard(
                  child: _buildBackgroundSettings(),
                ),

                const SizedBox(height: 24),

                // Admin panel section
                _buildSectionHeader('admin'.tr),
                _buildCard(
                  child: ListTile(
                    leading: const Icon(Icons.admin_panel_settings, size: 24),
                    title: Text('adminPanel'.tr),
                    subtitle: Text('accessAdmin'.tr),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => Get.to(() => LoginScreen()),
                  ),
                ),

                const SizedBox(height: 24),

                // View options section
                _buildSectionHeader('خيارات العرض'),
                _buildCard(
                  child: ListTile(
                    leading: const Icon(Icons.visibility,
                        color: AppTheme.primaryColor),
                    title: Text('خيارات العرض'.tr),
                    subtitle: Text('تخصيص طريقة عرض قائمة المنتجات'.tr),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => Get.toNamed('/view-options'),
                  ),
                ),

                const SizedBox(height: 24),

                // About section
                _buildSectionHeader('about'.tr),
                _buildCard(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: Text('aboutApp'.tr),
                        onTap: () => _showAboutDialog(),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.code),
                        title: Text('developer'.tr),
                        subtitle: const Text('Mohamed S. Alromaihi'),
                        onTap: () =>
                            _launchURL('mailto:alromaihi2224@gmail.com'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: const Text('تواصل مع المطور'),
                        subtitle: const Text('alromaihi2224@gmail.com'),
                        onTap: () =>
                            _launchURL('mailto:alromaihi2224@gmail.com'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.description_outlined),
                        title: Text('licenses'.tr),
                        onTap: () => _showLicensesDialog(),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.update),
                        title: Text('version'.tr),
                        subtitle: Text(appVersion),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 8, left: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }

  Widget _buildThemeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'theme'.tr,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                4, // تغيير من 3 إلى 4 لوضع الثيمات الأربعة في صف واحد
            childAspectRatio: 0.7, // تعديل النسبة لجعل البطاقات أطول قليلاً
            crossAxisSpacing: 6, // تقليل المسافة بين البطاقات
            mainAxisSpacing: 6, // تقليل المسافة بين الصفوف
          ),
          itemCount: settingsController.availableThemes.length,
          itemBuilder: (context, index) {
            final theme = settingsController.availableThemes[index];
            final isSelected = settingsController.themeMode == theme['key'];
            return _buildThemeCard(
              title: theme['name']!,
              themeKey: theme['key']!,
              isSelected: isSelected,
            );
          },
        ),
      ],
    );
  }

  Widget _buildThemeCard({
    required String title,
    required String themeKey,
    required bool isSelected,
  }) {
    Color primaryColor;
    Color backgroundColor;
    Color accentColor;

    // تحديد ألوان مصغرة لكل ثيم
    switch (themeKey) {
      case 'light':
        primaryColor = AppTheme.primaryColor;
        backgroundColor = AppTheme.backgroundColor;
        accentColor = AppTheme.accentColor;
        break;
      case 'dark':
        primaryColor = const Color(0xFF9FA8DA);
        backgroundColor = const Color(0xFF121212);
        accentColor = const Color(0xFFFFAB91);
        break;
      case 'coffee':
        primaryColor = AppTheme.coffeePrimaryColor;
        backgroundColor = AppTheme.coffeeBackgroundColor;
        accentColor = AppTheme.coffeeSecondaryColor;
        break;
      case 'sweet':
        primaryColor = AppTheme.sweetPrimaryColor;
        backgroundColor = AppTheme.sweetBackgroundColor;
        accentColor = AppTheme.sweetSecondaryColor;
        break;
      default:
        primaryColor = AppTheme.primaryColor;
        backgroundColor = AppTheme.backgroundColor;
        accentColor = AppTheme.accentColor;
    }

    return GestureDetector(
      onTap: () => settingsController.setThemeMode(themeKey),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? primaryColor
                : Colors.grey
                    .withAlpha(76), // Fixed: Changed from withOpacity(0.3)
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor
                        .withAlpha(76), // Fixed: Changed from withOpacity(0.3)
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // معاينة مصغرة للثيم
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20, // Reduced from 30
                  height: 20, // Reduced from 30
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6), // Reduced from 8
                Container(
                  width: 20, // Reduced from 30
                  height: 20, // Reduced from 30
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6), // Reduced from 8
            Text(
              title,
              style: TextStyle(
                fontSize: 12, // Reduced from 14
                fontWeight: FontWeight.bold,
                color: themeKey == 'dark' ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3), // Reduced from 4
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: primaryColor,
                size: 16, // Reduced from 20
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'language'.tr,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        RadioListTile<String>(
          title: const Text('العربية'),
          value: 'ar',
          groupValue: settingsController.language,
          onChanged: (value) => settingsController.setLanguage(value!),
          contentPadding: EdgeInsets.zero,
          activeColor: AppTheme.primaryColor,
        ),
        RadioListTile<String>(
          title: const Text('English'),
          value: 'en',
          groupValue: settingsController.language,
          onChanged: (value) => settingsController.setLanguage(value!),
          contentPadding: EdgeInsets.zero,
          activeColor: AppTheme.primaryColor,
        ),
      ],
    );
  }

  Widget _buildBackgroundSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'background_settings'.tr,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Background preview
        Container(
          height: 150,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withAlpha(100)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _buildBackgroundPreview(),
          ),
        ),

        // Color selection
        Text(
          'choose_color'.tr,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...settingsController.predefinedBackgroundColors.map(
                (color) => GestureDetector(
                  onTap: () => settingsController.setBackgroundColor(color),
                  child: Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: settingsController.backgroundColor == color &&
                                settingsController.backgroundType ==
                                    BackgroundType.color
                            ? AppTheme.primaryColor
                            : Colors.grey.withAlpha(100),
                        width: settingsController.backgroundColor == color &&
                                settingsController.backgroundType ==
                                    BackgroundType.color
                            ? 3
                            : 1,
                      ),
                    ),
                    child: settingsController.backgroundColor == color &&
                            settingsController.backgroundType ==
                                BackgroundType.color
                        ? const Icon(Icons.check, color: AppTheme.primaryColor)
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Text color settings
        Text(
          'text_color'.tr,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),

        // Auto text color switch
        SwitchListTile(
          title: Text(
            'auto_text_color'.tr,
            style: const TextStyle(fontSize: 14),
          ),
          value: settingsController.autoTextColor,
          onChanged: (value) {
            // If turning on auto text color, also update the text color
            if (value) {
              final adaptiveColor = settingsController
                  .getAdaptiveTextColor(settingsController.backgroundColor);
              settingsController.setTextColor(adaptiveColor, true);
            } else {
              // Just update the auto setting, keep current color
              settingsController.setTextColor(
                  settingsController.textColor, false);
            }
          },
          activeColor: AppTheme.primaryColor,
        ),

        // Manual text color selection (only enabled when auto is off)
        Opacity(
          opacity: settingsController.autoTextColor ? 0.5 : 1.0,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...settingsController.predefinedTextColors.map(
                  (color) => GestureDetector(
                    onTap: settingsController.autoTextColor
                        ? null
                        : () => settingsController.setTextColor(color, false),
                    child: Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: settingsController.textColor == color &&
                                  !settingsController.autoTextColor
                              ? AppTheme.primaryColor
                              : Colors.grey.withAlpha(100),
                          width: settingsController.textColor == color &&
                                  !settingsController.autoTextColor
                              ? 3
                              : 1,
                        ),
                      ),
                      child: settingsController.textColor == color &&
                              !settingsController.autoTextColor
                          ? Icon(
                              Icons.check,
                              color: color == Colors.white
                                  ? Colors.black
                                  : Colors.white,
                            )
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Image upload button
        Center(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.image),
            label: Text('pick_background_image'.tr),
            onPressed: () => settingsController.pickAndSetBackgroundImage(),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Reset button
        Center(
          child: TextButton.icon(
            icon: const Icon(Icons.restore),
            label: Text('reset_to_default'.tr),
            onPressed: () => settingsController.resetToDefaultBackground(),
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundPreview() {
    switch (settingsController.backgroundType) {
      case BackgroundType.default_bg:
        return Stack(
          children: [
            // Default gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF7D6E83),
                    Color(0xFFD0B8A8),
                    Color(0xFFF8EDE3),
                  ],
                ),
              ),
            ),
            // Default background image
            Opacity(
              opacity: 0.15,
              child: Image.asset(
                'assets/images/JBRbg1.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Center(
              child: Text(
                'Default'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );

      case BackgroundType.color:
        return Container(
          color: settingsController.backgroundColor,
          child: Center(
            child: Text(
              'Custom Color'.tr,
              style: TextStyle(
                color:
                    settingsController.backgroundColor.computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );

      case BackgroundType.image:
        final imagePath = settingsController.backgroundImagePath;
        if (imagePath != null && File(imagePath).existsSync()) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                File(imagePath),
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(150),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Custom Image'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: Text(
              'Image Not Available'.tr,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
    }
  }

  // دالة لعرض واجهة اختيار اللوقو
  Widget _buildLogoSelector() {
    // قائمة شعارات التطبيق المتوفرة - اقتصرت على 3 شعارات فقط
    final List<String> availableLogos = [
      'assets/images/logo.png',
      'assets/images/JBR.png',
      'assets/images/JBR1.png',
    ];

    // الحصول على مسار الشعار الحالي
    final currentLogo = settingsController.logoPath ?? 'assets/images/logo.png';

    // التحقق مما إذا كان اللوقو الحالي هو لوقو مخصص
    bool isCustomLogo = currentLogo.contains('custom_logo_');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عنوان القسم
        Text(
          'اختيار شعار التطبيق',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        // معاينة الشعار الحالي - تم تصغير الحجم
        Center(
          child: Column(
            children: [
              Container(
                width: 80, // تم تصغير الحجم من 100 إلى 80
                height: 80, // تم تصغير الحجم من 100 إلى 80
                padding: const EdgeInsets.all(6), // تصغير الحشو
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: isCustomLogo
                    ? Image.file(
                        File(currentLogo),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          // إظهار شعار افتراضي في حالة وجود خطأ
                          return Image.asset('assets/images/logo.png',
                              fit: BoxFit.contain);
                        },
                      )
                    : Image.asset(
                        currentLogo,
                        fit: BoxFit.contain,
                      ),
              ),
              const SizedBox(height: 6),
              Text(
                'الشعار الحالي',
                style: TextStyle(
                  fontSize: 11, // تصغير حجم النص
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16), // تقليل المسافة
        Text(
          'اختر شعاراً آخر:',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10), // تقليل المسافة

        // عرض الشعارات المتاحة في صف واحد
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: availableLogos.map((logo) {
            final isSelected = currentLogo == logo;

            return GestureDetector(
              onTap: () => settingsController.setLogoPath(logo),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                padding: const EdgeInsets.all(6),
                child: Stack(
                  children: [
                    Center(
                      child: Image.asset(
                        logo,
                        fit: BoxFit.contain,
                      ),
                    ),
                    if (isSelected)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(2),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12, // تم تصغير حجم الأيقونة
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 16),

        // زر لتحميل شعار مخصص - تم تفعيله
        Center(
          child: ElevatedButton.icon(
            onPressed: () => settingsController.pickAndSetCustomLogo(),
            icon: const Icon(Icons.add_photo_alternate, size: 18),
            label: const Text('تحميل شعار مخصص'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  void _showAboutDialog() {
    // استخدام الشعار المحدد من قبل المستخدم
    final logoPath = settingsController.logoPath ?? 'assets/images/logo.png';

    showDialog(
      context: context,
      builder: (context) => AboutDialog(
        applicationName: 'JBR Coffee Shop',
        applicationVersion: appVersion,
        applicationIcon: Image.asset(
          logoPath,
          width: 48,
          height: 48,
        ),
        applicationLegalese: '© 2025 جميع الحقوق محفوظة JBR Cofe',
        children: [
          const SizedBox(height: 16),
          Text(
            'app_description'.tr,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showLicensesDialog() {
    // استخدام الشعار المحدد من قبل المستخدم
    final logoPath = settingsController.logoPath ?? 'assets/images/logo.png';

    showLicensePage(
      context: context,
      applicationName: 'JBR Coffee Shop',
      applicationVersion: appVersion,
      applicationIcon: Image.asset(
        logoPath,
        width: 48,
        height: 48,
      ),
      applicationLegalese: '© 2025 جميع الحقوق محفوظة',
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar(
        'خطأ'.tr,
        'لا يمكن فتح $url'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
