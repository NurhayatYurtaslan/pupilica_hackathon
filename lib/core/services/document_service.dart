import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pupilica_hackathon/core/helpers/logger.dart';
import 'package:pupilica_hackathon/core/services/ocr_service.dart';

class DocumentService {
  static final ImagePicker _imagePicker = ImagePicker();

  /// Pick multiple documents (iOS and Web)
  static Future<List<DocumentFile>> pickMultipleDocuments() async {
    try {
      Logger.info('Dosya seçici başlatılıyor', category: LogCategory.document);

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: OCRService.getSupportedExtensions(),
        allowMultiple: true,
      );

      if (result == null || result.files.isEmpty) {
        Logger.info('Dosya seçilmedi', category: LogCategory.document);
        return [];
      }

      final documents = <DocumentFile>[];

      for (final file in result.files) {
        if (file.path != null && OCRService.isValidFileType(file.path!)) {
          final document = DocumentFile(
            name: file.name,
            path: file.path!,
            size: file.size,
            type: _getFileType(file.name),
          );
          documents.add(document);
        }
      }

      Logger.success(
        '${documents.length} dosya seçildi',
        category: LogCategory.document,
      );

      return documents;
    } catch (e) {
      Logger.errorSimple(
        'Dosya seçici başarısız: ${e.toString()}',
        category: LogCategory.document,
      );
      throw Exception('Failed to pick documents: $e');
    }
  }

  /// Pick single document
  static Future<DocumentFile?> pickSingleDocument() async {
    try {
      Logger.info(
        'Starting single document picker',
        category: LogCategory.document,
      );

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: OCRService.getSupportedExtensions(),
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        Logger.info('No document selected', category: LogCategory.document);
        return null;
      }

      final file = result.files.first;
      if (file.path != null && OCRService.isValidFileType(file.path!)) {
        final document = DocumentFile(
          name: file.name,
          path: file.path!,
          size: file.size,
          type: _getFileType(file.name),
        );

        Logger.success(
          'Document picked successfully',
          category: LogCategory.document,
          data: {'name': document.name},
        );

        return document;
      }

      return null;
    } catch (e) {
      Logger.error(
        'Single document picker failed',
        category: LogCategory.document,
        data: {'error': e.toString()},
      );
      throw Exception('Failed to pick document: $e');
    }
  }

  /// Take photo with camera
  static Future<DocumentFile?> takePhoto() async {
    try {
      Logger.info('Kamera başlatılıyor', category: LogCategory.document);

      final image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image == null) {
        Logger.info('Fotoğraf çekilmedi', category: LogCategory.document);
        return null;
      }

      final document = DocumentFile(
        name: 'camera_${DateTime.now().millisecondsSinceEpoch}.jpg',
        path: image.path,
        size: await File(image.path).length(),
        type: DocumentType.image,
      );

      Logger.success(
        'Fotoğraf çekildi',
        category: LogCategory.document,
      );

      return document;
    } catch (e) {
      Logger.errorSimple(
        'Kamera başarısız: ${e.toString()}',
        category: LogCategory.document,
      );
      throw Exception('Failed to take photo: $e');
    }
  }

  /// Pick image from gallery
  static Future<DocumentFile?> pickImageFromGallery() async {
    try {
      Logger.info(
        'Starting gallery image picker',
        category: LogCategory.document,
      );

      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) {
        Logger.info(
          'No image selected from gallery',
          category: LogCategory.document,
        );
        return null;
      }

      final document = DocumentFile(
        name: 'gallery_${DateTime.now().millisecondsSinceEpoch}.jpg',
        path: image.path,
        size: await File(image.path).length(),
        type: DocumentType.image,
      );

      Logger.success(
        'Image picked from gallery successfully',
        category: LogCategory.document,
        data: {'path': document.path},
      );

      return document;
    } catch (e) {
      Logger.error(
        'Gallery image picker failed',
        category: LogCategory.document,
        data: {'error': e.toString()},
      );
      throw Exception('Failed to pick image from gallery: $e');
    }
  }

  /// Copy file to app directory
  static Future<String> copyFileToAppDirectory(
    String sourcePath,
    String fileName,
  ) async {
    try {
      Logger.info(
        'Copying file to app directory',
        category: LogCategory.document,
        data: {'sourcePath': sourcePath, 'fileName': fileName},
      );

      final appDir = await getApplicationDocumentsDirectory();
      final documentsDir = Directory('${appDir.path}/documents');

      if (!await documentsDir.exists()) {
        await documentsDir.create(recursive: true);
      }

      final destinationPath = '${documentsDir.path}/$fileName';
      await File(sourcePath).copy(destinationPath);

      Logger.success(
        'File copied successfully',
        category: LogCategory.document,
        data: {'destinationPath': destinationPath},
      );

      return destinationPath;
    } catch (e) {
      Logger.error(
        'File copy failed',
        category: LogCategory.document,
        data: {'error': e.toString()},
      );
      throw Exception('Failed to copy file: $e');
    }
  }

  /// Get file type from file name
  static DocumentType _getFileType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'png':
      case 'jpg':
      case 'jpeg':
        return DocumentType.image;
      case 'pdf':
        return DocumentType.pdf;
      default:
        return DocumentType.unknown;
    }
  }

  /// Get file size in human readable format
  static String getFileSizeString(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

/// Document file model
class DocumentFile {
  final String name;
  final String path;
  final int size;
  final DocumentType type;

  DocumentFile({
    required this.name,
    required this.path,
    required this.size,
    required this.type,
  });

  String get sizeString => DocumentService.getFileSizeString(size);

  String get extension => name.split('.').last.toLowerCase();
}

/// Document type enum
enum DocumentType { image, pdf, unknown }
