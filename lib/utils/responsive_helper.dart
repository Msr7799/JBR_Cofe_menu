import 'package:flutter/material.dart';

class ResponsiveHelper {
  static Map<String, dynamic> getScreenMetrics(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Screen size flags
    final isVerySmallScreen = screenWidth < 320;
    final isSmallScreen = screenWidth < 360;
    final isLargeScreen = screenWidth >= 600;
    final isTablet = screenWidth >= 600 && screenWidth < 960;
    final isSmallTablet = screenWidth >= 600 && screenWidth < 720;
    final isMediumTablet = screenWidth >= 720 && screenWidth < 840;
    final isLargeTablet = screenWidth >= 840 && screenWidth < 960;
    final isDesktop = screenWidth >= 960;
    
    // Orientation
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    // Safe area
    final safeAreaVertical = MediaQuery.of(context).padding.vertical;
    final safeAreaHorizontal = MediaQuery.of(context).padding.horizontal;
    
    // Logo and text sizes
    final logoSize = isVerySmallScreen
        ? screenWidth * 0.28
        : isSmallScreen
            ? screenWidth * 0.30
            : screenWidth * 0.35;

    final titleFontSize = isVerySmallScreen
        ? screenWidth * 0.052
        : isSmallScreen
            ? screenWidth * 0.055
            : screenWidth * 0.06;

    final descriptionFontSize = isVerySmallScreen
        ? screenWidth * 0.032
        : isSmallScreen
            ? screenWidth * 0.035
            : screenWidth * 0.04;

    final spacingAfterLogo = isVerySmallScreen
        ? screenHeight * 0.03
        : isSmallScreen
            ? screenHeight * 0.035
            : screenHeight * 0.04;

    return {
      'screenWidth': screenWidth,
      'screenHeight': screenHeight,
      'isVerySmallScreen': isVerySmallScreen,
      'isSmallScreen': isSmallScreen,
      'isTablet': isTablet,
      'isSmallTablet': isSmallTablet,
      'isMediumTablet': isMediumTablet,
      'isLargeTablet': isLargeTablet,
      'isDesktop': isDesktop,
      'isLargeScreen': isLargeScreen,
      'isLandscape': isLandscape,
      'safeAreaVertical': safeAreaVertical,
      'safeAreaHorizontal': safeAreaHorizontal,
      'logoSize': logoSize,
      'titleFontSize': titleFontSize,
      'descriptionFontSize': descriptionFontSize,
      'spacingAfterLogo': spacingAfterLogo,
    };
  }
}
