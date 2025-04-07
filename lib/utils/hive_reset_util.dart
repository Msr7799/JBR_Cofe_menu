import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HiveResetUtil {
  static final logger = Logger();

  /// يحذف جميع ملفات قاعدة بيانات Hive عند تغيير المخطط
  static Future<void> resetHiveData() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final hivePath = Directory('${appDir.path}/hive');

      if (await hivePath.exists()) {
        await hivePath.delete(recursive: true);
        logger.i('تم إعادة ضبط بيانات Hive بنجاح');
      }
    } catch (e) {
      logger.e('خطأ في إعادة ضبط بيانات Hive: $e');
    }
  }

  /// يعرض حوار تأكيد ثم ينفذ إعادة ضبط المصنع للبيانات
  static Future<void> showResetConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إعادة ضبط المصنع'),
        content: const Text(
          'هذا الإجراء سيؤدي إلى حذف جميع البيانات وإعادة التطبيق للإعدادات الافتراضية. '
          'لا يمكن التراجع عن هذا الإجراء.\n\n'
          'هل أنت متأكد من المتابعة؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('إعادة الضبط'),
          ),
        ],
      ),
    );

    if (result == true) {
      // عرض مؤشر تحميل
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      try {
        // تنفيذ إعادة الضبط
        await resetHiveData();

        // إغلاق شاشة التحميل
        Get.back();

        // عرض رسالة نجاح
        Get.snackbar(
          'تمت العملية',
          'تم إعادة ضبط المصنع بنجاح. سيتم إعادة تشغيل التطبيق.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // انتظار لحظة لعرض الرسالة قبل إعادة تشغيل التطبيق
        await Future.delayed(const Duration(seconds: 2));

        // إعادة تشغيل التطبيق
        Get.offAllNamed('/');
      } catch (e) {
        // إغلاق شاشة التحميل
        Get.back();

        // عرض رسالة خطأ
        Get.snackbar(
          'خطأ',
          'حدث خطأ أثناء إعادة ضبط المصنع: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
}
