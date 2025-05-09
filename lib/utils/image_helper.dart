import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as img;
import 'package:gpr_coffee_shop/utils/logger_util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// مساعد للتعامل مع الصور في التطبيق
class ImageHelper {
  static const String _logTag = 'ImageHelper';

  /// لتحويل صورة من الأصول إلى ملف
  static Future<File?> assetImageToFile(String assetPath,
      {String? customFileName}) async {
    try {
      // الحصول على دليل المستندات
      final directory = await getApplicationDocumentsDirectory();

      // إنشاء اسم ملف فريد إذا لم يتم تقديمه
      final fileName =
          customFileName ?? '${const Uuid().v4()}_${path.basename(assetPath)}';
      final filePath = path.join(directory.path, fileName);

      // التحقق مما إذا كان الملف موجودًا بالفعل
      final file = File(filePath);
      if (await file.exists()) {
        return file;
      }

      // قراءة بيانات الأصل
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();

      // كتابة البيانات إلى الملف
      await file.writeAsBytes(bytes);
      LoggerUtil.info(_logTag, 'تم تحويل صورة الأصل إلى ملف: $filePath');

      return file;
    } catch (e) {
      LoggerUtil.error(_logTag, 'فشل تحويل صورة الأصل إلى ملف: $e');
      return null;
    }
  }

  /// نسخ ملف صورة إلى دليل التطبيق
  static Future<String?> copyImageToAppDirectory(String sourcePath) async {
    try {
      // الحصول على دليل المستندات
      final directory = await getApplicationDocumentsDirectory();

      // إنشاء اسم ملف فريد
      final fileName =
          'logo_${const Uuid().v4()}.${path.extension(sourcePath).replaceFirst('.', '')}';
      final destinationPath = path.join(directory.path, fileName);

      // نسخ الملف
      final File sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        LoggerUtil.error(_logTag, 'ملف المصدر غير موجود: $sourcePath');
        return null;
      }

      final File destinationFile = await sourceFile.copy(destinationPath);
      LoggerUtil.info(_logTag, 'تم نسخ الصورة إلى: $destinationPath');

      return destinationFile.path;
    } catch (e) {
      LoggerUtil.error(_logTag, 'فشل نسخ الصورة: $e');
      return null;
    }
  }

  /// تغيير حجم صورة وحفظها - تم تعديل واجهة الدالة
  static Future<String?> resizeAndSaveImage(
    String sourcePath, {
    String? outputPath,
    int? targetWidth,
    int? targetHeight,
    bool keepAspectRatio = true,
  }) async {
    try {
      // قراءة الملف المصدر
      final File sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        LoggerUtil.logger.e('ملف المصدر غير موجود: $sourcePath');
        return null;
      }

      // تحديد مسار الملف الناتج إذا لم يكن محدداً
      final String finalOutputPath = outputPath ??
          sourcePath.replaceFirst(
              RegExp(r'\.[^.]+$'), '_resized${path.extension(sourcePath)}');

      final Uint8List sourceBytes = await sourceFile.readAsBytes();
      final img.Image? image = img.decodeImage(sourceBytes);

      if (image == null) {
        LoggerUtil.logger.e('فشل قراءة الصورة: $sourcePath');
        return null;
      }

      // حساب الأبعاد الجديدة مع الحفاظ على نسبة العرض إلى الارتفاع إذا لزم الأمر
      int newWidth = targetWidth ?? image.width;
      int newHeight = targetHeight ?? image.height;

      if (keepAspectRatio) {
        if (targetWidth != null && targetHeight == null) {
          double ratio = image.width / image.height;
          newHeight = (newWidth / ratio).round();
        } else if (targetHeight != null && targetWidth == null) {
          double ratio = image.width / image.height;
          newWidth = (newHeight * ratio).round();
        } else if (targetWidth != null && targetHeight != null) {
          // حساب نسبة التصغير للحفاظ على التناسب
          double widthRatio = newWidth / image.width;
          double heightRatio = newHeight / image.height;
          double ratio = widthRatio < heightRatio ? widthRatio : heightRatio;

          newWidth = (image.width * ratio).round();
          newHeight = (image.height * ratio).round();
        }
      }

      // تغيير حجم الصورة
      final img.Image resizedImage = img.copyResize(
        image,
        width: newWidth,
        height: newHeight,
        interpolation: img.Interpolation.average,
      );

      // تأكد من وجود المجلد
      final directory = path.dirname(finalOutputPath);
      await Directory(directory).create(recursive: true);

      // حفظ الصورة المعدلة
      final File outputFile = File(finalOutputPath);
      await outputFile.writeAsBytes(img.encodePng(resizedImage));

      LoggerUtil.logger.i('تم تغيير حجم الصورة وحفظها في: $finalOutputPath');
      return finalOutputPath;
    } catch (e, stackTrace) {
      LoggerUtil.error('فشل تغيير حجم الصورة: $e', stackTrace);
      return null;
    }
  }

  /// حذف ملف صورة مع التحقق من السلامة
  static Future<bool> safeDeleteImage(String? filePath) async {
    try {
      if (filePath == null ||
          filePath.isEmpty ||
          filePath.startsWith('assets/')) {
        // لا تحذف صور الأصول
        return false;
      }

      final File file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        LoggerUtil.info(_logTag, 'تم حذف الصورة: $filePath');
        return true;
      }
      return false;
    } catch (e) {
      LoggerUtil.error(_logTag, 'فشل حذف الصورة: $e');
      return false;
    }
  }

  /// تحميل صورة من ملف أو أصل مع معالجة الأخطاء
  static Future<ImageProvider> loadImage(String? imagePath) async {
    // إذا كان المسار فارغًا أو null، استخدم صورة افتراضية
    if (imagePath == null || imagePath.isEmpty) {
      return const AssetImage('assets/images/logo.png');
    }

    try {
      if (imagePath.startsWith('assets/')) {
        // تحميل من الأصول
        return AssetImage(imagePath);
      } else {
        // تحميل من نظام الملفات
        final file = File(imagePath);
        if (await file.exists()) {
          return FileImage(file);
        } else {
          LoggerUtil.warning(_logTag,
              'ملف الصورة غير موجود: $imagePath، استخدام الصورة الافتراضية');
          return const AssetImage('assets/images/logo.png');
        }
      }
    } catch (e) {
      LoggerUtil.error(
          _logTag, 'فشل تحميل الصورة: $e، استخدام الصورة الافتراضية');
      return const AssetImage('assets/images/logo.png');
    }
  }

  /// التحقق مما إذا كان مسار الصورة يشير إلى ملف موجود أو أصل
  static Future<bool> isValidImagePath(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) {
      return false;
    }

    if (imagePath.startsWith('assets/')) {
      try {
        await rootBundle.load(imagePath);
        return true;
      } catch (_) {
        return false;
      }
    } else {
      return await File(imagePath).exists();
    }
  }

  /// يعيد مكون Image الذي يعرض إما صورة من الملف أو من الأصول مع معالجة الأخطاء
  static Widget getImageWidget({
    required String? imagePath,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    if (imagePath == null || imagePath.isEmpty) {
      return placeholder ??
          Image.asset('assets/images/logo.png',
              width: width, height: height, fit: fit);
    }

    try {
      if (imagePath.startsWith('assets/')) {
        return Image.asset(
          imagePath,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            LoggerUtil.error(_logTag, 'فشل تحميل صورة الأصل: $error');
            return errorWidget ??
                Image.asset('assets/images/logo.png',
                    width: width, height: height, fit: fit);
          },
        );
      } else {
        return Image.file(
          File(imagePath),
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            LoggerUtil.error(_logTag, 'فشل تحميل ملف الصورة: $error');
            return errorWidget ??
                Image.asset('assets/images/logo.png',
                    width: width, height: height, fit: fit);
          },
        );
      }
    } catch (e) {
      LoggerUtil.error(_logTag, 'استثناء عند إنشاء مكون الصورة: $e');
      return errorWidget ??
          Image.asset('assets/images/logo.png',
              width: width, height: height, fit: fit);
    }
  }

  /// بناء عنصر صورة بناءً على المسار (أصول، ملفات، أو إنترنت)
  static Widget buildImage(
  String? imagePath, {
  BoxFit fit = BoxFit.cover,
  double? width,
  double? height,
  bool isCircular = false,
  Widget placeholder = const Center(child: CircularProgressIndicator()),
  Widget errorWidget = const Icon(Icons.broken_image, size: 50, color: Colors.grey),
}) {
  // إذا كان المسار فارغاً أو null
  if (imagePath == null || imagePath.isEmpty) {
    return errorWidget;
  }

  // إذا كان المسار يشير إلى صورة أصل (assets)
  if (imagePath.startsWith('assets/')) {
    return ClipRRect(
      // تطبيق الشكل الدائري إذا كانت isCircular = true
      borderRadius: BorderRadius.circular(isCircular ? 1000 : 8),
      child: Image.asset(
        imagePath,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          LoggerUtil.logger.e('Error loading asset image: $error');
          return errorWidget;
        },
      ),
    );
  }

  // إذا كان المسار يشير إلى ملف محلي
  if (File(imagePath).existsSync()) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(isCircular ? 1000 : 8),
      child: Image.file(
        File(imagePath),
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          LoggerUtil.logger.e('Error loading local image: $error');
          return errorWidget;
        },
      ),
    );
  }

  // إذا كان المسار يشير إلى URL عبر الإنترنت
  if (imagePath.startsWith('http')) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(isCircular ? 1000 : 8),
      child: CachedNetworkImage(
        imageUrl: imagePath,
        fit: fit,
        width: width,
        height: height,
        placeholder: (context, url) => placeholder,
        errorWidget: (context, url, error) {
          LoggerUtil.logger.e('Error loading network image: $error');
          return errorWidget;
        },
      ),
    );
  }

  // إذا وصلنا إلى هنا، فالمسار غير صحيح
  LoggerUtil.logger.w('Invalid image path: $imagePath');
  return errorWidget;
}

  /// دالة لاختيار صورة من معرض الهاتف أو الكاميرا
  static Future<File?> pickImage({
    required ImageSource source,
    int? maxWidth = 800,
    int? maxHeight = 800,
    int? quality = 80,
  }) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: maxWidth?.toDouble(),
        maxHeight: maxHeight?.toDouble(),
        imageQuality: quality,
      );

      if (pickedFile == null) {
        return null;
      }

      // تحويل XFile إلى File
      return File(pickedFile.path);
    } catch (e, stackTrace) {
      LoggerUtil.error('ImageHelper', 'خطأ في اختيار الصورة: $e', stackTrace);
      return null;
    }
  }

  /// عنصر تحميل للصور
  static Widget _buildLoadingWidget() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
        ),
      ),
    );
  }

  /// عنصر الخطأ الافتراضي للصور
  static Widget _defaultErrorWidget() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image,
              color: Colors.grey[400],
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'الصورة غير متوفرة',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
