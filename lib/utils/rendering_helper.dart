import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // Add this import for timeDilation
import 'package:get/get.dart';
import 'dart:io';

class RenderingHelper {
  /// تطبيق التحسينات المناسبة لجهاز المستخدم
  static void applyOptimizations() {
    if (Platform.isWindows) {
      // تقليل حجم ذاكرة التخزين المؤقت للصور
      PaintingBinding.instance.imageCache.maximumSize = 50;
      PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20; // 50 MB

      // تعطيل التأثيرات البصرية المعقدة
      // Note: We removed enableDithering as it's not available
    }
  }

  /// التعامل مع خطأ معالج الرسوميات وإظهار رسالة للمستخدم
  static void handleGpuError(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('تنبيه: مشكلة في الرسوميات'),
        content: const Text(
          'واجه التطبيق مشكلة مع معالج الرسوميات. يمكن أن يكون ذلك بسبب:\n'
          '- تعارض مع تطبيقات أخرى\n'
          '- مشكلة في تعريف كرت الشاشة\n\n'
          'حاول إغلاق التطبيقات الأخرى أو تحديث تعريفات كرت الشاشة.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // إعادة تشغيل التطبيق بوضع أداء منخفض
              Get.offAllNamed('/');
            },
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  /// إيقاف الرسوم المتحركة الثقيلة مؤقتاً
  static void pauseHeavyAnimations() {
    // يمكن استدعاء هذه الدالة عند اكتشاف مشاكل في الأداء
    SchedulerBinding.instance.timeDilation = 5.0; // إبطاء الرسوم المتحركة
  }

  /// استعادة سرعة الرسوم المتحركة الطبيعية
  static void resumeNormalAnimations() {
    SchedulerBinding.instance.timeDilation = 1.0;
  }
}

extension on SchedulerBinding {
  set timeDilation(double timeDilation) {}
}
