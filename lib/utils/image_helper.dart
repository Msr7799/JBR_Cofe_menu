import 'dart:io';
import 'package:flutter/material.dart';

class ImageHelper {
  /// بناء صورة مُحسنة من عنوان URL
  static Widget buildImage(
    String? imageUrl, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildErrorPlaceholder(width, height, errorWidget);
    }

    try {
      if (imageUrl.startsWith('assets/')) {
        // صورة من أصول التطبيق
        return Image.asset(
          imageUrl,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) =>
              _buildErrorPlaceholder(width, height, errorWidget),
        );
      } else if (imageUrl.startsWith('http')) {
        // صورة من الإنترنت
        return Image.network(
          imageUrl,
          width: width,
          height: height,
          fit: fit,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildPlaceholder(width, height, placeholder);
          },
          errorBuilder: (context, error, stackTrace) =>
              _buildErrorPlaceholder(width, height, errorWidget),
        );
      } else {
        // صورة محلية من نظام الملفات
        final file = File(imageUrl);
        if (file.existsSync()) {
          return Image.file(
            file,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) =>
                _buildErrorPlaceholder(width, height, errorWidget),
          );
        } else {
          return _buildErrorPlaceholder(width, height, errorWidget);
        }
      }
    } catch (e) {
      return _buildErrorPlaceholder(width, height, errorWidget);
    }
  }

  /// بناء عنصر التحميل
  static Widget _buildPlaceholder(
      double? width, double? height, Widget? customPlaceholder) {
    if (customPlaceholder != null) {
      return customPlaceholder;
    }
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  /// بناء عنصر الخطأ
  static Widget _buildErrorPlaceholder(
      double? width, double? height, Widget? customErrorWidget) {
    if (customErrorWidget != null) {
      return customErrorWidget;
    }
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            size: 40,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            'الصورة غير متوفرة',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
