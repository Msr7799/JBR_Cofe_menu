import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/settings_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appVersion = '1.0.0';
    final settingsController = Get.find<SettingsController>();
    final logoPath = settingsController.logoPath ?? 'assets/images/logo.png';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'حول البرنامج',
          style: TextStyle(
            color: AppTheme.textLightColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Logo and app name - استخدام اللوقو المختار من قِبَل المستخدم
            Center(
              child: Column(
                children: [
                  Neumorphic(
                    style: NeumorphicStyle(
                      depth: 10,
                      intensity: 0.9,
                      shape: NeumorphicShape.concave,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(20)),
                      color: Colors.white,
                      lightSource: LightSource.topLeft,
                    ),
                    child: Container(
                      width: 120,
                      height: 120,
                      padding: const EdgeInsets.all(16),
                      child: Image.asset(
                        logoPath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'JBR Coffee Shop',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 197, 184, 181),
                    ),
                  ),
                  const Text(
                    'أفضل مذاق للقهوة والمشروبات',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 216, 211, 210),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // App description
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'وصف التطبيق',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'app_description'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Developer info
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'معلومات المطور',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const ListTile(
                      leading: Icon(Icons.person, color: AppTheme.primaryColor),
                      title: Text('المطور'),
                      subtitle: Text('Mohamed S. Alromaihi'),
                      contentPadding: EdgeInsets.zero,
                    ),
                    const Divider(),
                    ListTile(
                      leading:
                          const Icon(Icons.email, color: AppTheme.primaryColor),
                      title: const Text('البريد الإلكتروني'),
                      subtitle: const Text('alromaihi2224@gmail.com'),
                      contentPadding: EdgeInsets.zero,
                      onTap: () => _launchURL('mailto:alromaihi2224@gmail.com'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Version and copyright
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'معلومات النسخة',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    SizedBox(height: 12),
                    ListTile(
                      leading: Icon(Icons.info_outline,
                          color: AppTheme.primaryColor),
                      title: Text('إصدار التطبيق'),
                      subtitle: Text(appVersion),
                      contentPadding: EdgeInsets.zero,
                    ),
                    Divider(),
                    ListTile(
                      leading:
                          Icon(Icons.copyright, color: AppTheme.primaryColor),
                      title: Text('حقوق النشر'),
                      subtitle: Text('© 2025 جميع الحقوق محفوظة JBR Cofe'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.article_outlined),
                  label: const Text('التراخيص'),
                  onPressed: () => _showLicensesDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  icon: const Icon(Icons.info),
                  label: const Text('حول النظام'),
                  onPressed: () => _showAboutDialog(context),
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    // استخدام الشعار المختار من المستخدم
    final settingsController = Get.find<SettingsController>();
    final logoPath = settingsController.logoPath ?? 'assets/images/logo.png';
    
    showDialog(
      context: context,
      builder: (context) => AboutDialog(
        applicationName: 'JBR Coffee Shop',
        applicationVersion: '1.0.0',
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

  void _showLicensesDialog(BuildContext context) {
    // استخدام الشعار المختار من المستخدم
    final settingsController = Get.find<SettingsController>();
    final logoPath = settingsController.logoPath ?? 'assets/images/logo.png';
    
    showLicensePage(
      context: context,
      applicationName: 'JBR Coffee Shop',
      applicationVersion: '1.0.0',
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
        'خطأ',
        'لا يمكن فتح $url',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
