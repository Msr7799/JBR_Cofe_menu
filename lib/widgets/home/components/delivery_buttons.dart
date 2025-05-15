import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/services/app_translation_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryButtons extends StatelessWidget {
  const DeliveryButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isVerySmallScreen = screenWidth < 320;

    final buttonSize = isVerySmallScreen
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
        ? 10.0
        : isSmallScreen
            ? 11.0
            : 12.0;

    // Get current app language
    final appTranslationService = Get.find<AppTranslationService>();
    final isArabic =
        appTranslationService.currentLocale.value.languageCode == 'ar';

    return GetBuilder<AppTranslationService>(
        id: 'language_switcher',
        builder: (translationService) {
          final isArabic =
              translationService.currentLocale.value.languageCode == 'ar';

          // Create the button list in the correct order based on language
          final buttonsList = isArabic
              ? [
                  // For Arabic: Jahez then Talabat (right to left)
                  _buildJahezButton(buttonSize, fontSize),
                  const SizedBox(width: 10),
                  _buildTalabatButton(buttonSize, fontSize),
                ]
              : [
                  // For English: Talabat then Jahez (left to right)
                  _buildTalabatButton(buttonSize, fontSize),
                  const SizedBox(width: 10),
                  _buildJahezButton(buttonSize, fontSize),
                ];

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buttonsList,
          );
        });
  }

  // Helper method to create Talabat button
  Widget _buildTalabatButton(double buttonSize, double fontSize) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 3,
        intensity: 0.3,
        lightSource: LightSource.topLeft,
        shape: NeumorphicShape.convex,
        boxShape:
            NeumorphicBoxShape.roundRect(BorderRadius.circular(buttonSize / 2)),
        color: const Color.fromARGB(255, 255, 165, 0)
            .withOpacity(0.75), // Talabat color with opacity
      ),
      child: GestureDetector(
        onTap: () async {
          final talabatUrl = Uri.parse(
              'https://www.talabat.com/bahrain/restaurant/755906/jbr-cafe-alhajiyat?aid=1031');
          if (await canLaunchUrl(talabatUrl)) {
            await launchUrl(talabatUrl, mode: LaunchMode.externalApplication);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(buttonSize / 2),
            border: Border.all(
              color: const Color.fromARGB(255, 255, 255, 255)
                  .withOpacity(0.7), // Border color with opacity
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.delivery_dining,
                  color: Color.fromARGB(255, 230, 227, 226), size: 16),
              const SizedBox(width: 4),
              Text(
                'Talabat',
                style: TextStyle(
                  color: const Color.fromARGB(255, 230, 227, 226), // Talabat text color
                  fontSize: fontSize + 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create Jahez button
  Widget _buildJahezButton(double buttonSize, double fontSize) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 3,
        intensity: 0.3,
        lightSource: LightSource.topLeft,
        shape: NeumorphicShape.convex,
        boxShape:
            NeumorphicBoxShape.roundRect(BorderRadius.circular(buttonSize / 2)),
        color: const Color.fromARGB(255, 198, 0, 0)
            .withOpacity(0.75), // Jahez color with opacity
      ),
      child: GestureDetector(
        onTap: () async {
          final jahezUrl = Uri.parse(
              'https://www.instagram.com/jahezbh/?locale=slot%2Bdemo%2Bpg%2Bmahjong%2B3%E3%80%90777ONE.IN%E3%80%91.dgxn&hl=en');
          if (await canLaunchUrl(jahezUrl)) {
            await launchUrl(jahezUrl, mode: LaunchMode.externalApplication);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(buttonSize / 2),
            border: Border.all(
              color: const Color.fromARGB(255, 239, 239, 239)
                  .withOpacity(0.7), // Border color with opacity
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'J',
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255), // Jahez color
                  fontSize: fontSize + 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'Jahez',
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255), // Jahez color
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
