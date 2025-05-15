import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/controllers/settings_controller.dart';
import 'package:gpr_coffee_shop/widgets/home/components/benefit_pay_qr_section.dart';
import 'package:gpr_coffee_shop/widgets/home/components/feedback_section.dart';
import 'package:gpr_coffee_shop/widgets/home/components/menu_options_list_improved.dart';
import 'package:gpr_coffee_shop/widgets/home/components/delivery_buttons.dart';
import 'package:gpr_coffee_shop/widgets/home/components/logo_section.dart';
import 'package:gpr_coffee_shop/utils/responsive_helper.dart';

class LandscapeLayout extends StatelessWidget {
  const LandscapeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();
    final textColor = settingsController.textColor;

    final metrics = ResponsiveHelper.getScreenMetrics(context);
    final screenHeight = metrics['screenHeight'] as double;
    final screenWidth = metrics['screenWidth'] as double;
    final isSmallScreen = metrics['isSmallScreen'] as bool;
    final isSmallTablet = metrics['isSmallTablet'] as bool;
    final isMediumTablet = metrics['isMediumTablet'] as bool;
    final isLargeTablet = metrics['isLargeTablet'] as bool;

    // Adjust column flex ratios based on screen size
    final int leftColumnFlex = isSmallScreen
        ? 1
        : isSmallTablet
            ? 3
            : isMediumTablet
                ? 2
                : isLargeTablet
                    ? 2
                    : 2;

    final int rightColumnFlex = isSmallScreen
        ? 2
        : isSmallTablet
            ? 5
            : isMediumTablet
                ? 5
                : isLargeTablet
                    ? 4
                    : 3;

    return SafeArea(
      child: Row(
        children: [
          // Left column - Logo and info
          Expanded(
            flex: leftColumnFlex,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo and information
                  AnimationConfiguration.synchronized(
                    duration: const Duration(milliseconds: 1200),
                    child: SlideAnimation(
                      horizontalOffset: -50.0,
                      child: FadeInAnimation(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // App logo and title/slogan
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.02),
                              child: LogoSection(
                                logoSize: isSmallScreen
                                    ? screenHeight * 0.18
                                    : screenHeight * 0.25,
                                isSmallScreen: isSmallScreen,
                                titleStyle: TextStyle(
                                  fontSize: isSmallScreen
                                      ? screenHeight * 0.036
                                      : screenHeight * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                                subtitleStyle: TextStyle(
                                  fontSize: isSmallScreen
                                      ? screenHeight * 0.024
                                      : screenHeight * 0.028,
                                  color: textColor.withOpacity(0.8),
                                ),
                                textColor: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // QR code section
                  const BenefitPayQrSection(
                      isPortrait: false), // Feedback section
                  const FeedbackSection(isPortrait: false),

                  // Delivery service buttons
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                    child: DeliveryButtons(),
                  ),
                ],
              ),
            ),
          ),

          // Vertical divider
          Container(
            height: screenHeight * 0.7,
            width: 1,
            color: Colors.brown.withAlpha(76),
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
          ),

          // Right column - App navigation buttons in landscape mode
          Expanded(
            flex: rightColumnFlex,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                screenHeight * 0.02, // left
                screenHeight * 0.04, // top - increase top margin
                screenHeight * 0.02, // right
                screenHeight * 0.02, // bottom
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display options in GridView with GetBuilder
                  // تمرير قيمة 8 للمسافة بين الكروت في الشاشات الكبيرة
                  Expanded(
                    child: MenuOptionsListImproved(
                      isLandscape: true, 
                      gridSpacing: 8.0, // تمرير المسافة المطلوبة (8 بكسل) بين كروت القائمة
                    ),
                  ),
                  // Hidden options are now handled by MenuOptionsListImproved component

                  // Copyright footer
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                    child: AnimationConfiguration.synchronized(
                      duration: const Duration(milliseconds: 1000),
                      child: FadeInAnimation(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Divider(
                              color: Colors.brown.withAlpha(128),
                              thickness: 1,
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              'copyright'.tr,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 9 : 10,
                                fontWeight: FontWeight.w400,
                                color: textColor,
                              ),
                              textAlign: TextAlign.center,
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
        ],
      ),
    );
  }
}