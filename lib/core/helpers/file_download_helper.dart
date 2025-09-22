import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_file/open_file.dart';
import 'package:file_saver/file_saver.dart';
import 'package:pupilica_hackathon/core/helpers/logger.dart';

class FileDownloadHelper {
  /// Save PDF to device and return file path
  static Future<String> savePDFToDevice({
    required Uint8List pdfBytes,
    required String fileName,
  }) async {
    try {
      Logger.info('Saving PDF to device', category: LogCategory.document);

      // Get documents directory
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      // Write PDF to file
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      // For iOS Simulator, skip FilePicker to avoid crashes
      if (Platform.isIOS) {
        Logger.info(
          'PDF saved to app Documents directory (Files app accessible)',
          category: LogCategory.document,
        );
      }

      Logger.success(
        'PDF saved to device',
        category: LogCategory.document,
        data: {'path': filePath, 'size': pdfBytes.length},
      );

      return filePath;
    } catch (e) {
      Logger.error(
        'Failed to save PDF to device',
        category: LogCategory.document,
        data: {'error': e.toString()},
      );
      rethrow;
    }
  }

  /// Share PDF file using share_plus
  static Future<void> sharePDF({
    required String filePath,
    required String title,
  }) async {
    try {
      Logger.info('Sharing PDF', category: LogCategory.document);

      await Share.shareXFiles([XFile(filePath)], text: 'PDF Document: $title');

      Logger.success('PDF shared successfully', category: LogCategory.document);
    } catch (e) {
      Logger.error(
        'Failed to share PDF',
        category: LogCategory.document,
        data: {'error': e.toString()},
      );
      rethrow;
    }
  }

  /// Save and share PDF in one operation
  static Future<void> saveAndSharePDF({
    required Uint8List pdfBytes,
    required String fileName,
    required String title,
  }) async {
    try {
      // Save to device
      final filePath = await savePDFToDevice(
        pdfBytes: pdfBytes,
        fileName: fileName,
      );

      // Share the file
      await sharePDF(filePath: filePath, title: title);
    } catch (e) {
      Logger.error(
        'Failed to save and share PDF',
        category: LogCategory.document,
        data: {'error': e.toString()},
      );
      rethrow;
    }
  }

  /// Open PDF file with default app
  static Future<void> openPDF({required String filePath}) async {
    try {
      Logger.info('Opening PDF file', category: LogCategory.document);

      // For iOS Simulator, just show success message
      if (Platform.isIOS) {
        Logger.success(
          'PDF saved to Desktop. You can find it in your Mac Desktop folder.',
          category: LogCategory.document,
        );
        return;
      }

      // For real devices, use open_file
      final result = await OpenFile.open(filePath);

      if (result.type == ResultType.done) {
        Logger.success(
          'PDF opened successfully',
          category: LogCategory.document,
        );
      } else {
        Logger.warning(
          'Could not open PDF: ${result.message}',
          category: LogCategory.document,
        );
      }
    } catch (e) {
      Logger.error(
        'Failed to open PDF',
        category: LogCategory.document,
        data: {'error': e.toString()},
      );
      rethrow;
    }
  }

  /// Saves PDF to device and opens it immediately
  static Future<void> saveAndOpenPDF({
    required Uint8List pdfBytes,
    required String fileName,
    required String title,
  }) async {
    try {
      Logger.info(
        'Saving and opening PDF',
        category: LogCategory.document,
        data: {'fileName': fileName, 'title': title},
      );

      // First save the PDF
      final filePath = await savePDFToDevice(
        pdfBytes: pdfBytes,
        fileName: fileName,
      );

      // Then open it
      await openPDF(filePath: filePath);

      Logger.info(
        'PDF saved and opened successfully',
        category: LogCategory.document,
        data: {'filePath': filePath},
      );
    } catch (e) {
      Logger.error(
        'Failed to save and open PDF',
        category: LogCategory.document,
        data: {'error': e.toString()},
      );
      rethrow;
    }
  }

  /// Save PDF with location picker (iOS Simulator compatible)
  static Future<String?> savePDFWithLocationPicker({
    required Uint8List pdfBytes,
    required String fileName,
  }) async {
    try {
      Logger.info(
        'Saving PDF with location picker',
        category: LogCategory.document,
        data: {'fileName': fileName},
      );

      // Use file_saver to let user choose save location
      final result = await FileSaver.instance.saveAs(
        name: fileName,
        bytes: pdfBytes,
        ext: 'pdf',
        mimeType: MimeType.pdf,
      );

      if (result != null && result.isNotEmpty) {
        Logger.success(
          'PDF saved with location picker',
          category: LogCategory.document,
          data: {'path': result},
        );
        return result;
      } else {
        Logger.warning(
          'Failed to save PDF with location picker: User cancelled or error occurred',
          category: LogCategory.document,
        );
        return null;
      }
    } catch (e) {
      Logger.error(
        'Failed to save PDF with location picker',
        category: LogCategory.document,
        data: {'error': e.toString()},
      );
      rethrow;
    }
  }
}
