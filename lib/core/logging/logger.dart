import 'package:flutter/foundation.dart';

/// A structured logging utility for Finora.
class AppLogger {
  const AppLogger._();

  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    _log('DEBUG', message, error, stackTrace);
  }

  static void info(String message, [Object? error, StackTrace? stackTrace]) {
    _log('INFO', message, error, stackTrace);
  }

  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _log('WARNING', message, error, stackTrace);
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _log('ERROR', message, error, stackTrace);
  }

  static void _log(
    String level,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    if (kReleaseMode) return;

    final timestamp = DateTime.now().toIso8601String();
    final logBuffer = StringBuffer('[$timestamp] [$level] $message');

    if (error != null) {
      logBuffer.write('\nError: $error');
    }
    if (stackTrace != null) {
      logBuffer.write('\nStackTrace:\n$stackTrace');
    }

    // ignore: avoid_print
    print(logBuffer.toString());
  }
}
