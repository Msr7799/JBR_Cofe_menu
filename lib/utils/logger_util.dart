import 'package:logger/logger.dart';

class LoggerUtil {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );

  static Logger get logger => _logger;

  // دوال مساعدة لتسهيل استخدام اللوجر
  static void info(String tag, String message) {
    _logger.i('[$tag] $message');
  }

  // حل مشكلة دالة error بتعديل طريقة التمرير للمكتبة الأساسية
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (error != null && stackTrace != null) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    } else if (error != null) {
      _logger.e(message, error: error);
    } else {
      _logger.e(message);
    }
  }
  static void debug(String tag, String message) {
    _logger.d('[$tag] $message');
  }
  static void warning(String tag, String message) {
    _logger.w('[$tag] $message');
  }
 
}
