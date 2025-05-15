import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/controllers/settings_controller.dart';
import 'package:gpr_coffee_shop/utils/image_helper.dart';
import 'package:gpr_coffee_shop/utils/responsive_helper.dart';
import 'package:gpr_coffee_shop/utils/logger_util.dart';

class LogoSection extends StatelessWidget {
  final double? logoSize;
  final bool? isSmallScreen;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final Color? textColor;

  const LogoSection({
    Key? key,
    this.logoSize,
    this.isSmallScreen,
    this.titleStyle,
    this.subtitleStyle,
    this.textColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Get responsive metrics from helper
    final metrics = ResponsiveHelper.getScreenMetrics(context);
    final actualIsSmallScreen =
        isSmallScreen ?? (metrics['isSmallScreen'] as bool);
    final actualLogoSize = logoSize ?? (metrics['logoSize'] as double);
    final titleFontSize = metrics['titleFontSize'] as double;
    final descriptionFontSize = metrics['descriptionFontSize'] as double;

    // Create default styles if not provided
    final actualTitleStyle = titleStyle ??
        TextStyle(
          fontSize: titleFontSize,
          fontWeight: FontWeight.bold,
          color: textColor ?? Colors.white,
        );

    final actualSubtitleStyle = subtitleStyle ??
        TextStyle(
          fontSize: descriptionFontSize,
          fontWeight: FontWeight.w400,
          color: textColor ?? Colors.white70,
        );

    return GetBuilder<SettingsController>(
      id: 'app_logo',
      builder: (controller) {
        final logoPath = controller.logoPath ?? 'assets/images/logo.png';

        return StatefulBuilder(
          builder: (context, setState) {
            // Define variables inside build function
            bool isHovering = false;
            final double adjustedLogoSize =
                actualLogoSize * (actualIsSmallScreen ? 1.0 : 1.2);
            final double adjustedLogoPadding = actualIsSmallScreen ? 8.0 : 12.0;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MouseRegion(
                  onEnter: (event) => setState(() => isHovering = true),
                  onExit: (event) => setState(() => isHovering = false),
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      depth: 0.3,
                      intensity: 0.15,
                      shape: NeumorphicShape.convex,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(10)),
                      lightSource: LightSource.topLeft,
                      color: const Color.fromARGB(44, 19, 19, 19),
                    ),
                    child: Container(
                      width: adjustedLogoSize,
                      height: adjustedLogoSize,
                      padding: EdgeInsets.all(adjustedLogoPadding),
                      decoration: BoxDecoration(
                        color: isHovering
                            ? Colors.transparent
                            : const Color.fromARGB(125, 0, 0, 0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: GestureDetector(
                          onTap: () =>
                              _showLogoSelectionDialog(context, controller),
                          child: ImageHelper.buildImage(
                            logoPath,
                            fit: BoxFit.contain,
                            isCircular: false,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: actualIsSmallScreen ? 10 : 15),
              ],
            );
          },
        );
      },
    );
  }

  // Show dialog to select logo
  void _showLogoSelectionDialog(
      BuildContext context, SettingsController controller) {
    // List of available logos
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

    // Get current logo path
    final currentLogo = controller.logoPath ?? 'assets/images/logo.png';

    // Use showModalBottomSheet to avoid display issues
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

                // Grid of available logos
                SizedBox(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...availableLogos.map((logo) =>
                          _buildLogoOption(logo, controller, context)),
                      _buildCustomLogoOption(),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                Center(
                  child: TextButton.icon(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.check_circle, color: Colors.green),
                    label:
                        const Text('تم', style: TextStyle(color: Colors.green)),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }

  // Build logo option widget
  Widget _buildLogoOption(
      String imagePath, SettingsController controller, BuildContext context) {
    final isSelected =
        (controller.logoPath ?? 'assets/images/logo.png') == imagePath;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return GestureDetector(
      onTap: () {
        controller.setLogoPath(imagePath);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 80,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(isSmallScreen ? 40 : 10),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(isSmallScreen ? 30 : 8),
              child: Image.asset(
                imagePath,
                height: 60,
                width: 60,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build custom logo option
  Widget _buildCustomLogoOption() {
    return GestureDetector(
      onTap: () {
        try {
          // Implement custom logo upload logic
          LoggerUtil.logger.i('Custom logo upload clicked');
          Get.snackbar(
            'تحميل شعار',
            'سيتم دعم تحميل شعار مخصص في التحديث القادم',
            snackPosition: SnackPosition.BOTTOM,
          );
        } catch (e) {
          LoggerUtil.logger.e('Error in custom logo upload: $e');
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade100,
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              size: 30,
              color: Colors.blue,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 2,
                  offset: const Offset(1, 1),
                )
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              'تحميل صورة',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
