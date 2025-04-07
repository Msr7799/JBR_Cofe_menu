import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/models/order.dart';

class NotificationService extends GetxService {
  // قائمة لتخزين الإشعارات الحالية
  final RxList<Map<String, dynamic>> notifications =
      <Map<String, dynamic>>[].obs;

  Future<NotificationService> init() async {
    return this;
  }

  // عرض إشعار بسيط داخل التطبيق (بدون إشعارات على مستوى النظام)
  void showOrderNotification(OrderItem item) {
    // إضافة الإشعار إلى القائمة
    notifications.add({
      'id': DateTime.now().millisecondsSinceEpoch,
      'title': 'طلب جديد: ${item.name}',
      'body':
          'الكمية: ${item.quantity} - السعر: ${item.price * item.quantity} د.ب',
      'timestamp': DateTime.now(),
      'read': false,
    });

    // عرض شريط إشعار مؤقت في التطبيق
    Get.snackbar(
      'طلب جديد',
      '${item.name} (${item.quantity}x)',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange.withOpacity(0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      icon: const Icon(Icons.notifications_active, color: Colors.white),
    );
  }

  // عرض إشعار خطأ في التطبيق
  void showError(String title, String message) {
    // إضافة الإشعار إلى القائمة
    notifications.add({
      'id': DateTime.now().millisecondsSinceEpoch,
      'title': title,
      'body': message,
      'timestamp': DateTime.now(),
      'read': false,
      'isError': true,
    });

    // عرض شريط إشعار مؤقت في التطبيق
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  // إضافة طريقة ستاتيك لعرض الخطأ (لدعم الطريقة المستخدمة في الكود)
  static void showAppError({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  // تحديد الإشعار كمقروء
  void markAsRead(int id) {
    final index = notifications.indexWhere((n) => n['id'] == id);
    if (index != -1) {
      notifications[index]['read'] = true;
      notifications.refresh();
    }
  }

  // إزالة إشعار
  void removeNotification(int id) {
    notifications.removeWhere((n) => n['id'] == id);
  }

  // إزالة جميع الإشعارات
  void clearAllNotifications() {
    notifications.clear();
  }
}
