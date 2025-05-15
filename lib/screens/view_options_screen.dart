import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:gpr_coffee_shop/controllers/menu_options_controller.dart';
import 'package:gpr_coffee_shop/controllers/view_options_controller.dart';
import 'package:gpr_coffee_shop/utils/view_options_helper.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ViewOptionsScreen extends StatelessWidget {
  final ViewOptionsController controller = Get.find<ViewOptionsController>();

  // Product display options variables
  final RxString viewMode = ViewOptionsHelper.getViewMode().obs;
  final RxBool showImages = ViewOptionsHelper.getShowImages().obs;
  final RxBool useAnimations = ViewOptionsHelper.getUseAnimations().obs;
  final RxBool showOrderButton = ViewOptionsHelper.getShowOrderButton().obs;
  final RxDouble cardSize = ViewOptionsHelper.getCardSize().obs;
  final RxInt selectedTextColor = ViewOptionsHelper.getTextColor().obs;
  final RxInt selectedPriceColor = ViewOptionsHelper.getPriceColor().obs;
  final RxString displayMode = ViewOptionsHelper.getDisplayMode().obs;

  // Home screen options variables
  final RxBool useTransparentCardBackground = RxBool(true);
  final RxString optionTextColor = RxString('#000000');
  final RxString optionIconColor = RxString('#546E7A');
  final RxString optionBorderColor = RxString('#546E7A');
  final RxDouble optionTextSize = RxDouble(16.0);
  final RxBool useCustomIconColors = RxBool(false);
  final RxBool useSmallScreenSettings = RxBool(false);

  // Text size options
  final RxDouble productTitleFontSize =
      ViewOptionsHelper.getProductTitleFontSize().obs;
  final RxDouble productPriceFontSize =
      ViewOptionsHelper.getProductPriceFontSize().obs;
  final RxDouble productButtonFontSize =
      ViewOptionsHelper.getProductButtonFontSize().obs;

  // Card size options
  final RxDouble productCardWidth = ViewOptionsHelper.getProductCardWidth().obs;
  final RxDouble productCardHeight =
      ViewOptionsHelper.getProductCardHeight().obs;
  final RxDouble productImageHeight =
      ViewOptionsHelper.getProductImageHeight().obs;
  final RxBool isLargeScreen = ViewOptionsHelper.getIsLargeScreen().obs;

  // Available colors list
  final List<Color> availableColors = [
    Colors.black,
    AppTheme.primaryColor,
    Colors.blue,
    Colors.green.shade700,
    Colors.purple,
    Colors.red.shade700,
    Colors.orange.shade800,
    Colors.teal.shade700,
    const Color.fromARGB(233, 255, 255, 255),
  ];

  ViewOptionsScreen({Key? key}) : super(key: key);

  @override
  void onInit() {
    // تحميل قيم الخيارات من المتحكم عند بدء الشاشة
    useTransparentCardBackground.value =
        controller.useTransparentCardBackground.value;
    optionTextColor.value = controller.optionTextColor.value;
    optionIconColor.value = controller.optionIconColor.value;
    optionBorderColor.value = controller.optionBorderColor.value;
    optionTextSize.value = controller.optionTextSize.value;
    useCustomIconColors.value = controller.useCustomIconColors.value;
    useSmallScreenSettings.value = controller.useSmallScreenSettings.value;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Scaffold(
      appBar: AppBar(
        title: Text('view_options'.tr),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: DefaultTabController(
        length: 4, // نقلل عدد التبويبات إلى 4 بعد الدمج
        child: Column(
          children: [
            Material(
              color: AppTheme.primaryColor,
              child: TabBar(
                isScrollable: true,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: [
                  Tab(text: 'home_screen_options'.tr),
                  Tab(text: 'view_mode'.tr),
                  Tab(text: 'card_dimensions'.tr),
                  Tab(text: 'text_colors'.tr),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // تبويب خيارات القائمة الرئيسية (المدمج)
                  SingleChildScrollView(
                    padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize:
                          MainAxisSize.min, // To avoid unbounded height issues
                      children: [
                        _buildSectionHeader('menu_options_appearance'.tr),
                        _buildHomeScreenOptionsIntegrated(),
                        const SizedBox(height: 20),
                        _buildSectionHeader('option_dimensions'.tr),
                        _buildMenuOptionsSize(),
                        const SizedBox(height: 20),
                        _buildSectionHeader('background_and_shadows'.tr),
                        _buildBackgroundAndShadowOptions(),
                        const SizedBox(height: 20),
                        _buildSectionHeader('preview_menu_options'.tr),
                        _buildHomeScreenPreview(),
                      ],
                    ),
                  ),

                  // باقي التبويبات
                  // طريقة العرض
                  SingleChildScrollView(
                    padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize:
                          MainAxisSize.min, // To avoid unbounded height issues
                      children: [
                        _buildSectionHeader('طريقة عرض القائمة'.tr),
                        _buildDisplayModeSetting(),
                        const SizedBox(height: 20),
                        _buildSectionHeader('طريقة عرض المنتجات'.tr),
                        _buildViewModeSetting(),
                        const SizedBox(height: 20),
                        _buildSectionHeader('خيارات العرض'.tr),
                        _buildDisplayOptions(),
                      ],
                    ),
                  ),

                  // أبعاد البطاقات
                  SingleChildScrollView(
                    padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize:
                          MainAxisSize.min, // To avoid unbounded height issues
                      children: [
                        _buildSectionHeader('حجم الشاشة المستهدف'.tr),
                        _buildScreenSizeSelector(),
                        const SizedBox(height: 20),
                        _buildSectionHeader('أبعاد البطاقات'.tr),
                        _buildCardDimensionsSettings(),
                      ],
                    ),
                  ),

                  // الألوان والخطوط
                  SingleChildScrollView(
                    padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize:
                          MainAxisSize.min, // To avoid unbounded height issues
                      children: [
                        _buildSectionHeader('ألوان النصوص'.tr),
                        _buildTextColorSelector(),
                        const SizedBox(height: 20),
                        _buildSectionHeader('أحجام الخطوط'.tr),
                        _buildFontSizeSettings(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        color: Colors.white,
        child: SafeArea(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: _saveAllSettings,
            child:
                Text('حفظ التغييرات'.tr, style: const TextStyle(fontSize: 16)),
          ),
        ),
      ),
    );
  }

  // عنصر الخلفيات والهوامش المتكررة
  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side:
            BorderSide(color: AppTheme.primaryColor.withOpacity(0.1), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }

  // عناوين الأقسام
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 8, left: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  // خيارات طريقة عرض القائمة
  Widget _buildDisplayModeSetting() {
    return _buildCard(
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'طريقة عرض القائمة'.tr,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              RadioListTile<String>(
                title: Text('عرض الفئات'.tr),
                subtitle: Text('عرض الفئات أولاً ثم المنتجات'.tr),
                value: 'categories',
                groupValue: displayMode.value,
                activeColor: AppTheme.primaryColor,
                onChanged: (value) {
                  displayMode.value = value!;
                },
              ),
              RadioListTile<String>(
                title: Text('عرض المنتجات'.tr),
                subtitle: Text('عرض المنتجات مباشرة'.tr),
                value: 'products',
                groupValue: displayMode.value,
                activeColor: AppTheme.primaryColor,
                onChanged: (value) {
                  displayMode.value = value!;
                },
              ),
            ],
          )),
    );
  }

  // خيارات طريقة عرض المنتجات
  Widget _buildViewModeSetting() {
    return _buildCard(
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'طريقة عرض المنتجات'.tr,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              RadioListTile<String>(
                title: Text('عرض شبكي'.tr),
                subtitle: Text('عرض المنتجات على شكل بطاقات متوازية'.tr),
                value: 'grid',
                groupValue: viewMode.value,
                activeColor: AppTheme.primaryColor,
                onChanged: (value) {
                  viewMode.value = value!;
                },
              ),
              RadioListTile<String>(
                title: Text('عرض قائمة'.tr),
                subtitle: Text('عرض المنتجات على شكل قائمة'.tr),
                value: 'list',
                groupValue: viewMode.value,
                activeColor: AppTheme.primaryColor,
                onChanged: (value) {
                  viewMode.value = value!;
                },
              ),
              RadioListTile<String>(
                title: Text('عرض مدمج'.tr),
                subtitle: Text('عرض المنتجات بشكل مدمج'.tr),
                value: 'compact',
                groupValue: viewMode.value,
                activeColor: AppTheme.primaryColor,
                onChanged: (value) {
                  viewMode.value = value!;
                },
              ),
            ],
          )),
    );
  }

  // خيارات العرض الإضافية
  Widget _buildDisplayOptions() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => SwitchListTile(
                title: Text('عرض الصور'.tr),
                subtitle: Text('عرض صور المنتجات'.tr),
                value: showImages.value,
                activeColor: AppTheme.primaryColor,
                onChanged: (value) {
                  showImages.value = value;
                },
              )),
          Obx(() => SwitchListTile(
                title: Text('استخدام التأثيرات الحركية'.tr),
                subtitle: Text('تفعيل التأثيرات الحركية'.tr),
                value: useAnimations.value,
                activeColor: AppTheme.primaryColor,
                onChanged: (value) {
                  useAnimations.value = value;
                },
              )),
          Obx(() => SwitchListTile(
                title: Text('عرض زر الطلب'.tr),
                subtitle: Text('إظهار زر الطلب مع المنتج'.tr),
                value: showOrderButton.value,
                activeColor: AppTheme.primaryColor,
                onChanged: (value) {
                  showOrderButton.value = value;
                },
              )),
        ],
      ),
    );
  }

  // خيارات حجم البطاقة
  Widget _buildCardSizeSlider() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'حجم البطاقة'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Obx(() => Column(
                children: [
                  Slider(
                    value: cardSize.value,
                    min: 0.8,
                    max: 1.5,
                    divisions: 7,
                    activeColor: AppTheme.primaryColor,
                    label: _getCardSizeLabel(cardSize.value),
                    onChanged: (value) => cardSize.value = value,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('صغير'.tr,
                            style: const TextStyle(color: Colors.grey)),
                        Text('كبير'.tr,
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // معاينة لحجم البطاقة
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 200 * cardSize.value,
                    height: 120 * cardSize.value,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'معاينة الحجم'.tr,
                      style: TextStyle(
                        fontSize: 14 * cardSize.value,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  // اختيار حجم الشاشة
  Widget _buildScreenSizeSelector() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'حجم الشاشة المستهدف'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Obx(() => Column(
                children: [
                  RadioListTile<bool>(
                    title: Text('الشاشات الكبيرة'.tr),
                    subtitle: const Text(
                      'تخصيص أبعاد مناسبة للشاشات الكبيرة (عرض: 260، ارتفاع: 310، صورة: 150)',
                      style: TextStyle(fontSize: 12),
                    ),
                    value: true,
                    groupValue: isLargeScreen.value,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      isLargeScreen.value = true;
                      // تطبيق إعدادات الشاشات الكبيرة
                      productCardWidth.value = 260.0;
                      productCardHeight.value = 310.0;
                      productImageHeight.value = 150.0;
                    },
                  ),
                  RadioListTile<bool>(
                    title: Text('الشاشات الصغيرة'.tr),
                    subtitle: const Text(
                      'تخصيص أبعاد مناسبة للشاشات الصغيرة (عرض: 220، ارتفاع: 240، صورة: 120)',
                      style: TextStyle(fontSize: 12),
                    ),
                    value: false,
                    groupValue: isLargeScreen.value,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      isLargeScreen.value = false;
                      // تطبيق إعدادات الشاشات الصغيرة
                      productCardWidth.value = 220.0;
                      productCardHeight.value = 240.0;
                      productImageHeight.value = 120.0;
                    },
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: Text('تطبيق'.tr),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      // تطبيق الإعدادات مع تعيين حجم الخط وحجم البطاقة المتوسط
                      ViewOptionsHelper.saveScreenSizePreset(
                          isLargeScreen.value);
                    },
                  ),
                ],
              )),
        ],
      ),
    );
  }

  // إعدادات أبعاد البطاقة
  Widget _buildCardDimensionsSettings() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عرض البطاقة
          Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'عرض البطاقة'.tr,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${productCardWidth.value.toStringAsFixed(0)} px',
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: productCardWidth.value,
                    min: 180.0,
                    max: 320.0,
                    divisions: 14,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      productCardWidth.value = value;
                    },
                  ),
                ],
              )),

          const Divider(height: 24),

          // ارتفاع البطاقة
          Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ارتفاع البطاقة'.tr,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${productCardHeight.value.toStringAsFixed(0)} px',
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: productCardHeight.value,
                    min: 180.0,
                    max: 400.0,
                    divisions: 22,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      productCardHeight.value = value;
                    },
                  ),
                ],
              )),

          const Divider(height: 24),

          // ارتفاع الصورة
          Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ارتفاع الصورة'.tr,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${productImageHeight.value.toStringAsFixed(0)} px',
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: productImageHeight.value,
                    min: 80.0,
                    max: 240.0,
                    divisions: 16,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      productImageHeight.value = value;
                    },
                  ),
                ],
              )),

          // معاينة للأبعاد
          const SizedBox(height: 20),
          _buildCardPreview(),
        ],
      ),
    );
  }

  // اختيار لون النص
  Widget _buildTextColorSelector() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'لون عنوان المنتج'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Obx(() => _buildColorSelector(
                selectedColor: Color(selectedTextColor.value),
                onColorChanged: (color) {
                  selectedTextColor.value = color.value;
                },
                title: 'اختيار لون العنوان'.tr,
              )),

          const SizedBox(height: 24),

          Text(
            'لون سعر المنتج'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Obx(() => _buildColorSelector(
                selectedColor: Color(selectedPriceColor.value),
                onColorChanged: (color) {
                  selectedPriceColor.value = color.value;
                },
                title: 'اختيار لون السعر'.tr,
              )),

          const SizedBox(height: 16),
          // نموذج معاينة للألوان
          Obx(() => Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'معاينة النص'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(selectedTextColor.value),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(15.5).toStringAsFixed(3)} د.ب',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(selectedPriceColor.value),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // منتقي الألوان
  Widget _buildColorSelector({
    required Color selectedColor,
    required Function(Color) onColorChanged,
    required String title,
  }) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _showColorPickerDialog(
            context: Get.context!,
            initialColor: selectedColor,
            onColorSelected: onColorChanged,
            title: title,
          ),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: selectedColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              'اضغط لتغيير اللون'.tr,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const Spacer(),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            minimumSize: const Size(40, 40),
            padding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () => _showColorPickerDialog(
            context: Get.context!,
            initialColor: selectedColor,
            onColorSelected: onColorChanged,
            title: title,
          ),
          child: const Icon(Icons.color_lens, color: Colors.white),
        ),
      ],
    );
  }

  // إعدادات حجم الخط
  Widget _buildFontSizeSettings() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // حجم خط عنوان المنتج
          Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'حجم خط العنوان'.tr,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        productTitleFontSize.value.toStringAsFixed(1),
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: productTitleFontSize.value,
                    min: 12.0,
                    max: 24.0,
                    divisions: 12,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      productTitleFontSize.value = value;
                    },
                  ),
                ],
              )),

          const Divider(height: 24),

          // حجم خط سعر المنتج
          Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'حجم خط السعر'.tr,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        productPriceFontSize.value.toStringAsFixed(1),
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: productPriceFontSize.value,
                    min: 10.0,
                    max: 22.0,
                    divisions: 12,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      productPriceFontSize.value = value;
                    },
                  ),
                ],
              )),

          const Divider(height: 24),

          // حجم خط زر الطلب
          Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'حجم خط الزر'.tr,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        productButtonFontSize.value.toStringAsFixed(1),
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: productButtonFontSize.value,
                    min: 10.0,
                    max: 20.0,
                    divisions: 10,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      productButtonFontSize.value = value;
                    },
                  ),
                ],
              )),

          // معاينة أحجام الخطوط
          const SizedBox(height: 20),
          _buildFontSizePreview(),
        ],
      ),
    );
  }

  // خيارات الشاشة الرئيسية
  Widget _buildHomeScreenOptions() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // خلفية شفافة للخيارات
          Obx(() => SwitchListTile(
                title: Text('خلفية شفافة للخيارات'.tr),
                subtitle: Text('استخدام خلفية شفافة بدلاً من البيضاء'.tr),
                value: useTransparentCardBackground.value,
                activeColor: AppTheme.primaryColor,
                onChanged: (value) {
                  useTransparentCardBackground.value = value;
                },
              )),

          const Divider(height: 24),

          // استخدام ألوان مخصصة للأيقونات
          Obx(() => SwitchListTile(
                title: Text('استخدام ألوان مخصصة للأيقونات'.tr),
                subtitle: Text('تجاوز الألوان الأصلية للأيقونات'.tr),
                value: useCustomIconColors.value,
                activeColor: AppTheme.primaryColor,
                onChanged: (value) {
                  useCustomIconColors.value = value;
                },
              )),

          const Divider(height: 24),

          // لون نص الخيارات
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('لون نص الخيارات'.tr,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Obx(() => _buildColorSelector(
                selectedColor:
                    controller.getColorFromHex(optionTextColor.value),
                onColorChanged: (color) {
                  optionTextColor.value =
                      '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
                },
                title: 'اختيار لون النص'.tr,
              )),

          const SizedBox(height: 16),

          // لون أيقونة الخيارات
          Obx(() => useCustomIconColors.value
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('لون أيقونة الخيارات'.tr,
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                    ),
                    _buildColorSelector(
                      selectedColor:
                          controller.getColorFromHex(optionIconColor.value),
                      onColorChanged: (color) {
                        optionIconColor.value =
                            '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
                      },
                      title: 'اختيار لون الأيقونة'.tr,
                    ),
                    const SizedBox(height: 16),
                  ],
                )
              : const SizedBox.shrink()),

          // لون حدود الخيارات
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('لون حدود الخيارات'.tr,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Obx(() => _buildColorSelector(
                selectedColor:
                    controller.getColorFromHex(optionBorderColor.value),
                onColorChanged: (color) {
                  optionBorderColor.value =
                      '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
                },
                title: 'اختيار لون الحدود'.tr,
              )),

          const Divider(height: 24),

          // حجم خط الخيارات
          Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'حجم خط الخيارات'.tr,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        optionTextSize.value.toStringAsFixed(1),
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: optionTextSize.value,
                    min: 12.0,
                    max: 20.0,
                    divisions: 8,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      optionTextSize.value = value;
                    },
                  ),
                ],
              )),

          const Divider(height: 24),

          // إعدادات الشاشات الصغيرة
          Obx(() => SwitchListTile(
                title: Text('تفعيل إعدادات الشاشات الصغيرة'.tr),
                subtitle: Text('تطبيق إعدادات خاصة للشاشات الصغيرة'.tr),
                value: useSmallScreenSettings.value,
                activeColor: AppTheme.primaryColor,
                onChanged: (value) {
                  useSmallScreenSettings.value = value;
                },
              )),
        ],
      ),
    );
  }

  // معاينة خيارات الشاشة الرئيسية
  Widget _buildHomeScreenPreview() {
    return _buildCard(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'معاينة خيارات القائمة الرئيسية',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // معاينة خيار من القائمة الرئيسية
            Obx(() {
              // استخراج الألوان والإعدادات
              Color bgColor = controller
                  .getColorFromHex(controller.optionBackgroundColor.value);
              Color textColor =
                  controller.getColorFromHex(controller.optionTextColor.value);
              Color borderColor = controller
                  .getColorFromHex(controller.optionBorderColor.value);
              Color iconColor = controller.useCustomIconColors.value
                  ? controller.getColorFromHex(controller.optionIconColor.value)
                  : AppTheme.primaryColor;

              return Column(
                children: [
                  // معاينة خيار القائمة
                  Container(
                    width: controller.optionWidth.value > 0
                        ? controller.optionWidth.value
                        : double.infinity,
                    height: controller.optionHeight.value,
                    decoration: BoxDecoration(
                      color: bgColor.withOpacity(
                          controller.optionBackgroundOpacity.value),
                      borderRadius: BorderRadius.circular(
                          controller.optionCornerRadius.value),
                      border: Border.all(
                        color: borderColor,
                        width: 1.0,
                      ),
                      boxShadow: controller.useOptionShadows.value
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
                      horizontal: controller.optionPadding.value,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: iconColor,
                            shape: BoxShape.circle,
                            boxShadow: controller.useOptionShadows.value
                                ? [
                                    BoxShadow(
                                      color: iconColor.withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: const Icon(
                            Icons.coffee,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: controller.optionPadding.value / 2),
                        Expanded(
                          child: Text(
                            'قائمة المشروبات',
                            style: TextStyle(
                              fontSize: controller.optionTextSize.value,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 16,
                        ),
                      ],
                    ),
                  ),

                  // مسافة بين الخيارات في المعاينة
                  SizedBox(height: controller.optionSpacing.value),

                  // معاينة خيار آخر
                  Container(
                    width: controller.optionWidth.value > 0
                        ? controller.optionWidth.value
                        : double.infinity,
                    height: controller.optionHeight.value,
                    decoration: BoxDecoration(
                      color: bgColor.withOpacity(
                          controller.optionBackgroundOpacity.value),
                      borderRadius: BorderRadius.circular(
                          controller.optionCornerRadius.value),
                      border: Border.all(
                        color: borderColor,
                        width: 1.0,
                      ),
                      boxShadow: controller.useOptionShadows.value
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
                      horizontal: controller.optionPadding.value,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: iconColor,
                            shape: BoxShape.circle,
                            boxShadow: controller.useOptionShadows.value
                                ? [
                                    BoxShadow(
                                      color: iconColor.withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: const Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: controller.optionPadding.value / 2),
                        Expanded(
                          child: Text(
                            'الإعدادات',
                            style: TextStyle(
                              fontSize: controller.optionTextSize.value,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),

            // شرح للإعدادات المستخدمة
            const SizedBox(height: 16),
            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'شفافية الخلفية: ${(controller.optionBackgroundOpacity.value * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ارتفاع الخيارات: ${controller.optionHeight.value.toInt()} بكسل',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'المسافة بين الخيارات: ${controller.optionSpacing.value.toInt()} بكسل',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'حجم الخط: ${controller.optionTextSize.value.toStringAsFixed(1)} نقطة',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    controller.optionWidth.value > 0
                        ? Text(
                            'عرض الخيارات: ${controller.optionWidth.value.toInt()} بكسل',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          )
                        : Text(
                            'عرض الخيارات: تلقائي',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  // معاينة بطاقة المنتج
  Widget _buildCardPreview() {
    return Obx(() => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'معاينة بطاقة المنتج'.tr,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Container(
                width: productCardWidth.value / 2,
                height: productCardHeight.value / 2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      height: productImageHeight.value / 2,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8)),
                      ),
                      alignment: Alignment.center,
                      child:
                          const Icon(Icons.image, size: 24, color: Colors.grey),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'اسم المنتج',
                              style: TextStyle(
                                fontSize: productTitleFontSize.value / 2,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '2.5 د.ب',
                              style: TextStyle(
                                fontSize: productPriceFontSize.value / 2,
                                fontWeight: FontWeight.bold,
                                color: Color(selectedPriceColor.value),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'الأبعاد: ${productCardWidth.value.toStringAsFixed(0)}x${productCardHeight.value.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ));
  }

  // معاينة أحجام الخط
  Widget _buildFontSizePreview() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Text(
                'عنوان المنتج',
                style: TextStyle(
                  fontSize: productTitleFontSize.value,
                  fontWeight: FontWeight.bold,
                  color: Color(selectedTextColor.value),
                ),
              )),
          const SizedBox(height: 8),
          Obx(() => Text(
                '2.500 د.ب',
                style: TextStyle(
                  fontSize: productPriceFontSize.value,
                  fontWeight: FontWeight.bold,
                  color: Color(selectedPriceColor.value),
                ),
              )),
          const SizedBox(height: 8),
          Obx(() => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'طلب',
                  style: TextStyle(
                    fontSize: productButtonFontSize.value,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  // مربع حوار اختيار اللون
  void _showColorPickerDialog({
    required BuildContext context,
    required Color initialColor,
    required Function(Color) onColorSelected,
    required String title,
  }) {
    Color pickedColor = initialColor;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: initialColor,
              onColorChanged: (Color color) {
                pickedColor = color;
              },
              pickerAreaHeightPercent: 0.8,
              enableAlpha: false,
              displayThumbColor: true,
              showLabel: true,
              paletteType: PaletteType.hsv,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('إلغاء'.tr),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
              onPressed: () {
                onColorSelected(pickedColor);
                Navigator.of(context).pop();
              },
              child: Text('اختيار'.tr),
            ),
          ],
        );
      },
    );
  }

  // حفظ جميع الإعدادات
  void _saveAllSettings() {
    // حفظ إعدادات طريقة العرض
    ViewOptionsHelper.saveViewMode(viewMode.value);
    ViewOptionsHelper.saveShowImages(showImages.value);
    ViewOptionsHelper.saveUseAnimations(useAnimations.value);
    ViewOptionsHelper.saveShowOrderButton(showOrderButton.value);
    ViewOptionsHelper.saveDisplayMode(displayMode.value);
    ViewOptionsHelper.saveCardSize(cardSize.value);
    ViewOptionsHelper.saveTextColor(selectedTextColor.value);
    ViewOptionsHelper.savePriceColor(selectedPriceColor.value);

    // حفظ إعدادات أبعاد المنتجات
    ViewOptionsHelper.saveProductCardWidth(productCardWidth.value);
    ViewOptionsHelper.saveProductCardHeight(productCardHeight.value);
    ViewOptionsHelper.saveProductImageHeight(productImageHeight.value);
    ViewOptionsHelper.saveIsLargeScreen(isLargeScreen.value);

    // حفظ إعدادات أحجام الخطوط
    ViewOptionsHelper.saveProductTitleFontSize(productTitleFontSize.value);
    ViewOptionsHelper.saveProductPriceFontSize(productPriceFontSize.value);
    ViewOptionsHelper.saveProductButtonFontSize(productButtonFontSize.value);

    // حفظ إعدادات الهوم سكرين
    controller.saveCardBackgroundType(
        true); // نستخدم قيمة true دائمًا لأننا نستخدم شفافية متغيرة بدلاً من التبديل
    controller
        .saveOptionBackgroundOpacity(controller.optionBackgroundOpacity.value);
    controller.saveOptionTextColor(controller.optionTextColor.value);
    controller.saveOptionIconColor(controller.optionIconColor.value);
    controller.saveOptionBorderColor(controller.optionBorderColor.value);
    controller.saveOptionTextSize(controller.optionTextSize.value);
    controller.saveUseCustomIconColors(controller.useCustomIconColors.value);
    controller.saveUseOptionShadows(controller.useOptionShadows.value);
    controller.saveOptionWidth(controller.optionWidth.value);
    controller.saveOptionHeight(controller.optionHeight.value);
    controller.saveOptionSpacing(controller.optionSpacing.value);
    controller.saveOptionPadding(controller.optionPadding.value);
    controller.saveOptionCornerRadius(controller.optionCornerRadius.value);
    controller
        .saveOptionBackgroundColor(controller.optionBackgroundColor.value);
    controller
        .saveUseSmallScreenSettings(controller.useSmallScreenSettings.value);

    // تحديث واجهة المستخدم
    Get.find<MenuOptionsController>()
        .update(['home_options_list', 'landscape_options']);

    // عرض رسالة تأكيد
    Get.snackbar(
      'تم الحفظ'.tr,
      'تم حفظ جميع الإعدادات بنجاح'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  // تفسير قيمة حجم البطاقة
  String _getCardSizeLabel(double value) {
    if (value <= 0.9) return 'صغير جداً'.tr;
    if (value <= 1.0) return 'صغير'.tr;
    if (value <= 1.1) return 'متوسط'.tr;
    if (value <= 1.2) return 'كبير'.tr;
    return 'كبير جداً'.tr;
  }

  // إضافة دالة بناء قسم تنسيق خلفية الخيارات
  Widget _buildMenuOptionsBackground(RxString optionBgColor,
      RxDouble optionBgOpacity, RxBool useOptionShadows) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // لون خلفية الخيارات
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('لون خلفية الخيارات'.tr,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Obx(() => _buildColorSelector(
                selectedColor: controller.getColorFromHex(optionBgColor.value),
                onColorChanged: (color) {
                  optionBgColor.value =
                      '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
                },
                title: 'اختيار لون الخلفية'.tr,
              )),

          const SizedBox(height: 24),

          // شفافية خلفية الخيارات
          Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('شفافية الخلفية'.tr,
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                      Text(
                        '${(optionBgOpacity.value * 100).toInt()}%',
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: optionBgOpacity.value,
                    min: 0.0,
                    max: 1.0,
                    divisions: 20,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      optionBgOpacity.value = value;
                    },
                  ),
                ],
              )),

          const SizedBox(height: 16),

          // تفعيل/إلغاء ظلال الخيارات
          Obx(() => SwitchListTile(
                title: Text('تفعيل ظلال الخيارات'.tr),
                subtitle: Text('إضافة ظلال خفيفة وراء الخيارات'.tr),
                value: useOptionShadows.value,
                activeColor: AppTheme.primaryColor,
                onChanged: (value) {
                  useOptionShadows.value = value;
                },
              )),
        ],
      ),
    );
  }

  // إضافة دالة بناء قسم حجم وتباعد الخيارات
  Widget _buildMenuOptionsSize() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عرض الخيارات
          Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('عرض الخيارات'.tr,
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                      Text(
                        controller.optionWidth.value > 0
                            ? '${controller.optionWidth.value.toInt()} px'
                            : 'تلقائي'.tr,
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: controller.optionWidth.value,
                    min: 0.0,
                    max: 300.0,
                    divisions: 30,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      controller.optionWidth.value = value;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('تلقائي'.tr,
                            style: const TextStyle(color: Colors.grey)),
                        Text('300 px',
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              )),

          const Divider(height: 24),

          // ارتفاع الخيارات
          Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ارتفاع الخيارات'.tr,
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                      Text(
                        '${controller.optionHeight.value.toInt()} px',
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: controller.optionHeight.value,
                    min: 30.0,
                    max: 120.0,
                    divisions: 18,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      controller.optionHeight.value = value;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('30 px',
                            style: const TextStyle(color: Colors.grey)),
                        Text('120 px',
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              )),

          const Divider(height: 24),

          // المسافة بين الخيارات
          Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('المسافة بين الخيارات'.tr,
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                      Text(
                        '${controller.optionSpacing.value.toInt()} px',
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: controller.optionSpacing.value,
                    min: 0.0,
                    max: 40.0,
                    divisions: 20,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      controller.optionSpacing.value = value;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('0 px',
                            style: const TextStyle(color: Colors.grey)),
                        Text('40 px',
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              )),

          const Divider(height: 24),

          // التباعد الداخلي للخيارات
          Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('التباعد الداخلي للخيارات'.tr,
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                      Text(
                        '${controller.optionPadding.value.toInt()} px',
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: controller.optionPadding.value,
                    min: 4.0,
                    max: 32.0,
                    divisions: 14,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      controller.optionPadding.value = value;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('4 px',
                            style: const TextStyle(color: Colors.grey)),
                        Text('32 px',
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              )),

          const Divider(height: 24),

          // نصف قطر زوايا الخيارات
          Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('استدارة زوايا الخيارات'.tr,
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                      Text(
                        '${controller.optionCornerRadius.value.toInt()} px',
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: controller.optionCornerRadius.value,
                    min: 0.0,
                    max: 24.0,
                    divisions: 12,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      controller.optionCornerRadius.value = value;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('0 px',
                            style: const TextStyle(color: Colors.grey)),
                        Text('24 px',
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              )),

          const Divider(height: 24),

          // عرض الخيارات
          Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('عرض الخيارات'.tr,
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                      Text(
                        controller.optionWidth.value == 0
                            ? 'تلقائي'
                            : '${controller.optionWidth.value.toInt()} px',
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: controller.optionWidth.value,
                    min: 0.0,
                    max: 300.0,
                    divisions: 30,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      controller.optionWidth.value = value;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('تلقائي (0)',
                            style: const TextStyle(color: Colors.grey)),
                        Text('300 px',
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  // إضافة دالة معاينة خيارات القائمة
  Widget _buildMenuOptionsPreview(
      RxString optionBgColor,
      RxDouble optionBgOpacity,
      RxBool useOptionShadows,
      RxDouble optionWidth,
      RxDouble optionHeight,
      RxDouble optionSpacing,
      RxDouble optionPadding,
      RxDouble optionCornerRadius) {
    return _buildCard(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'معاينة خيارات القائمة',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // عرض الإعدادات الحالية
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('الإعدادات الحالية:',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                SizedBox(height: 8),
                Text(
                    'العرض: ${optionWidth.value == 0 ? "تلقائي" : "${optionWidth.value.toInt()} بكسل"}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                Text('الارتفاع: ${optionHeight.value.toInt()} بكسل',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                Text(
                    'المسافة بين الخيارات: ${optionSpacing.value.toInt()} بكسل',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                Text('التباعد الداخلي: ${optionPadding.value.toInt()} بكسل',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                Text(
                    'استدارة الزوايا: ${optionCornerRadius.value.toInt()} بكسل',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700])),
              ],
            ),
            const SizedBox(height: 16),

            // معاينة خيار من القائمة الرئيسية
            Obx(() {
              Color bgColor = controller.getColorFromHex(optionBgColor.value);
              Color textColor =
                  controller.getColorFromHex(optionTextColor.value);
              Color borderColor =
                  controller.getColorFromHex(optionBorderColor.value);
              Color iconColor = useCustomIconColors.value
                  ? controller.getColorFromHex(optionIconColor.value)
                  : AppTheme.primaryColor;

              return Column(
                children: [
                  // معاينة خيار القائمة
                  Container(
                    width: optionWidth.value > 0
                        ? optionWidth.value
                        : double.infinity,
                    height: optionHeight.value,
                    decoration: BoxDecoration(
                      color: bgColor.withOpacity(optionBgOpacity.value),
                      borderRadius:
                          BorderRadius.circular(optionCornerRadius.value),
                      border: Border.all(
                        color: borderColor,
                        width: 1.0,
                      ),
                      boxShadow: useOptionShadows.value
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
                      horizontal: optionPadding.value,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: iconColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.coffee,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'عنوان الخيار',
                            style: TextStyle(
                              fontSize: optionTextSize.value,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 16,
                        ),
                      ],
                    ),
                  ),

                  // مسافة بين الخيارات في المعاينة
                  SizedBox(height: optionSpacing.value),

                  // معاينة خيار آخر
                  Container(
                    width: double.infinity,
                    height: optionHeight.value,
                    decoration: BoxDecoration(
                      color: bgColor.withOpacity(optionBgOpacity.value),
                      borderRadius:
                          BorderRadius.circular(optionCornerRadius.value),
                      border: Border.all(
                        color: borderColor,
                        width: 1.0,
                      ),
                      boxShadow: useOptionShadows.value
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
                      horizontal: optionPadding.value,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: iconColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'الإعدادات',
                            style: TextStyle(
                              fontSize: optionTextSize.value,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeScreenOptionsIntegrated() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الألوان
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('لون نص الخيارات'.tr,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Obx(() => _buildColorSelector(
                selectedColor: controller
                    .getColorFromHex(controller.optionTextColor.value),
                onColorChanged: (color) {
                  controller.optionTextColor.value =
                      '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
                },
                title: 'اختيار لون النص'.tr,
              )),

          const Divider(height: 24),

          // استخدام ألوان مخصصة للأيقونات
          Obx(() => SwitchListTile(
                title: Text('استخدام ألوان مخصصة للأيقونات'.tr),
                subtitle: Text('تجاوز الألوان الأصلية للأيقونات'.tr),
                value: controller.useCustomIconColors.value,
                activeColor: AppTheme.primaryColor,
                onChanged: (value) {
                  controller.useCustomIconColors.value = value;
                },
              )),

          // لون أيقونة الخيارات (يظهر فقط عند تفعيل الألوان المخصصة)
          Obx(() => controller.useCustomIconColors.value
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('لون أيقونة الخيارات'.tr,
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                    ),
                    _buildColorSelector(
                      selectedColor: controller
                          .getColorFromHex(controller.optionIconColor.value),
                      onColorChanged: (color) {
                        controller.optionIconColor.value =
                            '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
                      },
                      title: 'اختيار لون الأيقونة'.tr,
                    ),
                  ],
                )
              : const SizedBox.shrink()),

          const Divider(height: 24),

          // لون حدود الخيارات
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('لون حدود الخيارات'.tr,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Obx(() => _buildColorSelector(
                selectedColor: controller
                    .getColorFromHex(controller.optionBorderColor.value),
                onColorChanged: (color) {
                  controller.optionBorderColor.value =
                      '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
                },
                title: 'اختيار لون الحدود'.tr,
              )),

          const Divider(height: 24),

          // حجم خط الخيارات
          Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'حجم خط الخيارات'.tr,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        controller.optionTextSize.value.toStringAsFixed(1),
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: controller.optionTextSize.value,
                    min: 10.0,
                    max: 28.0,
                    divisions: 18,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      controller.optionTextSize.value = value;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('10 pt',
                            style: const TextStyle(color: Colors.grey)),
                        Text('28 pt',
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              )),

          const Divider(height: 24),

          // إعدادات الشاشات الصغيرة
          Obx(() => SwitchListTile(
                title: Text('تفعيل إعدادات الشاشات الصغيرة'.tr),
                subtitle: Text('تطبيق إعدادات خاصة للشاشات الصغيرة'.tr),
                value: controller.useSmallScreenSettings.value,
                activeColor: AppTheme.primaryColor,
                onChanged: (value) {
                  controller.useSmallScreenSettings.value = value;
                },
              )),
        ],
      ),
    );
  }

  Widget _buildBackgroundAndShadowOptions() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // لون خلفية الخيارات
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('لون خلفية الخيارات'.tr,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Obx(() => _buildColorSelector(
                selectedColor: controller
                    .getColorFromHex(controller.optionBackgroundColor.value),
                onColorChanged: (color) {
                  controller.optionBackgroundColor.value =
                      '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
                },
                title: 'اختيار لون الخلفية'.tr,
              )),

          const SizedBox(height: 24),

          // شفافية خلفية الخيارات
          Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('شفافية الخلفية'.tr,
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                      Text(
                        '${(controller.optionBackgroundOpacity.value * 100).toInt()}%',
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: controller.optionBackgroundOpacity.value,
                    min: 0.0,
                    max: 1.0,
                    divisions: 20,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      controller.optionBackgroundOpacity.value = value;
                    },
                  ),
                  Text(
                    '0% = خلفية شفافة تماماً، 100% = خلفية معتمة تماماً'.tr,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              )),

          const SizedBox(height: 16),

          // تفعيل/إلغاء ظلال الخيارات
          Obx(() => SwitchListTile(
                title: Text('تفعيل ظلال الخيارات'.tr),
                subtitle: Text('إضافة ظلال خفيفة وراء الخيارات'.tr),
                value: controller.useOptionShadows.value,
                activeColor: AppTheme.primaryColor,
                onChanged: (value) {
                  controller.useOptionShadows.value = value;
                },
              )),
        ],
      ),
    );
  }
}
