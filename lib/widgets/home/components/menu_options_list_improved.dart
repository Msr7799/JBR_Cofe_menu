import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/menu_options_controller.dart';
import 'package:gpr_coffee_shop/models/menu_option.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:gpr_coffee_shop/utils/responsive_helper.dart';
import 'package:gpr_coffee_shop/widgets/home/components/tablet_option_card.dart';
import 'package:gpr_coffee_shop/widgets/home/components/slim_option_card.dart';

/// Improved Menu Options List with better tablet support
class MenuOptionsListImproved extends StatelessWidget {
  final bool isLandscape;
  final double gridSpacing; // إضافة معامل جديد للمسافة بين العناصر

  const MenuOptionsListImproved({
    Key? key, 
    required this.isLandscape,
    this.gridSpacing = 12.0, // قيمة افتراضية 12 بكسل إذا لم يتم تمرير قيمة
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuOptionsController>(
      id: 'home_options_list',
      builder: (controller) {
        // Use ResponsiveHelper to get screen metrics
        final metrics = ResponsiveHelper.getScreenMetrics(context);
        final isSmallScreen = metrics['isSmallScreen'] as bool? ?? false;
        final isVerySmallScreen =
            metrics['isVerySmallScreen'] as bool? ?? false;
        final isTablet = metrics['isTablet'] as bool? ?? false;
        final isSmallTablet = metrics['isSmallTablet'] as bool? ?? false;

        // Split options into groups (primary and secondary)
        List<MenuOption> primaryOptions = [];
        List<MenuOption> secondaryOptions = [];

        if (controller.visibleOptions.length > 4) {
          primaryOptions = controller.visibleOptions.sublist(0, 4);
          secondaryOptions = controller.visibleOptions.sublist(4);
        } else {
          primaryOptions = controller.visibleOptions;
        }

        // If it's landscape mode, use the landscape layout
        if (isLandscape == true) {
          return _buildLandscapeOptions(
              controller, metrics, primaryOptions, secondaryOptions);
        }

        // Portrait mode layout
        return Column(
          children: [
            // Tabs for navigating between primary and secondary options
            if (secondaryOptions.isNotEmpty)
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTabButton(
                        icon: Icons.home_outlined,
                        isActive: controller.activeTabIndex.value == 0,
                        onTap: () => controller.activeTabIndex.value = 0,
                      ),
                      const SizedBox(width: 16),
                      _buildTabButton(
                        icon: Icons.more_horiz,
                        isActive: controller.activeTabIndex.value == 1,
                        onTap: () => controller.activeTabIndex.value = 1,
                      ),
                    ],
                  )),

            const SizedBox(height: 12),

            // Options container with responsive sizing
            Obx(() {
              List<MenuOption> currentOptions =
                  controller.activeTabIndex.value == 0
                      ? primaryOptions
                      : secondaryOptions;

              // Calculate height based on device type
              final double containerHeight = _getContainerHeight(
                  isTablet, isSmallTablet, isVerySmallScreen, isSmallScreen);

              return Container(
                height: containerHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                  color: Colors.white.withOpacity(0.12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: controller.isEditMode.value
                    ? _buildEditModeContent(
                        controller,
                        isTablet,
                        isSmallTablet,
                        isSmallScreen,
                        currentOptions,
                        primaryOptions,
                        secondaryOptions)
                    : _buildNormalModeContent(controller, isTablet,
                        isSmallTablet, isSmallScreen, currentOptions),
              );
            }),

            // Hidden options section
            Obx(() => _buildHiddenOptions(controller, isSmallScreen)),
          ],
        );
      },
    );
  }

  // Calculate the appropriate container height based on device type
  double _getContainerHeight(bool isTablet, bool isSmallTablet,
      bool isVerySmallScreen, bool isSmallScreen) {
    if (isTablet) {
      return isSmallTablet ? 450 : 500; // Much taller containers for tablets
    } else if (isVerySmallScreen) {
      return 280;
    } else if (isSmallScreen) {
      return 300;
    } else {
      return 320;
    }
  }

  // Build tab button with icon
  Widget _buildTabButton({
    IconData? icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.primaryColor.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? AppTheme.primaryColor
                : Colors.grey.shade400.withOpacity(0.5),
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Icon(
          icon,
          color: isActive ? AppTheme.primaryColor : Colors.grey.shade600,
          size: 20,
        ),
      ),
    );
  }

  // Build content in edit mode (reorderable grid/list)
  Widget _buildEditModeContent(
      MenuOptionsController controller,
      bool isTablet,
      bool isSmallTablet,
      bool isSmallScreen,
      List<MenuOption> currentOptions,
      List<MenuOption> primaryOptions,
      List<MenuOption> secondaryOptions) {
    if (isTablet) {
      // Tablet edit mode - reorderable grid with larger cards
      return ReorderableGridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              isSmallTablet ? 1 : 2, // Fewer columns for larger cards
          mainAxisSpacing: gridSpacing, // استخدام gridSpacing هنا
          crossAxisSpacing: gridSpacing, // استخدام gridSpacing هنا
          childAspectRatio: isSmallTablet ? 2.5 : 2.7, // Taller cards
        ),
        itemCount: currentOptions.length,
        onReorder: (oldIndex, newIndex) => _handleReorder(
            controller, oldIndex, newIndex, primaryOptions, secondaryOptions),
        itemBuilder: (context, index) {
          return TabletOptionCard(
            key: Key('editable_grid_option_${currentOptions[index].id}'),
            option: currentOptions[index],
            isEditing: true,
            onDelete: () => controller.hideOption(currentOptions[index].id),
            tabletSize: isSmallTablet ? 'small' : 'regular',
          );
        },
      );
    } else {
      // Phone edit mode - reorderable list
      return ReorderableListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: currentOptions.length,
        onReorder: (oldIndex, newIndex) => _handleReorder(
            controller, oldIndex, newIndex, primaryOptions, secondaryOptions),
        itemBuilder: (context, index) {
          return SlimOptionCard(
            key: Key('editable_list_option_${currentOptions[index].id}'),
            option: currentOptions[index],
            isEditing: true,
            onDelete: () => controller.hideOption(currentOptions[index].id),
            isSmallScreen: isSmallScreen,
          );
        },
      );
    }
  }

  // Handle reorder logic
  void _handleReorder(
      MenuOptionsController controller,
      int oldIndex,
      int newIndex,
      List<MenuOption> primaryOptions,
      List<MenuOption> secondaryOptions) {
    if (controller.activeTabIndex.value == 0) {
      controller.reorderPrimaryOptions(oldIndex, newIndex, primaryOptions);
    } else {
      controller.reorderSecondaryOptions(
          oldIndex, newIndex, secondaryOptions, primaryOptions);
    }
  }

  // Build content in normal mode (grid/list)
  Widget _buildNormalModeContent(
      MenuOptionsController controller,
      bool isTablet,
      bool isSmallTablet,
      bool isSmallScreen,
      List<MenuOption> currentOptions) {
    if (isTablet) {
      // Tablet normal mode - grid view with larger cards
      return GridView.builder(
        padding: const EdgeInsets.all(4),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isSmallTablet
              ? 1
              : 2, // Only 1 column for small tablets to maximize size
          mainAxisSpacing: gridSpacing, // استخدام gridSpacing هنا
          crossAxisSpacing: gridSpacing, // استخدام gridSpacing هنا
          childAspectRatio: isSmallTablet
              ? 2.5
              : 2.8, // More height compared to width for taller cards
        ),
        itemCount: currentOptions.length,
        itemBuilder: (context, index) {
          return TabletOptionCard(
            key: Key('normal_grid_option_${currentOptions[index].id}'),
            option: currentOptions[index],
            isEditing: false,
            tabletSize: isSmallTablet ? 'small' : 'regular',
          );
        },
      );
    } else {
      // Phone normal mode - list view
      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: currentOptions.length,
        itemBuilder: (context, index) {
          return SlimOptionCard(
            key: Key('normal_list_option_${currentOptions[index].id}'),
            option: currentOptions[index],
            isEditing: false,
            isSmallScreen: isSmallScreen,
          );
        },
      );
    }
  }

  // Build hidden options section (shown in edit mode)
  Widget _buildHiddenOptions(
      MenuOptionsController controller, bool isSmallScreen) {
    if (controller.isEditMode.value && controller.hiddenOptions.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(0.12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'الخيارات المخفية',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 14 : 16,
                ),
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.hiddenOptions.length,
                itemBuilder: (context, index) => _buildHiddenOption(
                    controller, controller.hiddenOptions[index]),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  // Build individual hidden option
  Widget _buildHiddenOption(
      MenuOptionsController controller, MenuOption option) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 8),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => controller.showOption(option.id),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(option.icon, color: option.color, size: 24),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            option.title.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Build landscape layout for wider screens
  Widget _buildLandscapeOptions(
      MenuOptionsController controller,
      Map<String, dynamic> metrics,
      List<MenuOption> primaryOptions,
      List<MenuOption> secondaryOptions) {
    final isTablet = metrics['isTablet'] as bool? ?? false;
    final isDesktop = metrics['isDesktop'] as bool? ?? false;
    final screenWidth = metrics['screenWidth'] as double;

    // Optimize grid configuration for landscape mode - improved for larger displays
    int crossAxisCount;
    double childAspectRatio;

    if (isDesktop) {
      crossAxisCount = 2; // Further reduced for even larger cards
      childAspectRatio = 3.0; // Making cards taller
    } else if (isTablet) {
      crossAxisCount = 2; // Keep 2 columns for tablets but with taller cards
      childAspectRatio = 2.5; // Making cards much taller
    } else if (screenWidth >= 480) {
      crossAxisCount = 1; // Single column for medium phones for larger cards
      childAspectRatio = 2.7;
    } else {
      crossAxisCount = 1;
      childAspectRatio = 3.0;
    }

    return Column(
      children: [
        Expanded(
          child: Obx(() {
            if (controller.isEditMode.value) {
              // Edit mode - reorderable grid
              return ReorderableGridView.count(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                mainAxisSpacing: gridSpacing, // استخدام gridSpacing هنا
                crossAxisSpacing: gridSpacing, // استخدام gridSpacing هنا
                padding: EdgeInsets.all(4.0), // هامش خارجي صغير
                children:
                    controller.visibleOptions.asMap().entries.map((entry) {
                  // Determine tablet size for edit mode
                  String editTabletSizeClass = 'regular';
                  if (isTablet) {
                    if (metrics['isLargeTablet'] as bool? ?? false) {
                      editTabletSizeClass = 'large';
                    } else if (metrics['isMediumTablet'] as bool? ?? false) {
                      editTabletSizeClass = 'medium';
                    } else {
                      editTabletSizeClass = 'small';
                    }
                  }

                  return isTablet
                      ? TabletOptionCard(
                          key: Key(
                              'landscape_editable_option_${entry.value.id}'),
                          option: entry.value,
                          isEditing: true,
                          onDelete: () => controller.hideOption(entry.value.id),
                          tabletSize: editTabletSizeClass,
                        )
                      : SlimOptionCard(
                          key: Key(
                              'landscape_editable_option_${entry.value.id}'),
                          option: entry.value,
                          isEditing: true,
                          onDelete: () => controller.hideOption(entry.value.id),
                          isSmallScreen: false,
                        );
                }).toList(),
                onReorder: (oldIndex, newIndex) {
                  controller.reorderPrimaryOptions(
                      oldIndex, newIndex, controller.visibleOptions);
                },
              );
            } else {
              // Normal mode - grid with enhanced sizing for tablets
              return GridView.count(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                mainAxisSpacing: gridSpacing, // استخدام gridSpacing هنا
                crossAxisSpacing: gridSpacing, // استخدام gridSpacing هنا
                padding: EdgeInsets.all(4.0), // هامش خارجي صغير جداً
                children: controller.visibleOptions.map((option) {
                  // Use proper tablet size classification
                  String tabletSizeClass = 'regular';
                  if (isTablet) {
                    if (metrics['isLargeTablet'] as bool? ?? false) {
                      tabletSizeClass = 'large';
                    } else if (metrics['isMediumTablet'] as bool? ?? false) {
                      tabletSizeClass = 'medium';
                    } else {
                      tabletSizeClass = 'small';
                    }
                  }

                  return isTablet
                      ? TabletOptionCard(
                          key: Key('landscape_normal_option_${option.id}'),
                          option: option,
                          isEditing: false,
                          tabletSize: tabletSizeClass,
                        )
                      : SlimOptionCard(
                          key: Key('landscape_normal_option_${option.id}'),
                          option: option,
                          isEditing: false,
                          isSmallScreen: false,
                        );
                }).toList(),
              );
            }
          }),
        ),

        // Hidden options section for landscape mode
        Obx(() {
          if (controller.isEditMode.value &&
              controller.hiddenOptions.isNotEmpty) {
            return Column(
              children: [
                const Divider(thickness: 1),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'الخيارات المخفية',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.hiddenOptions.length,
                    itemBuilder: (context, index) => _buildHiddenOption(
                        controller, controller.hiddenOptions[index]),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }
}
