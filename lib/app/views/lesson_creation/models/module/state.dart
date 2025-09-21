import 'package:equatable/equatable.dart';
import 'package:pupilica_hackathon/core/services/document_service.dart';

/// Lesson Creation States
abstract class LessonCreationState extends Equatable {
  const LessonCreationState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class LessonCreationInitialState extends LessonCreationState {
  const LessonCreationInitialState();
}

/// Loading state
class LessonCreationLoadingState extends LessonCreationState {
  const LessonCreationLoadingState();
}

/// Loaded state
class LessonCreationLoadedState extends LessonCreationState {
  final List<DocumentFile> documents;
  final String extractedText;
  final String title;
  final String subject;
  final String description;

  const LessonCreationLoadedState({
    required this.documents,
    required this.extractedText,
    this.title = '',
    this.subject = '',
    this.description = '',
  });

  @override
  List<Object?> get props => [
    documents,
    extractedText,
    title,
    subject,
    description,
  ];
}

/// Success state
class LessonCreationSuccessState extends LessonCreationState {
  final String message;

  const LessonCreationSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}

/// Error state
class LessonCreationErrorState extends LessonCreationState {
  final String error;

  const LessonCreationErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
