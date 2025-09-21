import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pupilica_hackathon/core/helpers/logger.dart';
import 'package:pupilica_hackathon/core/services/lesson_service.dart';
import 'package:pupilica_hackathon/app/views/lesson_list/models/module/event.dart';
import 'package:pupilica_hackathon/app/views/lesson_list/models/module/state.dart';

class LessonListViewModel extends Bloc<LessonListEvent, LessonListState> {
  LessonListViewModel() : super(LessonListInitialState()) {
    on<LessonListInitialEvent>(_onInitial);
    on<LessonListRefreshEvent>(_onRefresh);
    on<LessonListLoadLessonsEvent>(_onLoadLessons);
  }

  Future<FutureOr<void>> _onInitial(
    LessonListInitialEvent event,
    Emitter<LessonListState> emit,
  ) async {
    Logger.info('LessonListViewModel initialized', category: LogCategory.ui);
    await _loadLessons(emit);
  }

  Future<FutureOr<void>> _onRefresh(
    LessonListRefreshEvent event,
    Emitter<LessonListState> emit,
  ) async {
    Logger.info('Refreshing lesson list', category: LogCategory.ui);
    await _loadLessons(emit);
  }

  Future<FutureOr<void>> _onLoadLessons(
    LessonListLoadLessonsEvent event,
    Emitter<LessonListState> emit,
  ) async {
    Logger.info('Loading lessons', category: LogCategory.ui);
    await _loadLessons(emit);
  }

  Future<void> _loadLessons(Emitter<LessonListState> emit) async {
    try {
      emit(LessonListLoadingState());

      // Get all lessons from service
      final lessons = LessonService.getAllLessonNotes();

      Logger.success(
        'Lessons loaded successfully',
        category: LogCategory.ui,
        data: {'count': lessons.length},
      );

      emit(LessonListLoadedState(lessons: lessons));
    } catch (e) {
      Logger.error(
        'Failed to load lessons',
        category: LogCategory.ui,
        data: {'error': e.toString()},
      );
      emit(LessonListErrorState(error: e.toString()));
    }
  }
}
