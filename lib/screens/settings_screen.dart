import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/settings_controller.dart';
import 'package:gpr_coffee_shop/models/app_settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsController settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('الإعدادات'),
          centerTitle: true,
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: Obx(
          () => settingsController.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : Container(
                  color: AppTheme.backgroundColor,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 600) {
                        return _buildWideLayout();
                      } else {
                        return _buildNarrowLayout();
                      }
                    },
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildWideLayout() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildLanguageSection(),
                SizedBox(height: 16),
                _buildAppearanceSection(),
              ],
            ),
          ),
        ),
        VerticalDivider(color: Colors.grey.shade300),
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSocialMediaSection(),
                SizedBox(height: 16),
                _buildPaymentSection(),
                SizedBox(height: 16),
                _buildAboutSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildLanguageSection(),
        SizedBox(height: 16),
        _buildAppearanceSection(),
        SizedBox(height: 16),
        _buildSocialMediaSection(),
        SizedBox(height: 16),
        _buildPaymentSection(),
        SizedBox(height: 16),
        _buildAboutSection(),
      ],
    );
  }

  Widget _buildLanguageSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'اللغة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            RadioListTile<String>(
              title: Text('العربية'),
              value: 'ar',
              groupValue: settingsController.settings.value.language,
              onChanged: (value) => settingsController.updateLanguage(value!),
              activeColor: AppTheme.primaryColor,
            ),
            RadioListTile<String>(
              title: Text('English'),
              value: 'en',
              groupValue: settingsController.settings.value.language,
              onChanged: (value) => settingsController.updateLanguage(value!),
              activeColor: AppTheme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppearanceSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'المظهر',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            SizedBox(height: 16),
            Text('حجم الخط'),
            Slider(
              value: settingsController.settings.value.fontSize,
              min: 0.8,
              max: 1.4,
              divisions: 6,
              label: settingsController.settings.value.fontSize.toStringAsFixed(1),
              onChanged: (value) => settingsController.updateFontSize(value),
              activeColor: AppTheme.primaryColor,
            ),
            SizedBox(height: 16),
            Text('النمط'),
            Wrap(
              spacing: 8,
              children: [
                _buildThemeOption('فاتح', 'light'),
                _buildThemeOption('داكن', 'dark'),
                _buildThemeOption('بني', 'brown'),
                _buildThemeOption('مميز', 'custom'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(String label, String value) {
    final isSelected = settingsController.settings.value.theme == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      onSelected: (selected) {
        if (selected) {
          settingsController.updateTheme(value);
        }
      },
    );
  }

  Widget _buildSocialMediaSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'حسابات التواصل الاجتماعي',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            SizedBox(height: 16),
            _buildSocialMediaPlatform('Instagram', 'instagram'),
            _buildSocialMediaPlatform('TikTok', 'tiktok'),
            _buildSocialMediaPlatform('WhatsApp', 'whatsapp'),
            _buildSocialMediaPlatform('Snapchat', 'snapchat'),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaPlatform(String label, String platform) {
    final account = settingsController.settings.value.socialAccounts[platform];
    return Column(
      children: [
        SwitchListTile(
          title: Text(label),
          value: account?.isActive ?? false,
          activeColor: AppTheme.primaryColor,
          onChanged: (value) {
            settingsController.updateSocialAccount(
              SocialMediaAccount(
                platform: platform,
                isActive: value,
                url: account?.url ?? '',
              ),
            );
          },
        ),
        if (account?.isActive ?? false)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'رابط $label',
                hintText: 'أدخل رابط حسابك',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.primaryColor),
                ),
              ),
              onChanged: (value) {
                settingsController.updateSocialAccount(
                  SocialMediaAccount(
                    platform: platform,
                    isActive: true,
                    url: value,
                  ),
                );
              },
              initialValue: account?.url ?? '',
            ),
          ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildPaymentSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إعدادات الدفع',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'البريد الإلكتروني لحساب BenefitPay',
                hintText: 'أدخل البريد الإلكتروني',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.primaryColor),
                ),
              ),
              onChanged: settingsController.updateBenefitEmail,
              initialValue: settingsController.settings.value.benefitEmail ?? '',
            ),
            SizedBox(height: 16),
            if (settingsController.settings.value.benefitEmail?.isNotEmpty ?? false)
              Center(
                child: Text(
                  'يمكنك توليد رمز QR للدفع من خلال تطبيق BenefitPay',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'عن التطبيق',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('عن المطور'),
              subtitle: Text('تم تطوير التطبيق بواسطة GPR Software Solutions'),
              onTap: () async {
                final url = Uri.parse('https://gpr.com');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.verified_user_outlined),
              title: Text('رقم الترخيص'),
              subtitle: Text(settingsController.settings.value.licenseNumber),
            ),
            ListTile(
              leading: Icon(Icons.new_releases_outlined),
              title: Text('رقم الإصدار'),
              subtitle: Text(settingsController.settings.value.appVersion),
            ),
          ],
        ),
      ),
    );
  }
}
