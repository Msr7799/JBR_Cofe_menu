import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gpr_coffee_shop/utils/logger_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebFileHandler {
  // Save image data on web platforms
  static Future<String?> saveWebImage(XFile pickedFile, String prefix) async {
    try {
      if (!kIsWeb) {
        return null; // Use native file handling
      }

      // Read file as bytes
      final bytes = await pickedFile.readAsBytes();

      // Convert to base64 for storage
      final base64Image = base64Encode(bytes);

      // Create a virtual path for the image
      final virtualPath =
          'web_image_${prefix}_${DateTime.now().millisecondsSinceEpoch}';

      // Save in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(virtualPath, base64Image);

      LoggerUtil.logger.i('Saved web image: $virtualPath');

      // Return the virtual path as identifier
      return virtualPath;
    } catch (e) {
      LoggerUtil.logger.e('Error saving web image: $e');
      return null;
    }
  }

  // Load image data on web platforms
  static Future<Uint8List?> loadWebImage(String path) async {
    try {
      if (!kIsWeb) {
        return null; // Use native file handling
      }

      // Check if this is a web virtual path
      if (!path.startsWith('web_image_')) {
        return null;
      }

      // Load from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final base64Image = prefs.getString(path);

      if (base64Image == null) {
        return null;
      }

      // Decode base64 to bytes
      return base64Decode(base64Image);
    } catch (e) {
      LoggerUtil.logger.e('Error loading web image: $e');
      return null;
    }
  }

  // Widget to display images from various sources including web
  static Widget buildImage(String path, {BoxFit fit = BoxFit.cover}) {
    if (kIsWeb) {
      if (path.startsWith('web_image_')) {
        // Web stored image
        return FutureBuilder<Uint8List?>(
          future: loadWebImage(path),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData && snapshot.data != null) {
              return Image.memory(
                snapshot.data!,
                fit: fit,
              );
            }

            return const Icon(Icons.broken_image);
          },
        );
      } else if (path.startsWith('assets/')) {
        // Asset image
        return Image.asset(
          path,
          fit: fit,
        );
      } else if (path.startsWith('http')) {
        // Network image
        return Image.network(
          path,
          fit: fit,
        );
      }
    }

    // Fallback or non-web platforms
    return const Icon(Icons.image_not_supported);
  }
}
