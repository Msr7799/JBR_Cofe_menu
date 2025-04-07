import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/controllers/settings_controller.dart';
import 'package:gpr_coffee_shop/widgets/custom_app_bar.dart';

class ViewOptionsScreen extends StatelessWidget {
  final SettingsController settingsController = Get.find<SettingsController>();

  ViewOptionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'view_options'.tr,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('display_options'.tr),
            const SizedBox(height: 12),
            _buildThemeSelector(),
            const SizedBox(height: 24),
            _buildSectionTitle('text_size'.tr),
            const SizedBox(height: 12),
            _buildTextSizeSelector(),
            const SizedBox(height: 24),
            _buildSectionTitle('layout_options'.tr),
            const SizedBox(height: 12),
            _buildLayoutOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildThemeSelector() {
    return GetBuilder<SettingsController>(
      builder: (controller) {
        return Column(
          children: [
            _buildThemeOption('light', 'light_theme'.tr, Icons.light_mode),
            _buildThemeOption('dark', 'dark_theme'.tr, Icons.dark_mode),
            _buildThemeOption('coffee', 'coffee_theme'.tr, Icons.coffee),
            _buildThemeOption('sweet', 'sweet_theme'.tr, Icons.cake),
            _buildThemeOption(
                'system', 'system_theme'.tr, Icons.settings_system_daydream),
          ],
        );
      },
    );
  }

  Widget _buildThemeOption(String value, String title, IconData icon) {
    return Obx(() {
      final isSelected = settingsController.themeMode == value;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: NeumorphicButton(
          style: NeumorphicStyle(
            depth: isSelected ? -3 : 3,
            intensity: 0.7,
            color: isSelected ? Get.theme.colorScheme.primaryContainer : null,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          onPressed: () => settingsController.setThemeMode(value),
          child: Row(
            children: [
              Icon(icon, size: 24),
              const SizedBox(width: 16),
              Text(title, style: const TextStyle(fontSize: 16)),
              const Spacer(),
              if (isSelected) const Icon(Icons.check, color: Colors.green),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTextSizeSelector() {
    return GetBuilder<SettingsController>(
      builder: (controller) {
        return NeumorphicSlider(
          height: 15,
          value: controller.textScaleFactor ?? 1.0,
          min: 0.8,
          max: 1.4,
          onChanged: (value) {
            controller.setTextScaleFactor(value);
          },
          thumb: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const Icon(Icons.text_fields, size: 20),
          ),
        );
      },
    );
  }

  Widget _buildLayoutOptions() {
    return GetBuilder<SettingsController>(
      builder: (controller) {
        return Column(
          children: [
            _buildSwitchOption(
              title: 'compact_view'.tr,
              value: controller.compactView ?? false,
              onChanged: (value) => controller.setCompactView(value),
              icon: Icons.view_compact,
            ),
            _buildSwitchOption(
              title: 'show_images'.tr,
              value: controller.showImages ?? true,
              onChanged: (value) => controller.setShowImages(value),
              icon: Icons.image,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSwitchOption({
    required String title,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: NeumorphicButton(
        style: const NeumorphicStyle(
          depth: 2,
          intensity: 0.6,
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            NeumorphicSwitch(
              value: value,
              onChanged: onChanged,
              style: const NeumorphicSwitchStyle(
                lightSource: LightSource.topLeft,
              ),
            ),
          ],
        ),
        onPressed: () => onChanged(!value),
      ),
    );
  }
}
