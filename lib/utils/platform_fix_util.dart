import 'dart:io';
import 'package:flutter/foundation.dart';

/// Utility class for resolving platform-specific build issues
class PlatformFixUtil {
  /// Checks for common Windows build issues and provides solutions
  static void checkWindowsBuildIssues() {
    if (!kDebugMode) return; // Only run in debug mode
    if (!Platform.isWindows) return; // Only relevant for Windows

    // Check if the ephemeral directory exists
    final ephemeralDir = Directory('windows/flutter/ephemeral');
    if (!ephemeralDir.existsSync()) {
      print(
          '⚠️ Windows ephemeral directory missing. Try running reset_windows_build.bat');
    }
  }

  /// Run this to fix common Windows build issues
  static Future<bool> fixWindowsBuild() async {
    if (!Platform.isWindows) return false;

    try {
      // Clean the project
      await Process.run('flutter', ['clean']);

      // Remove Windows build directories
      if (Directory('build/windows').existsSync()) {
        await Directory('build/windows').delete(recursive: true);
      }

      if (Directory('windows/flutter/ephemeral').existsSync()) {
        await Directory('windows/flutter/ephemeral').delete(recursive: true);
      }

      // Enable Windows desktop
      await Process.run('flutter', ['config', '--enable-windows-desktop']);

      // Get dependencies
      await Process.run('flutter', ['pub', 'get']);

      return true;
    } catch (e) {
      print('❌ Error fixing Windows build: $e');
      return false;
    }
  }
}
