import 'package:equatable/equatable.dart';
import 'package:pupilica_hackathon/core/services/document_service.dart';

/// Lesson Creation Events
abstract class LessonCreationEvent extends Equatable {
  const LessonCreationEvent();

  @override
  List<Object?> get props => [];
}

/// Initial event
class LessonCreationInitialEvent extends LessonCreationEvent {
  final List<DocumentFile> documents;
  final String extractedText;

  const LessonCreationInitialEvent({
    required this.documents,
    required this.extractedText,
  });

  @override
  List<Object?> get props => [documents, extractedText];
}

/// Save lesson event
class LessonCreationSaveEvent extends LessonCreationEvent {
  final String title;
  final String subject;
  final String description;
  final String extractedText;
  final List<DocumentFile> documents;

  const LessonCreationSaveEvent({
    required this.title,
    required this.subject,
    required this.description,
    required this.extractedText,
    required this.documents,
  });

  @override
  List<Object?> get props => [
    title,
    subject,
    description,
    extractedText,
    documents,
  ];
}

/// Update extracted text event
class LessonCreationUpdateTextEvent extends LessonCreationEvent {
  final String extractedText;

  const LessonCreationUpdateTextEvent(this.extractedText);

  @override
  List<Object?> get props => [extractedText];
}

/// Update title event
class LessonCreationUpdateTitleEvent extends LessonCreationEvent {
  final String title;

  const LessonCreationUpdateTitleEvent(this.title);

  @override
  List<Object?> get props => [title];
}

/// Update subject event
class LessonCreationUpdateSubjectEvent extends LessonCreationEvent {
  final String subject;

  const LessonCreationUpdateSubjectEvent(this.subject);

  @override
  List<Object?> get props => [subject];
}

/// Update description event
class LessonCreationUpdateDescriptionEvent extends LessonCreationEvent {
  final String description;

  const LessonCreationUpdateDescriptionEvent(this.description);

  @override
  List<Object?> get props => [description];
}
