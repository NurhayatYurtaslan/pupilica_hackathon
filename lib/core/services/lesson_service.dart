import 'dart:io';
import 'package:pupilica_hackathon/core/helpers/logger.dart';
import 'package:pupilica_hackathon/core/helpers/local_storage_helper.dart';
import 'package:pupilica_hackathon/core/models/lesson_note.dart';
import 'package:pupilica_hackathon/core/services/ocr_service.dart';
import 'package:pupilica_hackathon/core/services/document_service.dart';

class LessonService {
  static List<LessonNote> _lessonNotes = [];

  /// Initialize lesson service
  static Future<void> initialize() async {
    try {
      Logger.info('Initializing lesson service', category: LogCategory.lesson);

      // Initialize local storage
      await LocalStorageHelper.initialize();

      await _loadLessonNotes();
      Logger.success(
        'Lesson service initialized',
        category: LogCategory.lesson,
        data: {'count': _lessonNotes.length},
      );
    } catch (e) {
      Logger.error(
        'Failed to initialize lesson service',
        category: LogCategory.lesson,
        data: {'error': e.toString()},
      );
    }
  }

  /// Get all lesson notes
  static List<LessonNote> getAllLessonNotes() {
    return List.unmodifiable(_lessonNotes);
  }

  /// Get lesson note by ID
  static LessonNote? getLessonNoteById(String id) {
    try {
      return _lessonNotes.firstWhere((note) => note.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get lesson notes by subject
  static List<LessonNote> getLessonNotesBySubject(String subject) {
    return _lessonNotes
        .where(
          (note) => note.subject.toLowerCase().contains(subject.toLowerCase()),
        )
        .toList();
  }

  /// Add new lesson note
  static Future<LessonNote> addLessonNote({
    required String title,
    required String subject,
    required String description,
    required List<DocumentFile> documents,
  }) async {
    try {
      Logger.info(
        'Adding new lesson note',
        category: LogCategory.lesson,
        data: {
          'title': title,
          'subject': subject,
          'documentCount': documents.length,
        },
      );

      final lessonNote = LessonNote.create(
        title: title,
        subject: subject,
        description: description,
        documents: documents,
      );

      _lessonNotes.add(lessonNote);
      await _saveLessonNotes();

      Logger.success(
        'Lesson note added successfully',
        category: LogCategory.lesson,
        data: {'id': lessonNote.id},
      );

      return lessonNote;
    } catch (e) {
      Logger.error(
        'Failed to add lesson note',
        category: LogCategory.lesson,
        data: {'error': e.toString()},
      );
      throw Exception('Failed to add lesson note: $e');
    }
  }

  /// Process lesson note with OCR
  static Future<LessonNote> processLessonNote(String id) async {
    try {
      Logger.info(
        'Processing lesson note with OCR',
        category: LogCategory.lesson,
        data: {'id': id},
      );

      final lessonNote = getLessonNoteById(id);
      if (lessonNote == null) {
        throw Exception('Lesson note not found');
      }

      if (lessonNote.isProcessed) {
        Logger.info(
          'Lesson note already processed',
          category: LogCategory.lesson,
          data: {'id': id},
        );
        return lessonNote;
      }

      String extractedText = '';

      // Process each document
      for (final document in lessonNote.documents) {
        try {
          final text = await OCRService.extractTextFromFile(document.path);
          extractedText += '--- ${document.name} ---\n$text\n\n';
        } catch (e) {
          Logger.warning(
            'Failed to process document',
            category: LogCategory.lesson,
            data: {'document': document.name, 'error': e.toString()},
          );
          extractedText +=
              '--- ${document.name} ---\n[Error processing this document]\n\n';
        }
      }

      // Update lesson note
      final updatedNote = lessonNote.copyWith(
        extractedText: extractedText.trim(),
        isProcessed: true,
        updatedAt: DateTime.now(),
      );

      final index = _lessonNotes.indexWhere((note) => note.id == id);
      if (index != -1) {
        _lessonNotes[index] = updatedNote;
        await _saveLessonNotes();
      }

      Logger.success(
        'Lesson note processed successfully',
        category: LogCategory.lesson,
        data: {'id': id, 'textLength': extractedText.length},
      );

      return updatedNote;
    } catch (e) {
      Logger.error(
        'Failed to process lesson note',
        category: LogCategory.lesson,
        data: {'error': e.toString()},
      );
      throw Exception('Failed to process lesson note: $e');
    }
  }

  /// Update lesson note
  static Future<LessonNote> updateLessonNote(
    String id, {
    String? title,
    String? subject,
    String? description,
  }) async {
    try {
      Logger.info(
        'Updating lesson note',
        category: LogCategory.lesson,
        data: {'id': id},
      );

      final index = _lessonNotes.indexWhere((note) => note.id == id);
      if (index == -1) {
        throw Exception('Lesson note not found');
      }

      final updatedNote = _lessonNotes[index].copyWith(
        title: title,
        subject: subject,
        description: description,
        updatedAt: DateTime.now(),
      );

      _lessonNotes[index] = updatedNote;
      await _saveLessonNotes();

      Logger.success(
        'Lesson note updated successfully',
        category: LogCategory.lesson,
        data: {'id': id},
      );

      return updatedNote;
    } catch (e) {
      Logger.error(
        'Failed to update lesson note',
        category: LogCategory.lesson,
        data: {'error': e.toString()},
      );
      throw Exception('Failed to update lesson note: $e');
    }
  }

  /// Delete lesson note
  static Future<void> deleteLessonNote(String id) async {
    try {
      Logger.info(
        'Deleting lesson note',
        category: LogCategory.lesson,
        data: {'id': id},
      );

      final index = _lessonNotes.indexWhere((note) => note.id == id);
      if (index == -1) {
        throw Exception('Lesson note not found');
      }

      final lessonNote = _lessonNotes[index];

      // Delete associated files
      for (final document in lessonNote.documents) {
        try {
          final file = File(document.path);
          if (await file.exists()) {
            await file.delete();
          }
        } catch (e) {
          Logger.warning(
            'Failed to delete document file',
            category: LogCategory.lesson,
            data: {'file': document.path, 'error': e.toString()},
          );
        }
      }

      _lessonNotes.removeAt(index);
      await _saveLessonNotes();

      Logger.success(
        'Lesson note deleted successfully',
        category: LogCategory.lesson,
        data: {'id': id},
      );
    } catch (e) {
      Logger.error(
        'Failed to delete lesson note',
        category: LogCategory.lesson,
        data: {'error': e.toString()},
      );
      throw Exception('Failed to delete lesson note: $e');
    }
  }

  /// Search lesson notes
  static List<LessonNote> searchLessonNotes(String query) {
    if (query.isEmpty) return getAllLessonNotes();

    final lowercaseQuery = query.toLowerCase();
    return _lessonNotes
        .where(
          (note) =>
              note.title.toLowerCase().contains(lowercaseQuery) ||
              note.subject.toLowerCase().contains(lowercaseQuery) ||
              note.description.toLowerCase().contains(lowercaseQuery) ||
              note.extractedText.toLowerCase().contains(lowercaseQuery),
        )
        .toList();
  }

  /// Get statistics
  static Map<String, dynamic> getStatistics() {
    final totalNotes = _lessonNotes.length;
    final processedNotes = _lessonNotes
        .where((note) => note.isProcessed)
        .length;
    final totalDocuments = _lessonNotes.fold(
      0,
      (sum, note) => sum + note.documents.length,
    );
    final totalFileSize = _lessonNotes.fold(
      0,
      (sum, note) => sum + note.totalFileSize,
    );

    final subjects = _lessonNotes.map((note) => note.subject).toSet().toList();

    return {
      'totalNotes': totalNotes,
      'processedNotes': processedNotes,
      'pendingNotes': totalNotes - processedNotes,
      'totalDocuments': totalDocuments,
      'totalFileSize': totalFileSize,
      'totalFileSizeString': DocumentService.getFileSizeString(totalFileSize),
      'subjects': subjects,
      'subjectCount': subjects.length,
    };
  }

  /// Load lesson notes from storage
  static Future<void> _loadLessonNotes() async {
    try {
      final jsonList = LocalStorageHelper.getJsonList('lesson_notes');

      if (jsonList == null) {
        _lessonNotes = [];
        return;
      }

      _lessonNotes = jsonList.map((json) => LessonNote.fromJson(json)).toList();

      Logger.info(
        'Lesson notes loaded from storage',
        category: LogCategory.lesson,
        data: {'count': _lessonNotes.length},
      );
    } catch (e) {
      Logger.error(
        'Failed to load lesson notes',
        category: LogCategory.lesson,
        data: {'error': e.toString()},
      );
      _lessonNotes = [];
    }
  }

  /// Save lesson notes to storage
  static Future<void> _saveLessonNotes() async {
    try {
      final jsonList = _lessonNotes.map((note) => note.toJson()).toList();
      final success = await LocalStorageHelper.saveJsonList(
        'lesson_notes',
        jsonList,
      );

      if (!success) {
        throw Exception('Failed to save lesson notes to local storage');
      }

      Logger.info(
        'Lesson notes saved to storage',
        category: LogCategory.lesson,
        data: {'count': _lessonNotes.length},
      );
    } catch (e) {
      Logger.error(
        'Failed to save lesson notes',
        category: LogCategory.lesson,
        data: {'error': e.toString()},
      );
      throw Exception('Failed to save lesson notes: $e');
    }
  }
}
