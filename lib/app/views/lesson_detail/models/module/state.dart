import 'package:equatable/equatable.dart';
import 'package:pupilica_hackathon/core/models/lesson_note.dart';

abstract class LessonDetailState extends Equatable {
  const LessonDetailState();

  @override
  List<Object?> get props => [];
}

class LessonDetailInitialState extends LessonDetailState {}

class LessonDetailLoadingState extends LessonDetailState {}

class LessonDetailLoadedState extends LessonDetailState {
  final LessonNote lesson;

  const LessonDetailLoadedState({required this.lesson});

  @override
  List<Object?> get props => [lesson];
}

class LessonDetailErrorState extends LessonDetailState {
  final String error;

  const LessonDetailErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

class LessonDetailDeletedState extends LessonDetailState {}
