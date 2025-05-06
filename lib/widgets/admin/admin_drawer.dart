import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/auth_controller.dart';
import 'package:gpr_coffee_shop/screens/admin/admin_dashboard.dart';
import 'package:gpr_coffee_shop/screens/admin/category_management.dart';
import 'package:gpr_coffee_shop/screens/admin/product_management.dart';
// استيراد شاشة سجل الطلبات (تأكد من المسار الصحيح)
import 'package:gpr_coffee_shop/screens/admin/order_history.dart';
import 'package:gpr_coffee_shop/screens/customer/menu_screen.dart';
import 'package:gpr_coffee_shop/screens/admin/sales_report_screen.dart'; // Importar la pantalla de informes

class AdminDrawer extends StatelessWidget {
  // تهيئة متغير المتحكم عند البناء بدلاً من إعلانه كقيمة ثابتة
  late final AuthController authController;

  AdminDrawer({Key? key}) : super(key: key) {
    // تهيئة متحكم المصادقة في البناء
    authController = Get.find<AuthController>();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // رأس القائمة الجانبية
          Container(
            color: AppTheme.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                Obx(
                  () => Text(
                    // تعديل هذا السطر - AuthController لا يحتوي على خاصية user
                    authController.isAdmin.value
                        ? 'admin'.tr
                        : 'not_logged_in'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'system_admin'.tr,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Reemplazar el resto del contenido con un Expanded + ListView para permitir el scroll
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              children: [
                // عناصر القائمة
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.dashboard),
                  title: Text('dashboard'.tr),
                  onTap: () {
                    Get.offAll(() => const AdminDashboard());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.category),
                  title: Text('category_management'.tr),
                  onTap: () {
                    Get.to(() => CategoryManagement());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.inventory),
                  title: Text('product_management'.tr),
                  onTap: () {
                    Get.to(() => const ProductManagement());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.receipt_long),
                  title: Text('order_history'.tr),
                  onTap: () {
                    // إزالة كلمة const
                    Get.to(() => const OrderHistoryScreen());
                  },
                ),
                // Nueva opción para informes de ventas
                ListTile(
                  leading: const Icon(Icons.insert_chart),
                  title: Text('reports'.tr),
                  onTap: () {
                    Get.to(() => const SalesReportScreen());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.restaurant_menu),
                  title: Text('menu'.tr),
                  onTap: () {
                    // إغلاق الـ Drawer
                    Navigator.of(context).pop();

                    // الانتقال إلى شاشة القائمة
                    Get.to(() => MenuScreen());
                  },
                ),
                const Divider(),
                // إضافة زر العودة للصفحة الرئيسية
                ListTile(
                  leading: const Icon(Icons.home, color: AppTheme.primaryColor),
                  title: Text('home'.tr),
                  onTap: () {
                    // إغلاق القائمة الجانبية
                    Navigator.pop(context);

                    // العودة إلى الصفحة الرئيسية
                    Get.offAllNamed('/');
                  },
                ),
                const Divider(), // فاصل قبل زر تسجيل الخروج
                // إصلاح زر تسجيل الخروج
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: Text('logout'.tr,
                      style: const TextStyle(color: Colors.red)),
                  onTap: () {
                    // إغلاق القائمة الجانبية
                    Navigator.pop(context);

                    // عرض مربع حوار للتأكيد
                    Get.dialog(
                      AlertDialog(
                        title: Text('logout'.tr),
                        content: Text('confirm_logout'.tr),
                        actions: [
                          TextButton(
                            child: Text('cancel'.tr),
                            onPressed: () => Get.back(),
                          ),
                          TextButton(
                            child: Text('logout'.tr),
                            onPressed: () async {
                              final authController = Get.find<AuthController>();

                              // نظرًا لأن الدالة الآن تعيد Future<void>، نحتاج إلى إضافة await
                              await authController.logout();

                              // إغلاق مربع الحوار
                              Get.back();

                              // العودة إلى شاشة تسجيل الدخول
                              Get.offAllNamed('/login');
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                // Reemplazar opción analytics con la nueva de informes
                ListTile(
                  leading: const Icon(Icons.feedback),
                  title: Text('feedback_management'.tr),
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed('/admin/feedback');
                  },
                ),
                // Espaciado inferior para mejorar la experiencia de desplazamiento
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
