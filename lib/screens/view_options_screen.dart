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

  ViewOptionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('خيارات العرض'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('طريقة عرض المنتجات'),
            _buildCard(
              child: Column(
                children: [
                  _buildViewModeSetting(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionHeader('خيارات العرض'),
            _buildCard(
              child: Column(
                children: [
                  Obx(() => SwitchListTile(
                        title: const Text('عرض الصور'),
                        subtitle: const Text('عرض صور المنتجات في القائمة'),
                        value: showImages.value,
                        onChanged: (value) {
                          showImages.value = value;
                          ViewOptionsHelper.saveShowImages(value);
                        },
                      )),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionHeader('تنسيق واجهة المستخدم'),
            _buildCard(
              child: Column(
                children: [
                  Obx(() => SwitchListTile(
                        title: const Text('استخدام التأثيرات الحركية'),
                        subtitle: const Text(
                            'تظهر المنتجات بتأثيرات حركية عند التفاعل معها'),
                        value: useAnimations.value,
                        onChanged: (value) {
                          useAnimations.value = value;
                          ViewOptionsHelper.saveUseAnimations(value);
                        },
                      )),
                  Obx(() => SwitchListTile(
                        title: const Text('عرض زر الطلب مباشرة'),
                        subtitle:
                            const Text('عرض زر الطلب مباشرة على بطاقة المنتج'),
                        value: showOrderButton.value,
                        onChanged: (value) {
                          showOrderButton.value = value;
                          ViewOptionsHelper.saveShowOrderButton(value);
                        },
                      )),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('حفظ الإعدادات'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  // حفظ جميع الإعدادات مرة واحدة للتأكد من تطبيقها
                  ViewOptionsHelper.saveViewMode(viewMode.value);
                  ViewOptionsHelper.saveShowImages(showImages.value);
                  ViewOptionsHelper.saveUseAnimations(useAnimations.value);
                  ViewOptionsHelper.saveShowOrderButton(showOrderButton.value);

                  // عرض رسالة تأكيد
                  Get.snackbar(
                    'تم الحفظ',
                    'تم حفظ إعدادات العرض بنجاح',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green.withOpacity(0.7),
                    colorText: Colors.white,
                    duration: const Duration(seconds: 2),
                  );

                  // العودة للشاشة السابقة بعد الحفظ
                  // Get.back(); // علّق هذا السطر إذا كنت تريد البقاء في الشاشة بعد الحفظ
                },
              ),
            ),
          ],
        ),
      ),
    );
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
            RadioListTile<String>(
              title: const Text('عرض شبكي (شبكة)'),
              subtitle: const Text('عرض المنتجات في شبكة من البطاقات'),
              value: 'grid',
              groupValue: viewMode.value,
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
              onChanged: (value) {
                viewMode.value = value!;
                ViewOptionsHelper.saveViewMode(value);
              },
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
}
