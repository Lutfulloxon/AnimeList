import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
      printTime: false,
    ),
  );

  /// Debug log - faqat development'da ko'rinadi
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.d(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Info log - muhim ma'lumotlar
  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.i(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Warning log - ogohlantirishlar
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.w(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Error log - xatoliklar
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Success log - muvaffaqiyatli operatsiyalar
  static void success(String message) {
    if (kDebugMode) {
      _logger.i('✅ $message');
    }
  }

  /// API log - API chaqiruvlari
  static void api(String message) {
    if (kDebugMode) {
      _logger.i('🌐 $message');
    }
  }

  /// Cache log - cache operatsiyalari
  static void cache(String message) {
    if (kDebugMode) {
      _logger.i('💾 $message');
    }
  }

  /// Auth log - authentication
  static void auth(String message) {
    if (kDebugMode) {
      _logger.i('🔐 $message');
    }
  }
}
