import 'package:equatable/equatable.dart';
import 'package:pupilica_hackathon/core/models/lesson_note.dart';

/// Base state class for LessonList
abstract class LessonListState extends Equatable {
  const LessonListState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class LessonListInitialState extends LessonListState {
  const LessonListInitialState();
}

/// Loading state
class LessonListLoadingState extends LessonListState {
  const LessonListLoadingState();
}

/// Loaded state with lessons
class LessonListLoadedState extends LessonListState {
  final List<LessonNote> lessons;

  const LessonListLoadedState({required this.lessons});

  @override
  List<Object?> get props => [lessons];
}

/// Error state
class LessonListErrorState extends LessonListState {
  final String error;

  const LessonListErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}
