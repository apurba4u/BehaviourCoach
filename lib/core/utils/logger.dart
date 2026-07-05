import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart' as log;

/// DisciplineOS Logger
/// Centralized logging utility - disabled in release mode
class Logger {
  Logger._();

  static final _logger = log.Logger(
    printer: log.PrettyPrinter(
      lineLength: 80,
    ),
    level: kReleaseMode ? log.Level.off : log.Level.debug,
  );

  static void debug(String message) {
    if (!kReleaseMode) {
      _logger.d(message);
    }
  }

  static void info(String message) {
    if (!kReleaseMode) {
      _logger.i(message);
    }
  }

  static void warning(String message) {
    if (!kReleaseMode) {
      _logger.w(message);
    }
  }

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kReleaseMode) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }
}
