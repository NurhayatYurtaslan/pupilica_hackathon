import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pupilica_hackathon/core/helpers/logger.dart';
import 'package:pupilica_hackathon/core/models/lesson_note.dart';

/// Local storage helper using SharedPreferences
class LocalStorageHelper {
  static SharedPreferences? _prefs;
  static const String _prefix = 'pupilica_';

  /// Initialize SharedPreferences
  static Future<void> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      Logger.info('Local storage initialized', category: LogCategory.database);
    } catch (e) {
      Logger.error(
        'Failed to initialize local storage',
        category: LogCategory.database,
        data: {'error': e.toString()},
      );
      throw Exception('Failed to initialize local storage: $e');
    }
  }

  /// Get SharedPreferences instance
  static SharedPreferences get _instance {
    if (_prefs == null) {
      throw Exception(
        'LocalStorageHelper not initialized. Call initialize() first.',
      );
    }
    return _prefs!;
  }

  // String operations
  /// Save string value
  static Future<bool> saveString(String key, String value) async {
    try {
      final result = await _instance.setString('$_prefix$key', value);
      Logger.debug(
        'String saved',
        category: LogCategory.database,
        data: {'key': key, 'valueLength': value.length},
      );
      return result;
    } catch (e) {
      Logger.error(
        'Failed to save string',
        category: LogCategory.database,
        data: {'key': key, 'error': e.toString()},
      );
      return false;
    }
  }

  /// Get string value
  static String? getString(String key) {
    try {
      final value = _instance.getString('$_prefix$key');
      Logger.debug(
        'String retrieved',
        category: LogCategory.database,
        data: {'key': key, 'hasValue': value != null},
      );
      return value;
    } catch (e) {
      Logger.error(
        'Failed to get string',
        category: LogCategory.database,
        data: {'key': key, 'error': e.toString()},
      );
      return null;
    }
  }

  /// Get string with default value
  static String getStringOrDefault(String key, String defaultValue) {
    return getString(key) ?? defaultValue;
  }

  // Int operations
  /// Save int value
  static Future<bool> saveInt(String key, int value) async {
    try {
      final result = await _instance.setInt('$_prefix$key', value);
      Logger.debug(
        'Int saved',
        category: LogCategory.database,
        data: {'key': key, 'value': value},
      );
      return result;
    } catch (e) {
      Logger.error(
        'Failed to save int',
        category: LogCategory.database,
        data: {'key': key, 'error': e.toString()},
      );
      return false;
    }
  }

  /// Get int value
  static int? getInt(String key) {
    try {
      final value = _instance.getInt('$_prefix$key');
      Logger.debug(
        'Int retrieved',
        category: LogCategory.database,
        data: {'key': key, 'hasValue': value != null},
      );
      return value;
    } catch (e) {
      Logger.error(
        'Failed to get int',
        category: LogCategory.database,
        data: {'key': key, 'error': e.toString()},
      );
      return null;
    }
  }

  /// Get int with default value
  static int getIntOrDefault(String key, int defaultValue) {
    return getInt(key) ?? defaultValue;
  }

  // Bool operations
  /// Save bool value
  static Future<bool> saveBool(String key, bool value) async {
    try {
      final result = await _instance.setBool('$_prefix$key', value);
      Logger.debug(
        'Bool saved',
        category: LogCategory.database,
        data: {'key': key, 'value': value},
      );
      return result;
    } catch (e) {
      Logger.error(
        'Failed to save bool',
        category: LogCategory.database,
        data: {'key': key, 'error': e.toString()},
      );
      return false;
    }
  }

  /// Get bool value
  static bool? getBool(String key) {
    try {
      final value = _instance.getBool('$_prefix$key');
      Logger.debug(
        'Bool retrieved',
        category: LogCategory.database,
        data: {'key': key, 'hasValue': value != null},
      );
      return value;
    } catch (e) {
      Logger.error(
        'Failed to get bool',
        category: LogCategory.database,
        data: {'key': key, 'error': e.toString()},
      );
      return null;
    }
  }

  /// Get bool with default value
  static bool getBoolOrDefault(String key, bool defaultValue) {
    return getBool(key) ?? defaultValue;
  }

  // Double operations
  /// Save double value
  static Future<bool> saveDouble(String key, double value) async {
    try {
      final result = await _instance.setDouble('$_prefix$key', value);
      Logger.debug(
        'Double saved',
        category: LogCategory.database,
        data: {'key': key, 'value': value},
      );
      return result;
    } catch (e) {
      Logger.error(
        'Failed to save double',
        category: LogCategory.database,
        data: {'key': key, 'error': e.toString()},
      );
      return false;
    }
  }

  /// Get double value
  static double? getDouble(String key) {
    try {
      final value = _instance.getDouble('$_prefix$key');
      Logger.debug(
        'Double retrieved',
        category: LogCategory.database,
        data: {'key': key, 'hasValue': value != null},
      );
      return value;
    } catch (e) {
      Logger.error(
        'Failed to get double',
        category: LogCategory.database,
        data: {'key': key, 'error': e.toString()},
      );
      return null;
    }
  }

  /// Get double with default value
  static double getDoubleOrDefault(String key, double defaultValue) {
    return getDouble(key) ?? defaultValue;
  }

  // List operations
  /// Save string list
  static Future<bool> saveStringList(String key, List<String> value) async {
    try {
      final result = await _instance.setStringList('$_prefix$key', value);
      Logger.debug(
        'String list saved',
        category: LogCategory.database,
        data: {'key': key, 'listLength': value.length},
      );
      return result;
    } catch (e) {
      Logger.error(
        'Failed to save string list',
        category: LogCategory.database,
        data: {'key': key, 'error': e.toString()},
      );
      return false;
    }
  }

  /// Get string list
  static List<String>? getStringList(String key) {
    try {
      final value = _instance.getStringList('$_prefix$key');
      Logger.debug(
        'String list retrieved',
        category: LogCategory.database,
        data: {'key': key, 'hasValue': value != null},
      );
      return value;
    } catch (e) {
      Logger.error(
        'Failed to get string list',
        category: LogCategory.database,
        data: {'key': key, 'error': e.toString()},
      );
      return null;
    }
  }

  /// Get string list with default value
  static List<String> getStringListOrDefault(
    String key,
    List<String> defaultValue,
  ) {
    return getStringList(key) ?? defaultValue;
  }

  // JSON operations
  /// Save object as JSON
  static Future<bool> saveJson(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = jsonEncode(value);
      final result = await saveString(key, jsonString);
      Logger.debug(
        'JSON saved',
        category: LogCategory.database,
        data: {'key': key, 'jsonLength': jsonString.length},
      );
      return result;
    } catch (e) {
      Logger.error(
        'Failed to save JSON',
        category: LogCategory.database,
        data: {'key': key, 'error': e.toString()},
      );
      return false;
    }
  }

  /// Get object from JSON
  static Map<String, dynamic>? getJson(String key) {
    try {
      final jsonString = getString(key);
      if (jsonString == null) return null;

      final value = jsonDecode(jsonString) as Map<String, dynamic>;
      Logger.debug(
        'JSON retrieved',
        category: LogCategory.database,
        data: {'key': key, 'hasValue': true},
      );
      return value;
    } catch (e) {
      Logger.error(
        'Failed to get JSON',
        category: LogCategory.database,
        data: {'key': key, 'error': e.toString()},
      );
      return null;
    }
  }

  /// Get JSON with default value
  static Map<String, dynamic> getJsonOrDefault(
    String key,
    Map<String, dynamic> defaultValue,
  ) {
    return getJson(key) ?? defaultValue;
  }

  // List of objects operations
  /// Save list of objects as JSON
  static Future<bool> saveJsonList(
    String key,
    List<Map<String, dynamic>> value,
  ) async {
    try {
      final jsonString = jsonEncode(value);
      final result = await saveString(key, jsonString);
      Logger.debug(
        'JSON list saved',
        category: LogCategory.database,
        data: {'key': key, 'listLength': value.length},
      );
      return result;
    } catch (e) {
      Logger.error(
        'Failed to save JSON list',
        category: LogCategory.database,
        data: {'key': key, 'error': e.toString()},
      );
      return false;
    }
  }

  /// Get list of objects from JSON
  static List<Map<String, dynamic>>? getJsonList(String key) {
    try {
      final jsonString = getString(key);
      if (jsonString == null) return null;

      final value = jsonDecode(jsonString) as List;
      final result = value.cast<Map<String, dynamic>>();
      Logger.debug(
        'JSON list retrieved',
        category: LogCategory.database,
        data: {'key': key, 'listLength': result.length},
      );
      return result;
    } catch (e) {
      Logger.error(
        'Failed to get JSON list',
        category: LogCategory.database,
        data: {'key': key, 'error': e.toString()},
      );
      return null;
    }
  }

  /// Get JSON list with default value
  static List<Map<String, dynamic>> getJsonListOrDefault(
    String key,
    List<Map<String, dynamic>> defaultValue,
  ) {
    return getJsonList(key) ?? defaultValue;
  }

  // Utility operations
  /// Check if key exists
  static bool containsKey(String key) {
    try {
      final result = _instance.containsKey('$_prefix$key');
      Logger.debug(
        'Key existence checked',
        category: LogCategory.database,
        data: {'key': key, 'exists': result},
      );
      return result;
    } catch (e) {
      Logger.error(
        'Failed to check key existence',
        category: LogCategory.database,
        data: {'key': key, 'error': e.toString()},
      );
      return false;
    }
  }

  /// Remove key
  static Future<bool> remove(String key) async {
    try {
      final result = await _instance.remove('$_prefix$key');
      Logger.debug(
        'Key removed',
        category: LogCategory.database,
        data: {'key': key, 'success': result},
      );
      return result;
    } catch (e) {
      Logger.error(
        'Failed to remove key',
        category: LogCategory.database,
        data: {'key': key, 'error': e.toString()},
      );
      return false;
    }
  }

  /// Clear all data
  static Future<bool> clear() async {
    try {
      final result = await _instance.clear();
      Logger.info('All data cleared', category: LogCategory.database);
      return result;
    } catch (e) {
      Logger.error(
        'Failed to clear all data',
        category: LogCategory.database,
        data: {'error': e.toString()},
      );
      return false;
    }
  }

  /// Get all keys
  static Set<String> getAllKeys() {
    try {
      final keys = _instance.getKeys();
      final filteredKeys = keys
          .where((key) => key.startsWith(_prefix))
          .map((key) => key.substring(_prefix.length))
          .toSet();

      Logger.debug(
        'All keys retrieved',
        category: LogCategory.database,
        data: {'keyCount': filteredKeys.length},
      );
      return filteredKeys;
    } catch (e) {
      Logger.error(
        'Failed to get all keys',
        category: LogCategory.database,
        data: {'error': e.toString()},
      );
      return <String>{};
    }
  }

  /// Get storage size info
  static Map<String, dynamic> getStorageInfo() {
    try {
      final keys = _instance.getKeys();
      final pupilicaKeys = keys
          .where((key) => key.startsWith(_prefix))
          .toList();

      int totalSize = 0;
      for (final key in pupilicaKeys) {
        final value = _instance.get(key);
        if (value is String) {
          totalSize += value.length;
        } else if (value is List) {
          totalSize += value.length * 10; // Rough estimate
        }
      }

      final info = {
        'totalKeys': pupilicaKeys.length,
        'estimatedSize': totalSize,
        'estimatedSizeKB': (totalSize / 1024).toStringAsFixed(2),
      };

      Logger.debug(
        'Storage info retrieved',
        category: LogCategory.database,
        data: info,
      );
      return info;
    } catch (e) {
      Logger.error(
        'Failed to get storage info',
        category: LogCategory.database,
        data: {'error': e.toString()},
      );
      return {'totalKeys': 0, 'estimatedSize': 0, 'estimatedSizeKB': '0.00'};
    }
  }

  // Lesson Note operations
  /// Save lesson note
  static Future<bool> saveLessonNote(LessonNote lessonNote) async {
    try {
      final lessonJson = lessonNote.toJson();
      final result = await saveJson('lesson_${lessonNote.id}', lessonJson);

      if (result) {
        // Add to lessons list
        final lessons = getLessonNotes();
        final existingIndex = lessons.indexWhere(
          (lesson) => lesson.id == lessonNote.id,
        );

        if (existingIndex >= 0) {
          lessons[existingIndex] = lessonNote;
        } else {
          lessons.add(lessonNote);
        }

        await saveJsonList(
          'lessons',
          lessons.map((lesson) => lesson.toJson()).toList(),
        );

        Logger.success(
          'Lesson note saved',
          category: LogCategory.database,
          data: {'lessonId': lessonNote.id, 'title': lessonNote.title},
        );
      }

      return result;
    } catch (e) {
      Logger.error(
        'Failed to save lesson note',
        category: LogCategory.database,
        data: {'lessonId': lessonNote.id, 'error': e.toString()},
      );
      return false;
    }
  }

  /// Get lesson note by ID
  static LessonNote? getLessonNote(String lessonId) {
    try {
      final lessonJson = getJson('lesson_$lessonId');
      if (lessonJson == null) return null;

      final lesson = LessonNote.fromJson(lessonJson);
      Logger.debug(
        'Lesson note retrieved',
        category: LogCategory.database,
        data: {'lessonId': lessonId, 'title': lesson.title},
      );
      return lesson;
    } catch (e) {
      Logger.error(
        'Failed to get lesson note',
        category: LogCategory.database,
        data: {'lessonId': lessonId, 'error': e.toString()},
      );
      return null;
    }
  }

  /// Get all lesson notes
  static List<LessonNote> getLessonNotes() {
    try {
      final lessonsJson = getJsonList('lessons') ?? [];
      final lessons = lessonsJson
          .map((json) => LessonNote.fromJson(json))
          .toList();

      // Sort by creation date (newest first)
      lessons.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      Logger.debug(
        'All lesson notes retrieved',
        category: LogCategory.database,
        data: {'count': lessons.length},
      );
      return lessons;
    } catch (e) {
      Logger.error(
        'Failed to get lesson notes',
        category: LogCategory.database,
        data: {'error': e.toString()},
      );
      return [];
    }
  }

  /// Delete lesson note
  static Future<bool> deleteLessonNote(String lessonId) async {
    try {
      // Remove from individual storage
      final result = await remove('lesson_$lessonId');

      if (result) {
        // Remove from lessons list
        final lessons = getLessonNotes();
        lessons.removeWhere((lesson) => lesson.id == lessonId);
        await saveJsonList(
          'lessons',
          lessons.map((lesson) => lesson.toJson()).toList(),
        );

        Logger.success(
          'Lesson note deleted',
          category: LogCategory.database,
          data: {'lessonId': lessonId},
        );
      }

      return result;
    } catch (e) {
      Logger.error(
        'Failed to delete lesson note',
        category: LogCategory.database,
        data: {'lessonId': lessonId, 'error': e.toString()},
      );
      return false;
    }
  }

  /// Update lesson note
  static Future<bool> updateLessonNote(LessonNote lessonNote) async {
    try {
      final result = await saveLessonNote(lessonNote);

      if (result) {
        Logger.success(
          'Lesson note updated',
          category: LogCategory.database,
          data: {'lessonId': lessonNote.id, 'title': lessonNote.title},
        );
      }

      return result;
    } catch (e) {
      Logger.error(
        'Failed to update lesson note',
        category: LogCategory.database,
        data: {'lessonId': lessonNote.id, 'error': e.toString()},
      );
      return false;
    }
  }

  /// Get lesson notes by subject
  static List<LessonNote> getLessonNotesBySubject(String subject) {
    try {
      final allLessons = getLessonNotes();
      final filteredLessons = allLessons
          .where(
            (lesson) =>
                lesson.subject.toLowerCase().contains(subject.toLowerCase()),
          )
          .toList();

      Logger.debug(
        'Lesson notes filtered by subject',
        category: LogCategory.database,
        data: {'subject': subject, 'count': filteredLessons.length},
      );
      return filteredLessons;
    } catch (e) {
      Logger.error(
        'Failed to get lesson notes by subject',
        category: LogCategory.database,
        data: {'subject': subject, 'error': e.toString()},
      );
      return [];
    }
  }

  /// Search lesson notes
  static List<LessonNote> searchLessonNotes(String query) {
    try {
      final allLessons = getLessonNotes();
      final searchQuery = query.toLowerCase();

      final filteredLessons = allLessons.where((lesson) {
        return lesson.title.toLowerCase().contains(searchQuery) ||
            lesson.subject.toLowerCase().contains(searchQuery) ||
            lesson.description.toLowerCase().contains(searchQuery) ||
            lesson.extractedText.toLowerCase().contains(searchQuery);
      }).toList();

      Logger.debug(
        'Lesson notes searched',
        category: LogCategory.database,
        data: {'query': query, 'count': filteredLessons.length},
      );
      return filteredLessons;
    } catch (e) {
      Logger.error(
        'Failed to search lesson notes',
        category: LogCategory.database,
        data: {'query': query, 'error': e.toString()},
      );
      return [];
    }
  }
}
