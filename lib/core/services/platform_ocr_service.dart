import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pupilica_hackathon/core/helpers/logger.dart';

/// Platform-specific OCR service that handles different platforms
class PlatformOCRService {
  /// Check if OCR is available on current platform
  static bool get isOCRAvailable {
    if (kIsWeb) {
      return true; // Web supports OCR
    } else if (Platform.isIOS) {
      // iOS supports OCR on both simulator and real devices
      return true;
    } else if (Platform.isAndroid) {
      return true; // Android supports OCR
    }
    return false;
  }

  /// Check if running on iOS simulator
  static bool _isSimulator() {
    // This is a simple check - in real implementation you might want to use
    // a more sophisticated method to detect simulator
    return Platform.isIOS && kDebugMode;
  }

  /// Get platform-specific error message
  static String get platformErrorMessage {
    if (kIsWeb) {
      return 'OCR is available on web platform';
    } else if (Platform.isIOS) {
      return 'OCR is available on iOS (simulator and devices)';
    } else if (Platform.isAndroid) {
      return 'OCR is available on Android';
    }
    return 'OCR is not supported on this platform';
  }

  /// Log platform information
  static void logPlatformInfo() {
    Logger.info(
      'Platform OCR Service initialized',
      category: LogCategory.ocr,
      data: {
        'platform': Platform.operatingSystem,
        'isWeb': kIsWeb,
        'isSimulator': Platform.isIOS && _isSimulator(),
        'isOCRAvailable': isOCRAvailable,
        'isDebugMode': kDebugMode,
      },
    );
  }
}
