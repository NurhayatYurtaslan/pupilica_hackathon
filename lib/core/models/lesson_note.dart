import 'package:pupilica_hackathon/core/services/document_service.dart';

/// Lesson note model for managing educational content
class LessonNote {
  final String id;
  final String title;
  final String subject;
  final String description;
  final List<DocumentFile> documents;
  final String extractedText;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isProcessed;

  LessonNote({
    required this.id,
    required this.title,
    required this.subject,
    required this.description,
    required this.documents,
    required this.extractedText,
    required this.createdAt,
    required this.updatedAt,
    this.isProcessed = false,
  });

  /// Create a new lesson note
  factory LessonNote.create({
    required String title,
    required String subject,
    required String description,
    required List<DocumentFile> documents,
  }) {
    final now = DateTime.now();
    return LessonNote(
      id: 'lesson_${now.millisecondsSinceEpoch}',
      title: title,
      subject: subject,
      description: description,
      documents: documents,
      extractedText: '',
      createdAt: now,
      updatedAt: now,
      isProcessed: false,
    );
  }

  /// Copy with updated values
  LessonNote copyWith({
    String? id,
    String? title,
    String? subject,
    String? description,
    List<DocumentFile>? documents,
    String? extractedText,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isProcessed,
  }) {
    return LessonNote(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      documents: documents ?? this.documents,
      extractedText: extractedText ?? this.extractedText,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isProcessed: isProcessed ?? this.isProcessed,
    );
  }

  /// Get total file size
  int get totalFileSize {
    return documents.fold(0, (sum, doc) => sum + doc.size);
  }

  /// Get total file size as string
  String get totalFileSizeString {
    return DocumentService.getFileSizeString(totalFileSize);
  }

  /// Get document count by type
  int getDocumentCountByType(DocumentType type) {
    return documents.where((doc) => doc.type == type).length;
  }

  /// Get image documents
  List<DocumentFile> get imageDocuments {
    return documents.where((doc) => doc.type == DocumentType.image).toList();
  }

  /// Get PDF documents
  List<DocumentFile> get pdfDocuments {
    return documents.where((doc) => doc.type == DocumentType.pdf).toList();
  }

  /// Check if lesson note has any documents
  bool get hasDocuments => documents.isNotEmpty;

  /// Check if lesson note has extracted text
  bool get hasExtractedText => extractedText.isNotEmpty;

  /// Get preview text (first 100 characters)
  String get previewText {
    if (extractedText.isEmpty) return 'No text extracted yet';
    return extractedText.length > 100
        ? '${extractedText.substring(0, 100)}...'
        : extractedText;
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'description': description,
      'documents': documents
          .map(
            (doc) => {
              'name': doc.name,
              'path': doc.path,
              'size': doc.size,
              'type': doc.type.toString(),
            },
          )
          .toList(),
      'extractedText': extractedText,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isProcessed': isProcessed,
    };
  }

  /// Create from JSON
  factory LessonNote.fromJson(Map<String, dynamic> json) {
    return LessonNote(
      id: json['id'] as String,
      title: json['title'] as String,
      subject: json['subject'] as String,
      description: json['description'] as String,
      documents: (json['documents'] as List)
          .map(
            (docJson) => DocumentFile(
              name: docJson['name'] as String,
              path: docJson['path'] as String,
              size: docJson['size'] as int,
              type: DocumentType.values.firstWhere(
                (type) => type.toString() == docJson['type'],
                orElse: () => DocumentType.unknown,
              ),
            ),
          )
          .toList(),
      extractedText: json['extractedText'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isProcessed: json['isProcessed'] as bool? ?? false,
    );
  }

  @override
  String toString() {
    return 'LessonNote(id: $id, title: $title, subject: $subject, documents: ${documents.length}, isProcessed: $isProcessed)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LessonNote && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
