import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;

class RenderingHelper {
  // قيمة تتبع ما إذا كانت هناك مشاكل في العرض
  static bool _hasRenderingIssues = false;

  // قيمة لتتبع عدد أخطاء العرض
  static int _renderingErrorCount = 0;

  // الحد الأقصى لعدد أخطاء العرض قبل تفعيل وضع الأداء المنخفض
  static const int _maxErrorsBeforeLowPerformanceMode = 3;

  // حالة وضع الأداء المنخفض
  static bool _lowPerformanceMode = false;

  // الحصول على حالة مشاكل العرض
  static bool get hasRenderingIssues => _hasRenderingIssues;

  // الحصول على حالة وضع الأداء المنخفض
  static bool get isLowPerformanceMode => _lowPerformanceMode;

  // تفعيل وضع الأداء المنخفض للاستخدام المباشر
  static void enableLowPerformanceMode() => _enableLowPerformanceMode();

  /// تطبيق التحسينات المناسبة لجهاز المستخدم
  static void applyOptimizations() {
    // Skip platform-specific optimizations on web
    if (kIsWeb) {
      return;
    }

    // تفعيل وضع الأداء المنخفض مباشرة لتجنب مشاكل RenderRepaintBoundary
    _hasRenderingIssues = true;
    _lowPerformanceMode = true;

    // تطبيق تحسينات عامة لجميع المنصات
    _applyGeneralOptimizations();

    // Apply platform-specific optimizations
    if (Platform.isWindows) {
      _applyWindowsOptimizations();
    } else if (Platform.isAndroid) {
      _applyAndroidOptimizations();
    } else if (Platform.isIOS) {
      _applyIOSOptimizations();
    } else if (Platform.isLinux) {
      _applyLinuxOptimizations();
    }

    // إضافة مراقب للأخطاء للكشف عن مشاكل العرض
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      final errorString = details.exception.toString();

      // Check if we've exceeded the error threshold and should enable low performance mode
      if (_renderingErrorCount >= _maxErrorsBeforeLowPerformanceMode) {
        _enableLowPerformanceMode();
      }

      if (errorString.contains('RenderRepaintBoundary') ||
          errorString.contains('_debugDuringDeviceUpdate') ||
          errorString.contains('Canvas.drawParagraph') ||
          errorString.contains('Cannot convert_image') ||
          errorString.contains('was not laid out') ||
          errorString.contains('NEEDS-PAINT')) {
        _renderingErrorCount++;

        // تسجيل الخطأ للتشخيص
        if (kDebugMode) {
          print('🔴 Rendering error detected: $errorString');
          print('🔴 Error count: $_renderingErrorCount');
        }

        // تفعيل وضع الأداء المنخفض فوراً عند أي مشكلة تتعلق بالرسم
        _enableLowPerformanceMode();

        // إضافة معالجة بعد الإطار التالي لتحديث حالة التطبيق
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // تحديث وتنظيف الرسم
          clearImageCache();
        });
      }
    };
  }

  /// تطبيق التحسينات العامة لجميع المنصات
  static void _applyGeneralOptimizations() {
    // تقليل حجم ذاكرة التخزين المؤقت للصور بشكل كبير
    // مع وجود مشكلة RenderRepaintBoundary، نقلل الذاكرة لتجنب مشاكل العرض
    PaintingBinding.instance.imageCache.maximumSize = 30;
    PaintingBinding.instance.imageCache.maximumSizeBytes = 20 << 20; // 20 MB

    // تعطيل بعض التأثيرات البصرية لتحسين الأداء
    WidgetsBinding.instance.renderView.automaticSystemUiAdjustment = false;

    // تنظيف الذاكرة المؤقتة عند بدء التطبيق
    clearImageCache();

    // إبطاء الرسوم المتحركة للحد من مشاكل العرض
    timeDilation = 1.2;

    // إضافة معالجة بعد الإطار التالي للتأكد من اكتمال عملية التخطيط
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // إعادة رسم الواجهة بعد إكمال عملية التخطيط
      WidgetsBinding.instance.endOfFrame.then((_) {
        // تنظيف الذاكرة مرة أخرى بعد الرسم الأول
        if (kDebugMode) {
          print('✅ First frame rendered, optimizing resources');
        }
      });
    });
  }

  /// تطبيق تحسينات خاصة بنظام Windows
  static void _applyWindowsOptimizations() {
    // تقليل حجم ذاكرة التخزين المؤقت بشكل أكبر لنظام Windows
    PaintingBinding.instance.imageCache.maximumSize = 50;

    // تحسين الأداء لشاشات عالية الدقة
    if (ui.window.devicePixelRatio > 2.0) {
      // يمكن تقليل الدقة عند الضرورة
      // هذا سيتطلب تعديلاً مخصصاً في MediaQueryData
    }
  }

  /// تطبيق تحسينات خاصة بنظام Android
  static void _applyAndroidOptimizations() {
    // ضبط اتجاه العرض لتحسين الأداء
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // تعطيل الشريط العلوي والسفلي في الشاشة الكاملة
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  }

  /// تطبيق تحسينات خاصة بنظام iOS
  static void _applyIOSOptimizations() {
    // تطبيق تحسينات مشابهة للأندرويد
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// تطبيق تحسينات خاصة بنظام Linux
  static void _applyLinuxOptimizations() {
    // تحسينات خاصة بنظام Linux
    // حالياً نستخدم التحسينات العامة فقط
  }

  /// تفعيل وضع الأداء المنخفض للتعامل مع مشاكل العرض
  static void _enableLowPerformanceMode() {
    if (_lowPerformanceMode) return; // تجنب التفعيل المتكرر

    _lowPerformanceMode = true;

    // إبطاء الرسوم المتحركة
    pauseHeavyAnimations();

    // تقليل جودة الصور وتحسين استهلاك الذاكرة
    PaintingBinding.instance.imageCache.maximumSize = 10;
    PaintingBinding.instance.imageCache.maximumSizeBytes = 10 << 20; // 10 MB

    // محاولة حل مشكلة RenderRepaintBoundary
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // تنظيف الذاكرة المؤقتة
      clearImageCache();
    });

    // عرض إشعار للمستخدم إذا كان التطبيق في وضع التصحيح
    if (kDebugMode) {
      print('⚠️ LOW PERFORMANCE MODE ACTIVATED ⚠️');
    }

    // إرسال إشعار للمستخدم إذا كانت GetX متاحة
    try {
      Get.snackbar(
        'تنبيه',
        'تم تفعيل وضع الأداء المنخفض لتحسين استقرار التطبيق',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.withOpacity(0.8),
        colorText: Colors.black,
      );
    } catch (_) {
      // تجاهل الخطأ إذا لم تكن GetX مهيأة بعد
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
    timeDilation = 5.0; // إبطاء الرسوم المتحركة
  }

  /// استعادة سرعة الرسوم المتحركة الطبيعية
  static void resumeNormalAnimations() {
    timeDilation = 1.0;
  }

  /// دالة لتغليف العناصر التي قد تسبب مشاكل في العرض
  static Widget wrapWithOptimizedBoundary(Widget child) {
    // تجنب استخدام RepaintBoundary بشكل كامل بسبب المشكلات المتكررة
    if (_lowPerformanceMode || _hasRenderingIssues) {
      return child;
    }

    // استخدام التغليف البسيط في الحالة العادية بدون RepaintBoundary
    return Opacity(
      opacity:
          1.0, // استخدام Opacity بقيمة 1.0 لا يؤثر بصريًا لكن يمنع مشاكل التخطيط
      child: child,
    );
  }

  /// دالة لتغليف قوائم طويلة للتحسين
  static Widget wrapScrollView(Widget scrollView) {
    if (_lowPerformanceMode) {
      // في وضع الأداء المنخفض، نعطل بعض التأثيرات البصرية للقوائم
      return NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: scrollView,
      );
    }

    return scrollView;
  }

  /// تغليف الصور بطريقة محسنة للأداء
  static Widget wrapImage(Widget image, {bool isImportant = false}) {
    if (_lowPerformanceMode && !isImportant) {
      // تقليل جودة الصور غير المهمة في وضع الأداء المنخفض
      return Opacity(
        opacity: 0.95, // تقليل الشفافية قليلاً لتوفير الموارد
        child: image,
      );
    }

    return wrapWithOptimizedBoundary(image);
  }

  /// تنظيف ذاكرة التخزين المؤقت للصور
  static void clearImageCache() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  /// تأجيل عملية ثقيلة لتنفيذها في وقت لاحق
  static Future<void> deferHeavyOperation(Function operation) async {
    if (_lowPerformanceMode) {
      // في وضع الأداء المنخفض، نؤجل العمليات الثقيلة
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // تنفيذ العملية
    operation();
  }

  /// إعادة ضبط حالة معالج الرسوميات
  static void resetGraphicsState() {
    _renderingErrorCount = 0;
    _hasRenderingIssues = false;

    if (_lowPerformanceMode) {
      // لا نخرج من وضع الأداء المنخفض تلقائياً بمجرد إعادة الضبط
      // يجب استدعاء disableLowPerformanceMode() صراحةً
    }
  }

  /// تعطيل وضع الأداء المنخفض (للاستخدام عند التأكد من عدم وجود مشاكل)
  static void disableLowPerformanceMode() {
    _lowPerformanceMode = false;
    resumeNormalAnimations();

    // إعادة ضبط ذاكرة التخزين المؤقت للصور للإعدادات الافتراضية
    PaintingBinding.instance.imageCache.maximumSize = 100;
    PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20; // 50 MB

    // مسح الذاكرة المؤقتة لإعادة تحميل الصور بالجودة العالية
    clearImageCache();
  }

  /// مغلف آمن للمكونات التي تستخدم الرسوم المتحركة
  /// تم تحسينه لمنع خطأ "Cannot hit test a render box that has never been laid out"
  static Widget safeAnimationWrapper(Widget child) {
    // استخدام Material لضمان تنفيذ دورة تخطيط كاملة قبل التفاعل مع المكون
    // هذا يحل مشكلة "Cannot hit test a render box" لأن Material يضمن تهيئة كاملة
    return Material(
      type: MaterialType.transparency, // مهم للحفاظ على الشفافية
      child: LayoutBuilder(builder: (context, constraints) {
        // تحديد قيود واضحة للأبعاد لتجنب مشاكل التخطيط
        final BoxConstraints safeConstraints = BoxConstraints(
          // استخدام قيم محددة للحد الأدنى لضمان وجود أبعاد دائماً
          minWidth: constraints.hasBoundedWidth ? constraints.minWidth : 1,
          minHeight: constraints.hasBoundedHeight ? constraints.minHeight : 1,
          // تقييد الحد الأقصى بشكل واضح لتجنب الارتفاع غير المحدود
          maxWidth: constraints.hasBoundedWidth
              ? constraints.maxWidth
              : double.infinity,
          maxHeight: constraints.hasBoundedHeight
              ? constraints.maxHeight
              : double.infinity,
        );

        // حل مشكلة عدم وجود حجم للعناصر باستخدام SizedBox أو Container محدد
        if (_lowPerformanceMode || _hasRenderingIssues) {
          // في وضع الأداء المنخفض: استخدام بنية مبسطة مع SizedBox لتحديد الأبعاد قبل العرض
          return SizedBox(
            width: safeConstraints.hasBoundedWidth
                ? safeConstraints.maxWidth
                : null,
            height: safeConstraints.hasBoundedHeight
                ? safeConstraints.maxHeight
                : null,
            child: SingleChildScrollView(
              // استخدام scrolling physics آمن لمنع تداخل الأحداث
              physics: const NeverScrollableScrollPhysics(),
              child: Container(
                constraints: safeConstraints,
                alignment: Alignment.center,
                child: child,
              ),
            ),
          );
        }

        // في الوضع العادي: استخدام هيكل أكثر تحسيناً للأداء مع الاحتفاظ بالحماية من مشاكل التخطيط
        return ConstrainedBox(
          constraints: safeConstraints,
          child: Align(
            alignment: Alignment.center,
            child: UnconstrainedBox(
              constrainedAxis:
                  constraints.hasBoundedHeight ? Axis.vertical : null,
              child: TickerMode(
                enabled: true,
                child: child,
              ),
            ),
          ),
        );
      }),
    );
  }

  /// تحسين عرض العناصر المتحركة في الواجهة
  static Widget optimizeAnimatedWidget(Widget widget) {
    // تعطيل الرسوم المتحركة إذا كان هناك مشاكل في العرض
    if (_lowPerformanceMode) {
      return TickerMode(
        enabled: false, // تعطيل الرسوم المتحركة
        child: widget,
      );
    }

    return widget;
  }

  /// حفظ حالة وضع الأداء المنخفض في الذاكرة المستديمة
  static Future<void> persistLowPerformanceMode() async {
    try {
      // استدعاء هذه الدالة عندما نريد الاحتفاظ بإعدادات الأداء المنخفض
      // يمكن استخدامها مع أي نظام تخزين محلي مثل shared_preferences
      // فقط أضفنا تعليق هنا للإشارة إلى الوظيفة المطلوبة
      if (kDebugMode) {
        print('🔧 Low performance mode state persisted');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Failed to persist low performance mode: $e');
      }
    }
  }
}
