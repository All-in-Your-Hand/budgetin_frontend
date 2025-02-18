import 'package:flutter/foundation.dart';

/// A utility class for handling application-wide logging.
/// Provides methods for different log levels and formats the output consistently.
class AppLogger {
  const AppLogger._();

  /// Logs debug information.
  /// Only prints in debug mode.
  ///
  /// [tag] is the category or component generating the log
  /// [message] is the actual log message
  static void debug(String tag, String message) {
    if (kDebugMode) {
      debugPrint('📘 DEBUG [$tag] $message');
    }
  }

  /// Logs informational messages.
  /// Only prints in debug mode.
  ///
  /// [tag] is the category or component generating the log
  /// [message] is the actual log message
  static void info(String tag, String message) {
    if (kDebugMode) {
      debugPrint('📗 INFO [$tag] $message');
    }
  }

  /// Logs warning messages.
  /// Only prints in debug mode.
  ///
  /// [tag] is the category or component generating the log
  /// [message] is the actual log message
  static void warning(String tag, String message) {
    if (kDebugMode) {
      debugPrint('📙 WARNING [$tag] $message');
    }
  }

  /// Logs error messages.
  /// Only prints in debug mode.
  ///
  /// [tag] is the category or component generating the log
  /// [message] is the actual log message
  static void error(String tag, String message) {
    if (kDebugMode) {
      debugPrint('📕 ERROR [$tag] $message');
    }
  }
}
