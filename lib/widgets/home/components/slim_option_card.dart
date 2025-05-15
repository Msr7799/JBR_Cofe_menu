import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/menu_options_controller.dart';
import 'package:gpr_coffee_shop/controllers/view_options_controller.dart';
import 'package:gpr_coffee_shop/models/menu_option.dart';
import 'package:gpr_coffee_shop/utils/navigation_helper.dart';
import 'package:gpr_coffee_shop/utils/responsive_helper.dart';
import 'package:gpr_coffee_shop/utils/logger_util.dart';

/// An improved slim option card for phone displays
class SlimOptionCard extends StatelessWidget {
  final MenuOption option;
  final bool isEditing;
  final VoidCallback? onDelete;
  final bool isSmallScreen;
  final bool isActive;

  const SlimOptionCard({
    Key? key,
    required this.option,
    required this.isEditing,
    this.onDelete,
    required this.isSmallScreen,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get controllers
    final viewOptionsController = Get.find<ViewOptionsController>();
    final menuOptionsController = Get.find<MenuOptionsController>();

    // Get responsive metrics
    final metrics = ResponsiveHelper.getScreenMetrics(context);
    final isTablet = metrics['isTablet'] as bool? ?? false;

    // Extract colors and styles
    final Color textColor = viewOptionsController.getColorFromHex(
        viewOptionsController.getOptionTextColor(isSmallScreen));
    final Color borderColor = viewOptionsController.getColorFromHex(
        viewOptionsController.getOptionBorderColor(isSmallScreen));
    final Color iconColor = viewOptionsController.useCustomIconColors.value
        ? viewOptionsController.getColorFromHex(
            viewOptionsController.getOptionIconColor(isSmallScreen))
        : option.color;

    // Scale font size based on device
    final double fontSize = isTablet
        ? viewOptionsController.getOptionTextSize(isSmallScreen) * 1.2
        : viewOptionsController.getOptionTextSize(isSmallScreen);

    // Extract background settings
    final Color bgColor = viewOptionsController
        .getColorFromHex(viewOptionsController.optionBackgroundColor.value);
    final double bgOpacity =
        viewOptionsController.optionBackgroundOpacity.value;
    final bool useOptionShadows = viewOptionsController.useOptionShadows.value;

    // Adjust dimensions based on device type
    final double optionHeight = isTablet
        ? viewOptionsController.optionHeight.value * 1.2
        : viewOptionsController.optionHeight.value;

    final double optionPadding = isTablet
        ? viewOptionsController.optionPadding.value * 1.2
        : viewOptionsController.optionPadding.value;

    final double optionCornerRadius =
        viewOptionsController.optionCornerRadius.value;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: viewOptionsController.optionSpacing.value / 2,
      ),
      key: key,
      child: Dismissible(
        key: Key('dismiss_${option.id}'),
        direction:
            isEditing ? DismissDirection.endToStart : DismissDirection.none,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          color: Colors.red,
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        confirmDismiss: isEditing
            ? (direction) async {
                return await Get.dialog<bool>(
                      AlertDialog(
                        title: const Text('إخفاء الخيار'),
                        content: Text(
                            'هل تريد إخفاء "${option.title.tr}" من القائمة؟'),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(result: false),
                            child: const Text('إلغاء'),
                          ),
                          ElevatedButton(
                            onPressed: () => Get.back(result: true),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            child: const Text('إخفاء'),
                          ),
                        ],
                      ),
                    ) ??
                    false;
              }
            : null,
        onDismissed: isEditing && onDelete != null
            ? (direction) {
                onDelete!();
              }
            : null,
        child: GestureDetector(
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
          child: Container(
            width: viewOptionsController.optionWidth.value > 0
                ? viewOptionsController.optionWidth.value
                : null,
            height: optionHeight,
            decoration: BoxDecoration(
              color: bgColor.withOpacity(bgOpacity),
              borderRadius: BorderRadius.circular(optionCornerRadius),
              border: Border.all(
                color: isActive ? AppTheme.primaryColor : borderColor,
                width: isActive ? 2.0 : 1.0,
              ),
              boxShadow: useOptionShadows
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : null,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: optionPadding,
              vertical: 8,
            ),
            child: Row(
              children: [
                Container(
                  width: isTablet ? 50 : 40,
                  height: isTablet ? 50 : 40,
                  decoration: BoxDecoration(
                    color: iconColor,
                    shape: BoxShape.circle,
                    boxShadow: useOptionShadows
                        ? [
                            BoxShadow(
                              color: iconColor.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    option.icon,
                    color: Colors.white,
                    size: isTablet ? 26 : 20,
                  ),
                ),
                SizedBox(width: optionPadding / 2),
                Expanded(
                  child: Text(
                    option.title.tr,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                      color: textColor,
                      shadows: null,
                    ),
                  ),
                ),
                if (!isEditing)
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: isTablet ? 20 : 16,
                  ),
                if (isEditing)
                  Icon(
                    Icons.drag_handle,
                    color: Colors.grey,
                    size: isTablet ? 24 : 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
