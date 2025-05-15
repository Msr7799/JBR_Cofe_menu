import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/menu_options_controller.dart';
import 'package:gpr_coffee_shop/controllers/view_options_controller.dart';
import 'package:gpr_coffee_shop/models/menu_option.dart';
import 'package:gpr_coffee_shop/utils/navigation_helper.dart';
import 'package:gpr_coffee_shop/utils/responsive_helper.dart';
import 'package:gpr_coffee_shop/utils/logger_util.dart';

/// An improved tablet option card that resolves previous display issues
class TabletOptionCard extends StatelessWidget {
  final MenuOption option;
  final bool isEditing;
  final VoidCallback? onDelete;
  final String tabletSize;
  final bool isActive;

  const TabletOptionCard({
    Key? key,
    required this.option,
    required this.isEditing,
    this.onDelete,
    required this.tabletSize,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get controllers
    final viewOptionsController = Get.find<ViewOptionsController>();
    final menuOptionsController = Get.find<MenuOptionsController>();

    // Get responsive metrics
    final metrics = ResponsiveHelper.getScreenMetrics(context);
    final isLargeTablet = metrics['isLargeTablet'] as bool? ?? false;
    final isMediumTablet = metrics['isMediumTablet'] as bool? ??
        false; // Extract colors from controller
    final Color textColor = viewOptionsController
        .getColorFromHex(viewOptionsController.optionTextColor.value);
    final Color borderColor = viewOptionsController
        .getColorFromHex(viewOptionsController.optionBorderColor.value);
    final Color iconColor = viewOptionsController.useCustomIconColors.value
        ? viewOptionsController
            .getColorFromHex(viewOptionsController.optionIconColor.value)
        : option
            .color; // Scale UI based on tablet size with improved dimensions    // تهيئة القيم الافتراضية
    final double fontSize = viewOptionsController.getOptionTextSize(false) *
        (isLargeTablet
            ? 1.3
            : isMediumTablet
                ? 1.2
                : 1.15);
    double iconSize = 35.0;
    // زيادة معامل ارتفاع التابلت الصغير من 1.2 إلى 1.5 لجعل الارتفاع أكبر
    final double optionHeight = viewOptionsController.optionHeight.value *
        (isLargeTablet
            ? 1.4
            : isMediumTablet
                ? 1.3
                : 1.5);
    // تقليل المسافة الداخلية للتابلت الكبير لتتمكن من التحكم بها بشكل أفضل
    final double optionPadding = viewOptionsController.optionPadding.value *
        (isLargeTablet
            ? 1.25
            : isMediumTablet
                ? 1.2
                : 1.15);

    if (isLargeTablet) {
      iconSize = 45.0; // حجم الأيقونة للتابلت الكبير
    } else if (isMediumTablet) {
      iconSize = 35.0; // حجم الأيقونة للتابلت المتوسط
    } else {
      // Small tablet (تكبير حجم الأيقونة للتابلت الصغير)
      iconSize = 30.0; // زيادة حجم الأيقونة للتابلت الصغير من 25 إلى 30
    }

    // Extract other style properties
    final Color bgColor = viewOptionsController
        .getColorFromHex(viewOptionsController.optionBackgroundColor.value);
    final double bgOpacity =
        viewOptionsController.optionBackgroundOpacity.value;
    final bool useOptionShadows = viewOptionsController.useOptionShadows.value;
    final double optionCornerRadius =
        viewOptionsController.optionCornerRadius.value;

    return GestureDetector(
      onTap: isEditing
          ? null
          : () {
              try {
                menuOptionsController.navigateToOption(option.route);
              } catch (e) {
                LoggerUtil.logger.e('خطأ في التنقل: $e');
                NavigationHelper.navigateToRoute(option.route);
              }
            },
      child: Padding(
        padding: EdgeInsets.symmetric(
            // استخدام معامل المسافة بين الخيارات من المتحكم
            vertical: viewOptionsController.optionSpacing.value /
                (isLargeTablet
                    ? 2.5
                    : isMediumTablet
                        ? 2
                        : 1.5),
            horizontal: 4.0), // تقليل الهامش حول البطاقة
        child: Container(
          width: viewOptionsController.optionWidth.value > 0
              ? viewOptionsController.optionWidth.value
              : null,
          height: optionHeight,
          decoration: BoxDecoration(
            color: bgColor.withOpacity(bgOpacity),
            borderRadius: BorderRadius.circular(
                optionCornerRadius + 4), // More rounded corners
            border: Border.all(
              color: isActive ? AppTheme.primaryColor : borderColor,
              width: isActive
                  ? 4.0
                  : 3.0, // Even thicker borders for more prominence
            ),
            boxShadow: useOptionShadows
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25), // Darker shadow
                      blurRadius: 12, // Increased blur
                      offset: const Offset(0, 4), // Slightly larger offset
                      spreadRadius: 2, // More spread
                    )
                  ]
                : null,
          ),
          child: Stack(
            children: [
              // Delete button for edit mode
              if (isEditing)
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ), // Main option content
              Padding(
                padding:
                    EdgeInsets.all(optionPadding - 4), // تقليل الحشو الداخلي
                child: Row(
                  children: [
                    // Option icon - significantly enhanced for better visibility
                    Container(
                      width: iconSize,
                      height: iconSize,
                      decoration: BoxDecoration(
                        color: iconColor,
                        shape: BoxShape.circle,

                        // Add gradient effect for more visual pop
                        gradient: RadialGradient(
                          colors: [
                            iconColor,
                            iconColor.withOpacity(0.8),
                          ],
                          center: Alignment.topLeft,
                          focal: Alignment.topLeft,
                          radius: 1.8,
                        ),
                      ),
                      child: Icon(
                        option.icon,
                        color: Colors.white,
                        size: iconSize * 0.7, // Even larger icon
                      ),
                    ),
                    SizedBox(
                        width: 10), // تقليل المسافة أكثر بين الأيقونة والنص

                    // Option text
                    Expanded(
                      child: Text(
                        option.title.tr,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: isActive
                              ? FontWeight.w800
                              : FontWeight.w700, // Bolder text
                          color: textColor,
                          letterSpacing: 0.8, // Enhanced letter spacing
                          height: 1.1, // Tighter line height for better display
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ), // Navigation arrow or drag handle
                    if (!isEditing)
                      Icon(
                        Icons.chevron_right,
                        color: textColor.withOpacity(0.7),
                        size: tabletSize == 'small' ? 28 : 32, // Larger arrow
                      ),

                    if (isEditing)
                      Icon(
                        Icons.drag_handle,
                        color: Colors.grey.withOpacity(0.7),
                        size: tabletSize == 'small' ? 28 : 32, // Larger handle
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
