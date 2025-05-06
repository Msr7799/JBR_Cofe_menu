import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:gpr_coffee_shop/utils/view_options_helper.dart';

class ViewOptionsScreen extends StatelessWidget {
  // استخدام متغيرات Rx لتخزين قيمة وضع العرض وإعدادات الصور
  final RxString viewMode = ViewOptionsHelper.getViewMode().obs;
  final RxBool showImages = ViewOptionsHelper.getShowImages().obs;
  // استخدام المتغيرات الجديدة
  final RxBool useAnimations = ViewOptionsHelper.getUseAnimations().obs;
  final RxBool showOrderButton = ViewOptionsHelper.getShowOrderButton().obs;
  // إضافة متغيرات جديدة للتحكم بحجم الكارت والألوان
  final RxDouble cardSize = ViewOptionsHelper.getCardSize().obs;
  final RxInt selectedTextColor = ViewOptionsHelper.getTextColor().obs;
  final RxInt selectedPriceColor = ViewOptionsHelper.getPriceColor().obs;
  final RxString displayMode = ViewOptionsHelper.getDisplayMode().obs;
  // إضافة متغير للتحكم في خيار "المواصلة بعد إضافة منتج"
  final RxBool continueToIterate = ViewOptionsHelper.getContinueToIterate().obs;

  // إضافة متغيرات جديدة لحجم الخط
  final RxDouble productTitleFontSize =
      ViewOptionsHelper.getProductTitleFontSize().obs;
  final RxDouble productPriceFontSize =
      ViewOptionsHelper.getProductPriceFontSize().obs;
  final RxDouble productButtonFontSize =
      ViewOptionsHelper.getProductButtonFontSize().obs;

  // إضافة متغيرات جديدة لأبعاد بطاقات المنتجات
  final RxDouble productCardWidth = ViewOptionsHelper.getProductCardWidth().obs;
  final RxDouble productCardHeight =
      ViewOptionsHelper.getProductCardHeight().obs;
  final RxDouble productImageHeight =
      ViewOptionsHelper.getProductImageHeight().obs;

  // قائمة الألوان المتاحة للاختيار
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

  // إضافة متغير RxBool للتحكم في حجم الشاشة
  final RxBool isLargeScreen = ViewOptionsHelper.getIsLargeScreen().obs;

  ViewOptionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // نحصل على معلومات حجم الشاشة لتحسين التجربة على الشاشات الصغيرة
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Scaffold(
      appBar: AppBar(
        title: const Text('خيارات العرض'),
        backgroundColor: AppTheme.primaryColor,
      ),
      // استخدام SingleChildScrollView للشاشة بالكامل لضمان التمرير
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('طريقة عرض القائمة'),
            _buildDisplayModeSetting(),
            const SizedBox(height: 20),
            _buildSectionHeader('طريقة عرض المنتجات'),
            _buildCard(
              child: Column(
                children: [
                  // استخدام SingleChildScrollView لقسم طريقة عرض المنتجات
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: _buildViewModeSetting(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionHeader('حجم بطاقات المنتجات'),
            _buildCardSizeSlider(),
            const SizedBox(height: 20),

            // إضافة قسم جديد لتخصيص أبعاد بطاقات المنتجات
            _buildSectionHeader('اختيار حجم الشاشة المستهدفة'),
            _buildScreenSizeSelector(),
            const SizedBox(height: 20),
            _buildSectionHeader('أبعاد بطاقات المنتجات'),
            _buildCardDimensionsSettings(),
            const SizedBox(height: 20),

            // إضافة قسم جديد لتخصيص حجم الخط
            _buildSectionHeader('حجم الخط'),
            _buildFontSizeSettings(),
            const SizedBox(height: 20),

            _buildSectionHeader('ألوان النصوص'),
            _buildTextColorSelector(),
            const SizedBox(height: 20),
            _buildSectionHeader('خيارات العرض'),
            _buildCard(
              child: Column(
                children: [
                  // استخدام SingleChildScrollView للخيارات الإضافية
                  SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Obx(() => SwitchListTile(
                              title: const Text('عرض الصور'),
                              subtitle:
                                  const Text('عرض صور المنتجات في القائمة'),
                              value: showImages.value,
                              activeColor: AppTheme.primaryColor,
                              onChanged: (value) {
                                showImages.value = value;
                                ViewOptionsHelper.saveShowImages(value);
                              },
                            )),
                        const Divider(height: 1),
                        Obx(() => SwitchListTile(
                              title: const Text('استخدام التأثيرات الحركية'),
                              subtitle: const Text(
                                  'تظهر المنتجات بتأثيرات حركية عند التفاعل معها'),
                              value: useAnimations.value,
                              activeColor: AppTheme.primaryColor,
                              onChanged: (value) {
                                useAnimations.value = value;
                                ViewOptionsHelper.saveUseAnimations(value);
                              },
                            )),
                        const Divider(height: 1),
                        Obx(() => SwitchListTile(
                              title: const Text('عرض زر الطلب مباشرة'),
                              subtitle: const Text(
                                  'عرض زر الطلب مباشرة على بطاقة المنتج'),
                              value: showOrderButton.value,
                              activeColor: AppTheme.primaryColor,
                              onChanged: (value) {
                                showOrderButton.value = value;
                                ViewOptionsHelper.saveShowOrderButton(value);
                              },
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionHeader('هل ترغب في المواصلة؟'),
            _buildCard(
              child: Column(
                children: [
                  Obx(() => SwitchListTile(
                        title: const Text('طلب المواصلة بعد إضافة منتج'),
                        subtitle: const Text(
                            'عرض شاشة تأكيد بعد إضافة منتج للسلة تسأل إذا كنت ترغب في المواصلة أو الانتقال للدفع'),
                        value: continueToIterate.value,
                        activeColor: AppTheme.primaryColor,
                        onChanged: (value) {
                          continueToIterate.value = value;
                          ViewOptionsHelper.saveContinueToIterate(value);
                        },
                      )),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('حفظ الإعدادات وتطبيق التغييرات'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  _saveAllSettings();
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // دالة لحفظ جميع الإعدادات دفعة واحدة
  void _saveAllSettings() {
    // إضافة حفظ إعدادات حجم الشاشة
    ViewOptionsHelper.saveIsLargeScreen(isLargeScreen.value);

    // حفظ إعدادات الخط
    ViewOptionsHelper.saveProductTitleFontSize(productTitleFontSize.value);
    ViewOptionsHelper.saveProductPriceFontSize(productPriceFontSize.value);
    ViewOptionsHelper.saveProductButtonFontSize(productButtonFontSize.value);

    // حفظ إعدادات أبعاد البطاقات
    ViewOptionsHelper.saveProductCardWidth(productCardWidth.value);
    ViewOptionsHelper.saveProductCardHeight(productCardHeight.value);
    ViewOptionsHelper.saveProductImageHeight(productImageHeight.value);

    // حفظ وضع العرض والخيارات الأخرى
    ViewOptionsHelper.saveViewMode(viewMode.value);
    ViewOptionsHelper.saveShowImages(showImages.value);
    ViewOptionsHelper.saveUseAnimations(useAnimations.value);
    ViewOptionsHelper.saveShowOrderButton(showOrderButton.value);
    ViewOptionsHelper.saveDisplayMode(displayMode.value);
    ViewOptionsHelper.saveCardSize(cardSize.value);
    ViewOptionsHelper.saveTextColor(selectedTextColor.value);
    ViewOptionsHelper.savePriceColor(selectedPriceColor.value);

    // عرض رسالة تأكيد
    Get.snackbar(
      'تم الحفظ',
      'تم حفظ إعدادات العرض بنجاح',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.7),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  // إضافة ويدجت جديد لإعدادات حجم الخط
  Widget _buildFontSizeSettings() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تخصيص حجم النصوص:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // حجم خط عنوان المنتج
          const Text('حجم خط عنوان المنتج:'),
          Obx(() => Column(
                children: [
                  Slider(
                    value: productTitleFontSize.value,
                    min: 12.0,
                    max: 24.0,
                    divisions: 12,
                    activeColor: AppTheme.primaryColor,
                    label: '${productTitleFontSize.value.toStringAsFixed(1)}',
                    onChanged: (value) => productTitleFontSize.value = value,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('صغير', style: TextStyle(color: Colors.grey)),
                        Text('متوسط', style: TextStyle(color: Colors.grey)),
                        Text('كبير', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  // معاينة لحجم خط العنوان
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'معاينة حجم خط العنوان',
                      style: TextStyle(
                        fontSize: productTitleFontSize.value,
                        fontWeight: FontWeight.bold,
                        color: Color(selectedTextColor.value),
                      ),
                    ),
                  ),
                ],
              )),

          const SizedBox(height: 20),

          // حجم خط سعر المنتج
          const Text('حجم خط سعر المنتج:'),
          Obx(() => Column(
                children: [
                  Slider(
                    value: productPriceFontSize.value,
                    min: 10.0,
                    max: 22.0,
                    divisions: 12,
                    activeColor: AppTheme.primaryColor,
                    label: '${productPriceFontSize.value.toStringAsFixed(1)}',
                    onChanged: (value) => productPriceFontSize.value = value,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('صغير', style: TextStyle(color: Colors.grey)),
                        Text('متوسط', style: TextStyle(color: Colors.grey)),
                        Text('كبير', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  // معاينة لحجم خط السعر
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${(15.5).toStringAsFixed(3)} د.ب',
                      style: TextStyle(
                        fontSize: productPriceFontSize.value,
                        fontWeight: FontWeight.bold,
                        color: Color(selectedPriceColor.value),
                      ),
                    ),
                  ),
                ],
              )),

          const SizedBox(height: 20),

          // حجم خط زر الطلب
          const Text('حجم خط زر الطلب:'),
          Obx(() => Column(
                children: [
                  Slider(
                    value: productButtonFontSize.value,
                    min: 10.0,
                    max: 20.0,
                    divisions: 10,
                    activeColor: AppTheme.primaryColor,
                    label: '${productButtonFontSize.value.toStringAsFixed(1)}',
                    onChanged: (value) => productButtonFontSize.value = value,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('صغير', style: TextStyle(color: Colors.grey)),
                        Text('متوسط', style: TextStyle(color: Colors.grey)),
                        Text('كبير', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  // معاينة لزر الطلب
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        disabledBackgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        'إضافة للطلب',
                        style: TextStyle(
                          fontSize: productButtonFontSize.value,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  // إضافة ويدجت جديد لإعدادات أبعاد بطاقات المنتجات
  Widget _buildCardDimensionsSettings() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تخصيص أبعاد بطاقات المنتجات:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // عرض بطاقة المنتج
          const Text('عرض بطاقة المنتج:'),
          Obx(() => Column(
                children: [
                  Slider(
                    value: productCardWidth.value,
                    min: 150.0,
                    max: 300.0,
                    divisions: 15,
                    activeColor: AppTheme.primaryColor,
                    label: '${productCardWidth.value.toInt()} بكسل',
                    onChanged: (value) => productCardWidth.value = value,
                  ),
                  Text('العرض الحالي: ${productCardWidth.value.toInt()} بكسل',
                      style: const TextStyle(color: Colors.grey)),
                ],
              )),

          const SizedBox(height: 20),

          // ارتفاع بطاقة المنتج
          const Text('ارتفاع بطاقة المنتج:'),
          Obx(() => Column(
                children: [
                  Slider(
                    value: productCardHeight.value,
                    min: 180.0,
                    max: 350.0,
                    divisions: 17,
                    activeColor: AppTheme.primaryColor,
                    label: '${productCardHeight.value.toInt()} بكسل',
                    onChanged: (value) => productCardHeight.value = value,
                  ),
                  Text(
                      'الارتفاع الحالي: ${productCardHeight.value.toInt()} بكسل',
                      style: const TextStyle(color: Colors.grey)),
                ],
              )),

          const SizedBox(height: 20),

          // ارتفاع صورة المنتج
          const Text('ارتفاع صورة المنتج:'),
          Obx(() => Column(
                children: [
                  Slider(
                    value: productImageHeight.value,
                    min: 80.0,
                    max: 200.0,
                    divisions: 12,
                    activeColor: AppTheme.primaryColor,
                    label: '${productImageHeight.value.toInt()} بكسل',
                    onChanged: (value) => productImageHeight.value = value,
                  ),
                  Text(
                      'ارتفاع الصورة الحالي: ${productImageHeight.value.toInt()} بكسل',
                      style: const TextStyle(color: Colors.grey)),
                ],
              )),

          const SizedBox(height: 16),

          // معاينة لبطاقة المنتج بالأبعاد الجديدة
          Obx(() => Container(
                margin: const EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                child: Container(
                  width: productCardWidth.value * 0.8, // تصغير للمعاينة
                  height: productCardHeight.value * 0.8, // تصغير للمعاينة
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height:
                            productImageHeight.value * 0.8, // تصغير للمعاينة
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.image,
                            size: 40, color: Colors.grey),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'معاينة بطاقة المنتج',
                          style: TextStyle(
                            fontSize: productTitleFontSize.value *
                                0.8, // تصغير للمعاينة
                            fontWeight: FontWeight.bold,
                            color: Color(selectedTextColor.value),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '${(15.5).toStringAsFixed(3)} د.ب',
                          style: TextStyle(
                            fontSize: productPriceFontSize.value *
                                0.8, // تصغير للمعاينة
                            fontWeight: FontWeight.bold,
                            color: Color(selectedPriceColor.value),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'إضافة للطلب',
                                style: TextStyle(
                                  fontSize: productButtonFontSize.value *
                                      0.7, // تصغير للمعاينة
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  // إضافة طريقة عرض القائمة (فئات/منتجات)
  Widget _buildDisplayModeSetting() {
    return _buildCard(
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'اختر طريقة عرض القائمة:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // استخدام SingleChildScrollView لضمان التمرير في هذا القسم
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('عرض الفئات والمنتجات'),
                      subtitle: const Text(
                          'عرض الفئات وعند الضغط تظهر المنتجات الخاصة بها'),
                      value: 'categories',
                      groupValue: displayMode.value,
                      activeColor: AppTheme.primaryColor,
                      onChanged: (value) {
                        displayMode.value = value!;
                        ViewOptionsHelper.saveDisplayMode(value);
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('عرض المنتجات مباشرة'),
                      subtitle: const Text(
                          'عرض جميع المنتجات مع إمكانية التصفية حسب الفئة'),
                      value: 'products',
                      groupValue: displayMode.value,
                      activeColor: AppTheme.primaryColor,
                      onChanged: (value) {
                        displayMode.value = value!;
                        ViewOptionsHelper.saveDisplayMode(value);
                      },
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  // تعريف شريحة لتغيير حجم الكارت
  Widget _buildCardSizeSlider() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'حجم بطاقات المنتجات:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Obx(() => SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Column(
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
                        children: const [
                          Text('صغير', style: TextStyle(color: Colors.grey)),
                          Text('متوسط', style: TextStyle(color: Colors.grey)),
                          Text('كبير', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // معاينة لحجم الكارت
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 200 * cardSize.value,
                      height: 120 * cardSize.value,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'معاينة الحجم',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // إضافة اختيار ألوان النصوص
  Widget _buildTextColorSelector() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'لون عناوين المنتجات:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // تحسين اختيار الألوان مع إمكانية التمرير
          Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(
                    availableColors.length,
                    (index) => GestureDetector(
                      onTap: () => selectedTextColor.value =
                          availableColors[index].value,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: availableColors[index],
                        child: selectedTextColor.value ==
                                availableColors[index].value
                            ? const Icon(Icons.check,
                                color: Color.fromARGB(255, 253, 243, 243))
                            : null,
                      ),
                    ),
                  ),
                ),
              )),

          const SizedBox(height: 20),
          const Text(
            'لون أسعار المنتجات:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // تحسين اختيار ألوان الأسعار مع إمكانية التمرير
          Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(
                    availableColors.length,
                    (index) => GestureDetector(
                      onTap: () => selectedPriceColor.value =
                          availableColors[index].value,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: availableColors[index],
                        child: selectedPriceColor.value ==
                                availableColors[index].value
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    ),
                  ),
                ),
              )),

          const SizedBox(height: 16),
          // نموذج معاينة للألوان
          Obx(() => Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 130, 134, 151),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'معاينة عنوان المنتج',
                      style: TextStyle(
                        color: Color(selectedTextColor.value),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(15.5).toStringAsFixed(3)} د.ب',
                      style: TextStyle(
                        color: Color(selectedPriceColor.value),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  String _getCardSizeLabel(double value) {
    if (value <= 0.9) return 'صغير جداً';
    if (value <= 1.0) return 'صغير';
    if (value <= 1.1) return 'متوسط';
    if (value <= 1.2) return 'كبير';
    return 'كبير جداً';
  }

  Widget _buildViewModeSetting() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'اختر طريقة عرض المنتجات:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // تضمين التمرير في اختيارات طرق العرض
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('عرض شبكي (بطاقات)'),
                    subtitle: const Text('عرض المنتجات في شبكة من البطاقات'),
                    value: 'grid',
                    groupValue: viewMode.value,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      viewMode.value = value!;
                      ViewOptionsHelper.saveViewMode(value);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('عرض قائمة'),
                    subtitle: const Text('عرض المنتجات في قائمة عمودية'),
                    value: 'list',
                    groupValue: viewMode.value,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      viewMode.value = value!;
                      ViewOptionsHelper.saveViewMode(value);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('عرض مدمج'),
                    subtitle: const Text('عرض مدمج للمنتجات في صفوف'),
                    value: 'compact',
                    groupValue: viewMode.value,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      viewMode.value = value!;
                      ViewOptionsHelper.saveViewMode(value);
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }

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

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }

  // ثم إضافة قسم جديد قبل قسم أبعاد بطاقات المنتجات
  // بعد _buildSectionHeader('أبعاد بطاقات المنتجات')
  Widget _buildScreenSizeSelector() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'اختر حجم الشاشة المستهدفة:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Obx(() => Column(
                children: [
                  RadioListTile<bool>(
                    title: const Text('شاشات كبيرة'),
                    subtitle: const Text(
                      'أبعاد مناسبة للشاشات الكبيرة (عرض: 260، ارتفاع: 310، صورة: 150)',
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
                    title: const Text('شاشات صغيرة'),
                    subtitle: const Text(
                      'أبعاد مناسبة للشاشات الصغيرة (عرض: 220، ارتفاع: 240، صورة: 120)',
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
                    label: const Text('تطبيق الإعدادات المقترحة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      // تطبيق الإعدادات مع تعيين حجم الخط وحجم البطاقة المتوسط
                      ViewOptionsHelper.saveScreenSizePreset(
                          isLargeScreen.value);

                      // تحديث قيم RX
                      productCardWidth.value =
                          ViewOptionsHelper.getProductCardWidth();
                      productCardHeight.value =
                          ViewOptionsHelper.getProductCardHeight();
                      productImageHeight.value =
                          ViewOptionsHelper.getProductImageHeight();
                      productTitleFontSize.value =
                          ViewOptionsHelper.getProductTitleFontSize();
                      productPriceFontSize.value =
                          ViewOptionsHelper.getProductPriceFontSize();
                      productButtonFontSize.value =
                          ViewOptionsHelper.getProductButtonFontSize();
                      cardSize.value = ViewOptionsHelper.getCardSize();

                      Get.snackbar(
                        'تم التطبيق',
                        'تم تطبيق إعدادات ${isLargeScreen.value ? 'الشاشات الكبيرة' : 'الشاشات الصغيرة'} مع حجم خط وبطاقة متوسط',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green.withOpacity(0.7),
                        colorText: Colors.white,
                      );
                    },
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
