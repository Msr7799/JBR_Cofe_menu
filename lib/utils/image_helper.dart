import 'dart:io';
import 'package:flutter/material.dart';

class ImageHelper {
  // مسار الصورة الافتراضية
  static const String placeholderImage = 'assets/images/placeholder.png';

  // بناء عنصر الصورة مع مراعاة الأخطاء
  static Widget buildImage(
    String? imagePath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
  }) {
    // If no image path, use placeholder
    if (imagePath == null || imagePath.isEmpty) {
      return _buildFallbackWidget(width, height);
    }

    // For asset images
    if (imagePath.startsWith('assets/')) {
      return Padding(
        padding: padding,
        child: Image.asset(
          imagePath,
          width: width,
          height: height,
          fit: fit,
          alignment: Alignment.center,
          errorBuilder: (_, error, __) {
            print('Error loading asset image: $imagePath, $error');
            return _buildFallbackWidget(width, height);
          },
        ),
      );
    }
    // إذا كانت الصورة من الإنترنت
    else if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _buildFallbackImage(width, height),
      );
    }
    // إذا كانت الصورة من ملف محلي
    else {
      try {
        final file = File(imagePath);
        if (file.existsSync()) {
          return Image.file(
            file,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (_, __, ___) => _buildFallbackImage(width, height),
          );
        }
        return _buildFallbackImage(width, height);
      } catch (e) {
        return _buildFallbackImage(width, height);
      }
    }
  }

  // Improved fallback widget
  static Widget _buildFallbackWidget(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[100],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.coffee,
              size: width != null ? width * 0.3 : 50,
              color: Colors.brown[300],
            ),
            const SizedBox(height: 8),
            Text(
              "No Image",
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // استخدام الصورة الافتراضية
  static Widget _buildFallbackImage(double? width, double? height) {
    return Image.asset(
      placeholderImage,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildFallbackWidget(width, height),
    );
  }
}
