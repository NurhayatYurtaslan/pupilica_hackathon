import 'package:flutter/foundation.dart';

/// Log levels enum
enum LogLevel { debug, info, warning, error, success }

/// Log categories enum
enum LogCategory {
  splash,
  navigation,
  api,
  database,
  ui,
  auth,
  ocr,
  document,
  lesson,
  general,
}

/// Simple logger class
class Logger {
  // Emoji mapping for categories
  static const Map<LogCategory, String> _categoryEmojis = {
    LogCategory.splash: '🚀',
    LogCategory.navigation: '🧭',
    LogCategory.api: '🌐',
    LogCategory.database: '💾',
    LogCategory.ui: '🎨',
    LogCategory.auth: '🔐',
    LogCategory.ocr: '📄',
    LogCategory.document: '📁',
    LogCategory.lesson: '📚',
    LogCategory.general: '📝',
  };

  /// Debug log
  static void debug(
    String message, {
    LogCategory category = LogCategory.general,
    Map<String, dynamic>? data,
  }) {
    _log(message, LogLevel.debug, category, data);
  }

  /// Info log
  static void info(
    String message, {
    LogCategory category = LogCategory.general,
    Map<String, dynamic>? data,
  }) {
    _log(message, LogLevel.info, category, data);
  }

  /// Warning log
  static void warning(
    String message, {
    LogCategory category = LogCategory.general,
    Map<String, dynamic>? data,
  }) {
    _log(message, LogLevel.warning, category, data);
  }

  /// Error log
  static void error(
    String message, {
    LogCategory category = LogCategory.general,
    Map<String, dynamic>? data,
  }) {
    _log(message, LogLevel.error, category, data);
  }

  /// Simple error log (without stack trace)
  static void errorSimple(
    String message, {
    LogCategory category = LogCategory.general,
    Map<String, dynamic>? data,
  }) {
    _log(message, LogLevel.error, category, data);
  }

  /// Success log
  static void success(
    String message, {
    LogCategory category = LogCategory.general,
    Map<String, dynamic>? data,
  }) {
    _log(message, LogLevel.success, category, data);
  }

  /// Internal logging method
  static void _log(
    String message,
    LogLevel level,
    LogCategory category,
    Map<String, dynamic>? data,
  ) {
    final time = DateTime.now().toString().substring(11, 19); // HH:MM:SS
    final categoryEmoji = _categoryEmojis[category] ?? '📝';

    // Build simple log message
    final buffer = StringBuffer();
    buffer.write('[$time] $categoryEmoji $message');

    // Add data if provided
    if (data != null && data.isNotEmpty) {
      buffer.write(' | ');
      data.forEach((key, value) {
        buffer.write('$key: $value, ');
      });
      // Remove last comma and space
      final dataStr = buffer.toString();
      buffer.clear();
      buffer.write(dataStr.substring(0, dataStr.length - 2));
    }

    // Print to console (no colors, no escape codes)
    debugPrint(buffer.toString());
  }
}
