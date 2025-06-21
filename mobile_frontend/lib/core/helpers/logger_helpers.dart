import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// [AppLoggerUtils] - dasturda consolega log chiqarish uchun ishlatiladi.
///
/// Misol uchun:
/// ```dart
/// AppLoggerUtil.i("Bu shunchaki info uchun");
/// ```
class AppLoggerUtils {
  /// [Logger] ni instanci.
  static final Logger _logger = Logger(
    printer: PrettyPrinter(),
  );

  /// Debug log uchun.
  ///
  /// [message] - bu consolega chiqariladigan habar.
  static void d(String? message) {
    if (kDebugMode) _logger.d(message);
  }

  /// Info log uchun.
  ///
  /// [message] - bu consolega chiqariladigan habar.
  static void i(String? message) {
    if (kDebugMode) _logger.i(message);
  }

  /// Warning log uchun.
  ///
  /// [message] - bu consolega chiqariladigan habar.
  static void w(String? message) {
    if (kDebugMode) _logger.w(message);
  }

  /// Error log uchun.
  ///
  /// [message] - bu consolega chiqariladigan habar.
  static void e(dynamic message) {
    if (kDebugMode) _logger.e(message);
  }
}
