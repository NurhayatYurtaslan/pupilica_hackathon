import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pupilica_hackathon/core/helpers/logger.dart';
import 'package:pupilica_hackathon/app/views/lesson_detail/models/module/event.dart';
import 'package:pupilica_hackathon/app/views/lesson_detail/models/module/state.dart';

class LessonDetailViewModel extends Bloc<LessonDetailEvent, LessonDetailState> {
  LessonDetailViewModel() : super(LessonDetailInitialState()) {
    on<LessonDetailInitialEvent>(_onInitial);
    on<LessonDetailRefreshEvent>(_onRefresh);
    on<LessonDetailDeleteEvent>(_onDelete);
  }

  Future<void> _onInitial(
    LessonDetailInitialEvent event,
    Emitter<LessonDetailState> emit,
  ) async {
    try {
      Logger.info(
        'LessonDetailViewModel initialized',
        category: LogCategory.ui,
      );

      emit(LessonDetailLoadedState(lesson: event.lesson));
    } catch (e) {
      Logger.error(
        'LessonDetailViewModel initialization failed',
        category: LogCategory.ui,
        data: {'error': e.toString()},
      );

      emit(LessonDetailErrorState(error: e.toString()));
    }
  }

  Future<void> _onRefresh(
    LessonDetailRefreshEvent event,
    Emitter<LessonDetailState> emit,
  ) async {
    try {
      Logger.info('Refreshing lesson detail', category: LogCategory.ui);

      emit(LessonDetailLoadedState(lesson: event.lesson));
    } catch (e) {
      Logger.error(
        'Lesson detail refresh failed',
        category: LogCategory.ui,
        data: {'error': e.toString()},
      );

      emit(LessonDetailErrorState(error: e.toString()));
    }
  }

  Future<void> _onDelete(
    LessonDetailDeleteEvent event,
    Emitter<LessonDetailState> emit,
  ) async {
    try {
      Logger.info('Deleting lesson', category: LogCategory.ui);

      // TODO: Implement lesson deletion logic
      emit(LessonDetailDeletedState());
    } catch (e) {
      Logger.error(
        'Lesson deletion failed',
        category: LogCategory.ui,
        data: {'error': e.toString()},
      );

      emit(LessonDetailErrorState(error: e.toString()));
    }
  }
}
