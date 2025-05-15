import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/controllers/settings_controller.dart';
import 'package:gpr_coffee_shop/widgets/home/components/logo_section.dart';
import 'package:gpr_coffee_shop/widgets/home/components/benefit_pay_qr_section.dart';
import 'package:gpr_coffee_shop/widgets/home/components/feedback_section.dart';
import 'package:gpr_coffee_shop/widgets/home/components/delivery_buttons.dart';
import 'package:gpr_coffee_shop/widgets/home/components/menu_options_list_improved.dart';
import 'package:gpr_coffee_shop/utils/responsive_helper.dart';

class PortraitLayout extends StatelessWidget {
  final bool reducedMotion;

  const PortraitLayout({
    Key? key,
    this.reducedMotion = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();
    final textColor = settingsController.textColor;

    final metrics = ResponsiveHelper.getScreenMetrics(context);
    final screenHeight = metrics['screenHeight'] as double;
    final screenWidth = metrics['screenWidth'] as double;
    final padding = MediaQuery.of(context).padding;
    final isSmallScreen = metrics['isSmallScreen'] as bool;
    final isVerySmallScreen = metrics['isVerySmallScreen'] as bool;

    final logoSize = metrics['logoSize'] as double;
    final titleFontSize = metrics['titleFontSize'] as double;
    final descriptionFontSize = metrics['descriptionFontSize'] as double;
    final spacingAfterLogo = metrics['spacingAfterLogo'] as double;

    return SafeArea(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: AnimationLimiter(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight - padding.vertical,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo and title section with animation
                  !reducedMotion
                      ? SizedBox(
                          height: isSmallScreen
                              ? screenHeight * 0.25
                              : screenHeight * 0.27,
                          child: AnimationConfiguration.synchronized(
                            duration: const Duration(milliseconds: 800),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    LogoSection(
                                        logoSize: logoSize,
                                        isSmallScreen: isSmallScreen,
                                        titleStyle: TextStyle(
                                            fontSize: titleFontSize,
                                            fontWeight: FontWeight.bold,
                                            color: textColor),
                                        subtitleStyle: TextStyle(
                                            fontSize: descriptionFontSize,
                                            color: textColor),
                                        textColor: textColor),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: isSmallScreen
                              ? screenHeight * 0.23
                              : screenHeight * 0.25,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LogoSection(
                                  logoSize: logoSize,
                                  isSmallScreen: isSmallScreen,
                                  titleStyle: TextStyle(
                                      fontSize: titleFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: textColor),
                                  subtitleStyle: TextStyle(
                                      fontSize: descriptionFontSize,
                                      color: textColor),
                                  textColor: textColor),
                            ],
                          ),
                        ),

                  // Extra space after logo and title
                  SizedBox(height: spacingAfterLogo * 1.5),

                  // Menu options list
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: isSmallScreen
                          ? screenHeight * 0.01
                          : screenHeight * 0.015,
                    ),
                    child: AnimationLimiter(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 600),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            horizontalOffset: 50.0,
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: [
                            const MenuOptionsListImproved(isLandscape: false),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // QR code section
                  const BenefitPayQrSection(isPortrait: true),

                  // Feedback section
                  const FeedbackSection(isPortrait: true),

                  // Delivery buttons
                  Align(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: screenWidth * 0.08,
                          left: screenWidth * 0.08,
                          bottom: screenHeight * 0.01),
                      child: const DeliveryButtons(),
                    ),
                  ),

                  // Divider and copyright
                  AnimationConfiguration.synchronized(
                    duration: const Duration(milliseconds: 1000),
                    child: FadeInAnimation(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Divider(
                            color: Colors.brown.withAlpha(128),
                            thickness: 1,
                            indent: screenWidth * 0.1,
                            endIndent: screenWidth * 0.1,
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            'copyright'.tr,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 10 : 12,
                              fontWeight: FontWeight.w400,
                              color: textColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
