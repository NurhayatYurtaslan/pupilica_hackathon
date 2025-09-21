import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:image/image.dart' as img;
import 'package:pupilica_hackathon/core/helpers/logger.dart';
import 'package:pupilica_hackathon/core/services/platform_ocr_service.dart';

class OCRService {
  static const String _language = 'eng';

  /// Extract text from image file using Tesseract OCR
  static Future<String> extractTextFromImage(String imagePath) async {
    try {
      // Check if OCR is available on current platform
      if (!PlatformOCRService.isOCRAvailable) {
        throw Exception(PlatformOCRService.platformErrorMessage);
      }

      Logger.info('OCR başlatılıyor', category: LogCategory.ocr);

      final result = await FlutterTesseractOcr.extractText(
        imagePath,
        language: _language,
      );

      Logger.success(
        'OCR tamamlandı - ${result.length} karakter',
        category: LogCategory.ocr,
      );

      return result.trim();
    } catch (e) {
      Logger.errorSimple(
        'OCR başarısız: ${e.toString()}',
        category: LogCategory.ocr,
      );

      // Fallback: Return a placeholder text instead of throwing error
      Logger.warning(
        'OCR failed, returning placeholder text',
        category: LogCategory.ocr,
      );

      return "OCR processing failed. Please try again or use a clearer image.";
    }
  }

  /// Extract text from PDF file
  static Future<String> extractTextFromPDF(String pdfPath) async {
    try {
      Logger.info('PDF metin çıkarılıyor', category: LogCategory.ocr);

      // Use pdf_text package for text extraction
      final doc = await PDFDoc.fromPath(pdfPath);
      String extractedText = '';

      for (int i = 1; i <= doc.length; i++) {
        final page = doc.pageAt(i);
        final text = await page.text;
        extractedText += '--- Page $i ---\n$text\n\n';
      }

      Logger.success(
        'PDF tamamlandı - ${extractedText.length} karakter',
        category: LogCategory.ocr,
      );

      return extractedText.trim();
    } catch (e) {
      Logger.errorSimple(
        'PDF başarısız: ${e.toString()}',
        category: LogCategory.ocr,
      );
      throw Exception('Failed to extract text from PDF: $e');
    }
  }

  /// Process image for better OCR results
  static Future<Uint8List> preprocessImage(Uint8List imageBytes) async {
    try {
      Logger.info('Görsel işleniyor', category: LogCategory.ocr);

      // Decode image
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Convert to grayscale for better OCR
      final grayscale = img.grayscale(image);

      // Apply contrast enhancement
      final enhanced = img.contrast(grayscale, contrast: 1.5);

      // Encode back to bytes
      final processedBytes = img.encodePng(enhanced);

      Logger.success(
        'Image preprocessing completed',
        category: LogCategory.ocr,
        data: {
          'originalSize': imageBytes.length,
          'processedSize': processedBytes.length,
        },
      );

      return processedBytes;
    } catch (e) {
      Logger.error(
        'Image preprocessing failed',
        category: LogCategory.ocr,
        data: {'error': e.toString()},
      );
      throw Exception('Failed to preprocess image: $e');
    }
  }

  /// Extract text from file based on its type
  static Future<String> extractTextFromFile(String filePath) async {
    try {
      final file = File(filePath);
      final extension = file.path.split('.').last.toLowerCase();

      Logger.info(
        'Starting text extraction from file',
        category: LogCategory.ocr,
        data: {'filePath': filePath, 'extension': extension},
      );

      switch (extension) {
        case 'png':
        case 'jpg':
        case 'jpeg':
          return await extractTextFromImage(filePath);
        case 'pdf':
          return await extractTextFromPDF(filePath);
        default:
          throw Exception('Unsupported file type: $extension');
      }
    } catch (e) {
      Logger.error(
        'Text extraction from file failed',
        category: LogCategory.ocr,
        data: {'error': e.toString()},
      );
      rethrow;
    }
  }

  /// Validate file type
  static bool isValidFileType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    return ['png', 'jpg', 'jpeg', 'pdf'].contains(extension);
  }

  /// Get supported file extensions
  static List<String> getSupportedExtensions() {
    return ['png', 'jpg', 'jpeg', 'pdf'];
  }
}
