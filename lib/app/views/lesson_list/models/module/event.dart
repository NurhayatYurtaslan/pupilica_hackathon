import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

/// Base event class for LessonList
abstract class LessonListEvent extends Equatable {
  const LessonListEvent();

  @override
  List<Object?> get props => [];
}

/// Initial event to initialize the LessonList
class LessonListInitialEvent extends LessonListEvent {
  final BuildContext context;

  const LessonListInitialEvent(this.context);

  @override
  List<Object?> get props => [context];
}

/// Event to refresh the lesson list
class LessonListRefreshEvent extends LessonListEvent {
  final BuildContext context;

  const LessonListRefreshEvent(this.context);

  @override
  List<Object?> get props => [context];
}

/// Event to load lessons
class LessonListLoadLessonsEvent extends LessonListEvent {
  const LessonListLoadLessonsEvent();
}
