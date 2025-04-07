import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ShareHelper {
  static Future<void> shareText(String title, String text) async {
    try {
      // خيار بسيط: نسخ النص إلى الحافظة فقط وإظهار رسالة
      await Clipboard.setData(ClipboardData(text: text));
      Get.snackbar(
        'تم النسخ',
        'تم نسخ النص إلى الحافظة، يمكنك مشاركته الآن',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  static Future<void> shareIBAN(String iban) async {
    return shareText('رقم IBAN', 'رقم IBAN للدفع: $iban');
  }
}