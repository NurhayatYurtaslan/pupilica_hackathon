import 'dart:developer' as developer;

/// Log levels enum
enum LogLevel { debug, info, warning, error, success }

/// Log categories enum
enum LogCategory { splash, navigation, api, database, ui, auth, ocr, general }

/// Simple logger class
class Logger {
  static const String _appName = 'Pupilica AI';

  // Emoji mapping for categories
  static const Map<LogCategory, String> _categoryEmojis = {
    LogCategory.splash: '🚀',
    LogCategory.navigation: '🧭',
    LogCategory.api: '🌐',
    LogCategory.database: '💾',
    LogCategory.ui: '🎨',
    LogCategory.auth: '🔐',
    LogCategory.ocr: '📄',
    LogCategory.general: '📝',
  };

  // Emoji mapping for log levels
  static const Map<LogLevel, String> _levelEmojis = {
    LogLevel.debug: '🐛',
    LogLevel.info: 'ℹ️',
    LogLevel.warning: '⚠️',
    LogLevel.error: '❌',
    LogLevel.success: '✅',
  };

  // Color codes for different log levels
  static const Map<LogLevel, String> _levelColors = {
    LogLevel.debug: '\x1B[37m', // White
    LogLevel.info: '\x1B[34m', // Blue
    LogLevel.warning: '\x1B[33m', // Yellow
    LogLevel.error: '\x1B[31m', // Red
    LogLevel.success: '\x1B[32m', // Green
  };

  static const String _resetColor = '\x1B[0m';

  /// Debug log
  static void debug(
    String message, {
    LogCategory category = LogCategory.general,
    Map<String, dynamic>? data,
  }) {
    _log(message, level: LogLevel.debug, category: category, data: data);
  }

  /// Info log
  static void info(
    String message, {
    LogCategory category = LogCategory.general,
    Map<String, dynamic>? data,
  }) {
    _log(message, level: LogLevel.info, category: category, data: data);
  }

  /// Warning log
  static void warning(
    String message, {
    LogCategory category = LogCategory.general,
    Map<String, dynamic>? data,
  }) {
    _log(message, level: LogLevel.warning, category: category, data: data);
  }

  /// Error log
  static void error(
    String message, {
    LogCategory category = LogCategory.general,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    _log(
      message,
      level: LogLevel.error,
      category: category,
      error: error,
      stackTrace: stackTrace,
      data: data,
    );
  }

  /// Success log
  static void success(
    String message, {
    LogCategory category = LogCategory.general,
    Map<String, dynamic>? data,
  }) {
    _log(message, level: LogLevel.success, category: category, data: data);
  }

  /// Internal logging method
  static void _log(
    String message, {
    required LogLevel level,
    required LogCategory category,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    final timestamp = DateTime.now().toIso8601String();
    final categoryEmoji = _categoryEmojis[category] ?? '📝';
    final levelEmoji = _levelEmojis[level] ?? 'ℹ️';
    final color = _levelColors[level] ?? '\x1B[37m';

    final logMessage = _buildLogMessage(
      message: message,
      level: level,
      category: category,
      timestamp: timestamp,
      categoryEmoji: categoryEmoji,
      levelEmoji: levelEmoji,
      color: color,
      data: data,
    );

    // Print to console with colors
    print('$color$logMessage$_resetColor');

    // Also log to developer console for debugging
    developer.log(
      message,
      name: '$_appName.${category.name.toUpperCase()}',
      level: _getDeveloperLogLevel(level),
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Build formatted log message
  static String _buildLogMessage({
    required String message,
    required LogLevel level,
    required LogCategory category,
    required String timestamp,
    required String categoryEmoji,
    required String levelEmoji,
    required String color,
    Map<String, dynamic>? data,
  }) {
    final buffer = StringBuffer();

    // Header with timestamp and app name
    buffer.write('[$timestamp] $_appName ');

    // Category and level with emojis
    buffer.write('$categoryEmoji ${category.name.toUpperCase()} ');
    buffer.write('$levelEmoji ${level.name.toUpperCase()}: ');

    // Main message
    buffer.write(message);

    // Additional data if provided
    if (data != null && data.isNotEmpty) {
      buffer.write(' | Data: $data');
    }

    return buffer.toString();
  }

  /// Convert our log level to developer log level
  static int _getDeveloperLogLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500; // Fine
      case LogLevel.info:
        return 800; // Info
      case LogLevel.warning:
        return 900; // Warning
      case LogLevel.error:
        return 1000; // Severe
      case LogLevel.success:
        return 800; // Info
    }
  }
}
