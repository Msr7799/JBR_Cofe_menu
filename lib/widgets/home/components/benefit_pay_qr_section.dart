import 'dart:io';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/controllers/settings_controller.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class BenefitPayQrSection extends StatelessWidget {
  final bool isPortrait;
  
  const BenefitPayQrSection({
    Key? key, 
    required this.isPortrait
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GetBuilder<SettingsController>(
      builder: (controller) {
        final qrCodeUrl = controller.benefitPayQrCodeUrl;

        if (qrCodeUrl == null || qrCodeUrl.isEmpty) {
          return const SizedBox.shrink();
        }

        // Reduce margins to make the box smaller
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isPortrait ? screenWidth * 0.08 : screenHeight * 0.05,
            vertical: isPortrait ? screenHeight * 0.015 : screenHeight * 0.02,
          ),
          child: AnimationConfiguration.synchronized(
            duration: const Duration(milliseconds: 800),
            child: SlideAnimation(
              verticalOffset: 30.0,
              child: FadeInAnimation(
                child: Neumorphic(
                  style: NeumorphicStyle(
                    depth: 8,
                    intensity: 0.7,
                    shape: NeumorphicShape.flat,
                    boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.circular(16),
                    ),
                    color: Colors.white.withAlpha(230),
                    lightSource: LightSource.topLeft,
                    shadowDarkColor: Colors.black45,
                    shadowLightColor: Colors.transparent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0), // Reduce internal padding
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.qr_code_2,
                              color: Colors.purple,
                              size: 20, // Reduce icon size
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'pay_with_benefitpay'.tr,
                                style: TextStyle(
                                  fontSize: isPortrait ? 14 : 12, // Reduce font size
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple.shade800,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10), // Reduce spacing
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            // Significantly reduce max width and height
                            maxWidth: isPortrait
                                ? screenWidth * 0.5 // Reduce from 0.7 to 0.5
                                : screenHeight * 0.3, // Reduce from 0.4 to 0.3
                            maxHeight: isPortrait
                                ? screenWidth * 0.5 // Reduce from 0.7 to 0.5
                                : screenHeight * 0.3, // Reduce from 0.4 to 0.3
                          ),
                          child: Image.file(
                            File(qrCodeUrl),
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 36, // Reduce error icon size
                                      color: Colors.red.shade300,
                                    ),
                                    const SizedBox(height: 6), // Reduce spacing
                                    Text(
                                      'error_loading_qr'.tr,
                                      style: const TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 12, // Reduce font size
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8), // Reduce spacing
                        Text(
                          'scan_qr_to_pay'.tr,
                          style: TextStyle(
                            fontSize: isPortrait ? 12 : 10, // Reduce font size
                            color: Colors.grey.shade800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
