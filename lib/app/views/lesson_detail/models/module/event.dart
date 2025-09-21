import 'package:equatable/equatable.dart';
import 'package:pupilica_hackathon/core/models/lesson_note.dart';

abstract class LessonDetailEvent extends Equatable {
  const LessonDetailEvent();

  @override
  List<Object?> get props => [];
}

class LessonDetailInitialEvent extends LessonDetailEvent {
  final LessonNote lesson;

  const LessonDetailInitialEvent({required this.lesson});

  @override
  List<Object?> get props => [lesson];
}

class LessonDetailRefreshEvent extends LessonDetailEvent {
  final LessonNote lesson;

  const LessonDetailRefreshEvent({required this.lesson});

  @override
  List<Object?> get props => [lesson];
}

class LessonDetailDeleteEvent extends LessonDetailEvent {
  final String lessonId;

  const LessonDetailDeleteEvent({required this.lessonId});

  @override
  List<Object?> get props => [lessonId];
}
