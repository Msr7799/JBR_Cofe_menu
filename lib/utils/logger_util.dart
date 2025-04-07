import 'package:logger/logger.dart';

class LoggerUtil {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat:
          DateTimeFormat.onlyTimeAndSinceStart, // Replaced deprecated printTime
    ),
  );

  static Logger get logger => _logger;
}
