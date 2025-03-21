import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/controllers/auth_controller.dart';
import 'package:gpr_coffee_shop/screens/admin/login_screen.dart';
import 'package:gpr_coffee_shop/screens/admin/admin_dashboard.dart'; // أضف هذا السطر
import 'package:gpr_coffee_shop/screens/customer/menu_screen.dart';
import 'package:gpr_coffee_shop/screens/settings_screen.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';

class HomeScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // شعار المقهى
            Container(
              height: 200,
              width: double.infinity,
              child: Center(
                child: Neumorphic(
                  style: NeumorphicStyle(
                    depth: 8,
                    intensity: 0.8,
                    shape: NeumorphicShape.concave,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    width: 200,
                    height: 150,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
              ),
            ),

            SizedBox(height: 24),

            // عنوان المقهى
            Text(
              'GPR Coffee Shop',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor, // استخدام لون من AppTheme
              ),
            ),

            SizedBox(height: 40),

            // الأزرار الرئيسية
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildButton(
                    context: context,
                    title: 'قائمة المنتجات',
                    icon: Icons.coffee,
                    onPressed: () => Get.to(() => MenuScreen()),
                  ),
                  SizedBox(height: 16),
                  _buildButton(
                    context: context,
                    title: 'لوحة تحكم المدير',
                    icon: Icons.admin_panel_settings,
                    onPressed: () {
                      // التحقق إذا كان المستخدم مسجل دخول كأدمن
                      if (authController.isAdmin.value) {
                        Get.to(() => AdminDashboard());
                      } else {
                        // إذا لم يكن مسجل، توجيه للشاشة تسجيل الدخول
                        Get.to(() => LoginScreen());
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  _buildButton(
                    context: context,
                    title: 'الإعدادات',
                    icon: Icons.settings,
                    onPressed: () => Get.to(() => SettingsScreen()),
                  ),
                ],
              ),
            ),

            Spacer(),

            // معلومات الاتصال
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone, size: 16),
                  SizedBox(width: 8),
                  Text('رقم التواصل: 123456789',
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: NeumorphicButton(
        style: NeumorphicStyle(
          depth: 8,
          intensity: 0.8,
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, size: 24),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
