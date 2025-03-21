import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/auth_controller.dart';
import 'package:gpr_coffee_shop/screens/admin/admin_dashboard.dart';
import 'package:gpr_coffee_shop/screens/admin/category_management.dart';
import 'package:gpr_coffee_shop/screens/admin/product_management.dart';
// استيراد شاشة سجل الطلبات (تأكد من المسار الصحيح)
import 'package:gpr_coffee_shop/screens/admin/order_history.dart';

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
                    authController.isAdmin.value ? 'المدير' : 'غير مسجل دخول',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'مدير النظام',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // عناصر القائمة
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('لوحة التحكم'),
            onTap: () {
              Get.offAll(() => AdminDashboard());
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('إدارة الفئات'),
            onTap: () {
              Get.to(() => CategoryManagement());
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('إدارة المنتجات'),
            onTap: () {
              Get.to(() => ProductManagement());
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('سجل الطلبات'),
            onTap: () {
              // إزالة كلمة const
              Get.to(() => OrderHistoryScreen());
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('تسجيل الخروج'),
            onTap: () {
              authController.signOut();
            },
          ),
        ],
      ),
    );
  }
}
