import 'dart:io';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/settings_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:gpr_coffee_shop/screens/admin/login_screen.dart';
import 'package:gpr_coffee_shop/screens/home_screen.dart';
import 'package:gpr_coffee_shop/models/app_settings.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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
              mainAxisSize:
                  MainAxisSize.min, // To avoid unbounded height issues
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
                _buildSectionHeader('app_logo'.tr),
                _buildCard(
                  child: _buildLogoSelector(),
                ),

                const SizedBox(height: 24),

                // Background settings section
                _buildSectionHeader('home_background'.tr),
                _buildCard(
                  child: _buildBackgroundSettings(),
                ),

                const SizedBox(height: 24),

                // قسم لون الخط في التطبيق
                _buildSectionHeader('text_color'.tr),
                _buildFontColorSelector(),

                const SizedBox(height: 24),

                // Admin panel section
                _buildSectionHeader('admin'.tr),
                _buildCard(
                  child: ListTile(
                    leading: const Icon(Icons.admin_panel_settings, size: 24),
                    title: Text('adminPanel'.tr),
                    subtitle: Text('accessAdmin'.tr),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => Get.to(() => const LoginScreen()),
                  ),
                ),

                const SizedBox(height: 24),

                // View options section
                _buildSectionHeader('view_options'.tr),
                _buildCard(
                  child: ListTile(
                    leading: const Icon(Icons.visibility,
                        color: AppTheme.primaryColor),
                    title: Text('view_options'.tr),
                    subtitle: Text('customize_display'.tr),
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
                        title: Text('contact_developer'.tr),
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
            crossAxisCount: 4,
            childAspectRatio: 0.7,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
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
    Color textColor;

    // تحديد ألوان مصغرة لكل ثيم - تبسيط إلى 4 ثيمات فقط
    switch (themeKey) {
      case 'light':
        primaryColor = AppTheme.lightPrimaryColor;
        backgroundColor = AppTheme.lightBackgroundColor;
        accentColor = AppTheme.lightAccentColor;
        textColor = AppTheme.textPrimaryColor; // لون داكن
        break;
      case 'dark':
        primaryColor = AppTheme.darkPrimaryColor;
        backgroundColor = AppTheme.darkBackgroundColor;
        accentColor = AppTheme.darkAccentColor;
        textColor = AppTheme.textLightColor; // لون فاتح
        break;
      case 'grey':
        primaryColor = AppTheme.greyPrimaryColor;
        backgroundColor = AppTheme.greyBackgroundColor;
        accentColor = AppTheme.greyAccentColor;
        textColor = AppTheme.textLightColor; // لون فاتح
        break;
      case 'maroon':
        primaryColor = AppTheme.maroonPrimaryColor;
        backgroundColor = AppTheme.maroonBackgroundColor;
        accentColor = AppTheme.maroonAccentColor;
        textColor = AppTheme.textPrimaryColor; // لون داكن
        break;
      default:
        primaryColor = AppTheme.lightPrimaryColor;
        backgroundColor = AppTheme.lightBackgroundColor;
        accentColor = AppTheme.lightAccentColor;
        textColor = AppTheme.textPrimaryColor;
    }

    // تحديث طريقة العرض لاستخدام textColor المناسب
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
                    .withValues(alpha: 76, red: 158, green: 158, blue: 158),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(
                        alpha: 76,
                        red: primaryColor.r.toDouble(),
                        green: primaryColor.g.toDouble(),
                        blue: primaryColor.b.toDouble()),
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
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                // استخدام textColor المناسب لكل ثيم
                color: themeKey == 'dark' || themeKey == 'grey'
                    ? Colors.white
                    : Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            if (isSelected)
              Icon(
                Icons.check_circle,
                // استخدام لون متوافق مع الثيم
                color: themeKey == 'dark' || themeKey == 'grey'
                    ? Colors.white70
                    : primaryColor,
                size: 16,
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
            border: Border.all(
                color: Colors.grey
                    .withValues(alpha: 100, red: 158, green: 158, blue: 158)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _buildBackgroundPreview(),
          ),
        ),

        // Background type selection - radios
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('نوع الخلفية'),
          subtitle: Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('افتراضي'),
                selected: settingsController.backgroundType ==
                    BackgroundType.default_bg,
                onSelected: (selected) {
                  if (selected) {
                    settingsController
                        .setBackgroundType(BackgroundType.default_bg);
                  }
                },
              ),
              ChoiceChip(
                label: const Text('لون'),
                selected:
                    settingsController.backgroundType == BackgroundType.color,
                onSelected: (selected) {
                  if (selected) {
                    settingsController.setBackgroundType(BackgroundType.color);
                  }
                },
              ),
              ChoiceChip(
                label: const Text('صورة'),
                selected:
                    settingsController.backgroundType == BackgroundType.image,
                onSelected: (selected) {
                  // تحديد خلفية صورة، إذا لم تكن الصورة موجودة، سيُطلب من المستخدم اختيار صورة
                  if (settingsController.backgroundImagePath == null ||
                      !File(settingsController.backgroundImagePath!)
                          .existsSync()) {
                    settingsController.pickAndSetBackgroundImage();
                  } else {
                    settingsController.setBackgroundType(BackgroundType.image);
                  }
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // The content changes based on the selected background type
        if (settingsController.backgroundType == BackgroundType.color) ...[
          // Color selection with Color Picker
          const Text(
            'اختر لوناً للخلفية',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),

          Center(
            child: GestureDetector(
              onTap: () => _showColorPickerDialog(
                context: context,
                currentColor: settingsController.backgroundColor,
                onColorChanged: (Color color) {
                  settingsController.setBackgroundColor(color);
                },
                title: 'اختر لون الخلفية',
              ),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: settingsController.backgroundColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.colorize,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],

        if (settingsController.backgroundType == BackgroundType.image) ...[
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.image),
              label: Text('اختر صورة أخرى'.tr),
              onPressed: () => settingsController.pickAndSetBackgroundImage(),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],

        const SizedBox(height: 24),

        // Text color settings
        const Text(
          'لون النص',
          style: TextStyle(fontWeight: FontWeight.w500),
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
          child: Center(
            child: GestureDetector(
              onTap: settingsController.autoTextColor
                  ? null
                  : () => _showColorPickerDialog(
                        context: context,
                        currentColor: settingsController.textColor,
                        onColorChanged: (Color color) {
                          if (!settingsController.autoTextColor) {
                            settingsController.setTextColor(color, false);
                          }
                        },
                        title: 'اختر لون النص',
                      ),
              child: Container(
                width: 60,
                height: 60,
                margin: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: settingsController.textColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.format_color_text,
                  color: settingsController.textColor.computeLuminance() > 0.5
                      ? Colors.black
                      : Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

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

  // إضافة دالة لعرض مربع حوار اختيار اللون - مع إصلاح مشكلة الـ GlobalKey
  void _showColorPickerDialog({
    required BuildContext context,
    required Color currentColor,
    required Function(Color) onColorChanged,
    required String title,
  }) {
    Color pickerColor = currentColor;

    // استخدم Builder لإنشاء سياق جديد لكل مربع حوار لتجنب مشكلة GlobalKey
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // استخدام Builder لتوفير سياق جديد لـ ColorPicker
        return AlertDialog(
          title: Text(title),
          content: Builder(
            builder: (BuildContext pickerContext) {
              return SingleChildScrollView(
                // استخدام key فريد لكل مثيل من ColorPicker
                key: UniqueKey(),
                child: ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: (color) {
                    pickerColor = color;
                  },
                  pickerAreaHeightPercent: 0.8,
                  enableAlpha: true,
                  displayThumbColor: true,
                  paletteType: PaletteType.hsvWithHue,
                  labelTypes: const [
                    ColorLabelType.rgb,
                    ColorLabelType.hsv,
                    ColorLabelType.hsl,
                    ColorLabelType.hex,
                  ],
                  pickerAreaBorderRadius:
                      const BorderRadius.all(Radius.circular(10)),
                  hexInputBar: true,
                  portraitOnly: true,
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                onColorChanged(pickerColor);
                Navigator.of(dialogContext).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('تأكيد'),
            ),
          ],
        );
      },
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
                    color: Colors.black
                        .withValues(alpha: 150, red: 0, green: 0, blue: 0),
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

  // تحسين دالة _buildLogoSelector

  Widget _buildLogoSelector() {
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

    // استخدام متغير currentLogo بدلاً من إعادة استعلامه عدة مرات
    final String currentLogo =
        settingsController.logoPath ?? 'assets/images/logo.png';
    final bool isCustomLogo = !currentLogo.startsWith('assets/');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عنوان القسم
        const Text(
          'اختيار شعار التطبيق',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        // معاينة الشعار الحالي
        Center(
          child: Neumorphic(
            style: const NeumorphicStyle(
              depth: 8,
              intensity: 0.7,
              boxShape: NeumorphicBoxShape.circle(),
              lightSource: LightSource.topLeft,
              color: Colors.white,
            ),
            child: GestureDetector(
              onTap: () =>
                  _showLogoSelectionDialog(availableLogos, currentLogo),
              child: Container(
                width: 100,
                height: 100,
                padding: const EdgeInsets.all(8),
                child: Builder(builder: (context) {
                  // عرض الشعار الحالي
                  if (isCustomLogo) {
                    // للصور المخصصة من نظام الملفات
                    final file = File(currentLogo);
                    if (!file.existsSync()) {
                      return Image.asset('assets/images/logo.png',
                          fit: BoxFit.contain);
                    }
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.file(
                        file,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/images/logo.png',
                              fit: BoxFit.contain);
                        },
                      ),
                    );
                  } else {
                    // للصور من موارد التطبيق
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        currentLogo,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/images/logo.png',
                              fit: BoxFit.contain);
                        },
                      ),
                    );
                  }
                }),
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),
        Center(
          child: Column(
            children: [
              Text(
                'الشعار الحالي',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              if (isCustomLogo)
                Text(
                  'شعار مخصص',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // نص توجيهي
        Center(
          child: Text(
            'اضغط على الشعار لتغييره',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // زر استعادة الشعار الافتراضي
        if (isCustomLogo)
          Center(
            child: TextButton.icon(
              onPressed: () {
                settingsController.setLogoPath('assets/images/logo.png');
              },
              icon: const Icon(Icons.restore, size: 18),
              label: const Text('استعادة الشعار الافتراضي'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade700,
              ),
            ),
          ),
      ],
    );
  }

  // إضافة دالة لعرض نافذة اختيار اللوغو
  void _showLogoSelectionDialog(
      List<String> availableLogos, String currentLogo) {
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
            // استخدام ارتفاع معقول لا يتجاوز 70% من الشاشة
            height: MediaQuery.of(context).size.height * 0.7,
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
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount:
                        availableLogos.length + 1, // +1 لزر التحميل المخصص
                    itemBuilder: (context, index) {
                      if (index == availableLogos.length) {
                        // خيار تحميل شعار مخصص
                        return GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);
                            await Future.delayed(
                                const Duration(milliseconds: 300));
                            await settingsController.pickAndSetCustomLogo();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  size: 40,
                                  color: AppTheme.primaryColor,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'تحميل صورة',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final logoPath = availableLogos[index];
                      final isSelected = currentLogo == logoPath;

                      return GestureDetector(
                        onTap: () {
                          settingsController.setLogoPath(logoPath);
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                logoPath,
                                fit: BoxFit.contain,
                              ),
                              if (isSelected)
                                Positioned(
                                  right: 5,
                                  bottom: 5,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: AppTheme.primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),
                Center(
                  child: TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: const Text('إغلاق'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
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

  // دالة لإنشاء عنصر اختيار اللون
  Widget _buildColorPickerItem({
    required String title,
    required Color currentColor,
    required Function(Color) onColorChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 2,
          intensity: 0.8,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
        ),
        child: ListTile(
          title: Text(title),
          trailing: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: currentColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
          ),
          onTap: () {
            Get.dialog(
              AlertDialog(
                title: Text(title),
                content: Builder(
                  builder: (BuildContext pickerContext) {
                    return SingleChildScrollView(
                      key:
                          UniqueKey(), // استخدام key فريد لكل مثيل من ColorPicker
                      child: ColorPicker(
                        pickerColor: currentColor,
                        onColorChanged: onColorChanged,
                        pickerAreaHeightPercent: 0.8,
                        enableAlpha: true,
                        displayThumbColor: true,
                        labelTypes: const [
                          ColorLabelType.rgb,
                          ColorLabelType.hex
                        ],
                        paletteType: PaletteType.hsv,
                      ),
                    );
                  },
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('حفظ'),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // إضافة قسم جديد في دالة build للكلاس _SettingsScreenState
  Widget _buildFontColorSelector() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'لون الخطوط في التطبيق',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // عرض اللون الحالي
          Row(
            children: [
              const Text(
                'لون الخط الحالي: ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: settingsController.textColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // زر لفتح منتقي الألوان
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.color_lens),
              label: const Text('تغيير لون الخط'),
              onPressed: () => _showColorPickerDialog(
                context: context,
                currentColor: settingsController.textColor,
                onColorChanged: (Color color) {
                  settingsController.setTextColor(color, false);
                },
                title: 'اختر لون الخط',
              ),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // نص تنبيهي للمستخدم
          Text(
            'ملاحظة: هذا التغيير سيطبق على جميع شاشات التطبيق ماعدا الشاشة الرئيسية.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
