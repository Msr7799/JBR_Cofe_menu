import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/controllers/auth_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    
    // التحقق من صلاحيات المستخدم
    if (!authController.isAdmin.value) {
      // إذا لم يكن المستخدم مديرًا، حوله إلى صفحة تسجيل الدخول
      return const RouteSettings(name: '/login');
    }
    
    // إذا كان لديه صلاحية، استمر في التنقل إلى الوجهة المطلوبة
    return null;
  }
}