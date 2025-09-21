import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pupilica_hackathon/core/helpers/logger.dart';
import 'package:pupilica_hackathon/core/services/lesson_service.dart';
import 'package:pupilica_hackathon/app/views/home/models/module/event.dart';
import 'package:pupilica_hackathon/app/views/home/models/module/state.dart';

class HomeViewModel extends Bloc<HomeEvent, HomeState> {
  HomeViewModel() : super(const HomeInitialState()) {
    on<HomeInitialEvent>(_onInitial);
    on<HomeRefreshEvent>(_onRefresh);
    on<HomeLoadStatisticsEvent>(_onLoadStatistics);
  }

  /// Handle initial event
  void _onInitial(HomeInitialEvent event, Emitter<HomeState> emit) async {
    Logger.info('HomeViewModel initialized', category: LogCategory.ui);

    try {
      // Initialize lesson service
      await LessonService.initialize();

      // Load statistics and recent lessons
      final statistics = LessonService.getStatistics();
      final recentLessons =
          LessonService.getAllLessonNotes()
              .where((lesson) => lesson.isProcessed)
              .toList()
            ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      emit(
        HomeLoadedState(statistics: statistics, recentLessons: recentLessons),
      );
    } catch (e) {
      Logger.error(
        'Failed to initialize home view',
        category: LogCategory.ui,
        data: {'error': e.toString()},
      );
      emit(HomeErrorState(error: e.toString()));
    }
  }

  /// Handle refresh event
  void _onRefresh(HomeRefreshEvent event, Emitter<HomeState> emit) async {
    Logger.info('Home view refreshing', category: LogCategory.ui);

    try {
      // Reload statistics and recent lessons
      final statistics = LessonService.getStatistics();
      final recentLessons =
          LessonService.getAllLessonNotes()
              .where((lesson) => lesson.isProcessed)
              .toList()
            ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      emit(
        HomeLoadedState(statistics: statistics, recentLessons: recentLessons),
      );
    } catch (e) {
      Logger.error(
        'Failed to refresh home view',
        category: LogCategory.ui,
        data: {'error': e.toString()},
      );
      emit(HomeErrorState(error: e.toString()));
    }
  }

  /// Handle load statistics event
  void _onLoadStatistics(
    HomeLoadStatisticsEvent event,
    Emitter<HomeState> emit,
  ) async {
    Logger.info('Loading statistics', category: LogCategory.ui);

    try {
      final statistics = LessonService.getStatistics();

      if (state is HomeLoadedState) {
        final currentState = state as HomeLoadedState;
        emit(currentState.copyWith(statistics: statistics));
      }
    } catch (e) {
      Logger.error(
        'Failed to load statistics',
        category: LogCategory.ui,
        data: {'error': e.toString()},
      );
    }
  }

  /// Refresh home data
  void refresh() {
    add(const HomeRefreshEvent());
  }

  /// Load statistics
  void loadStatistics() {
    add(const HomeLoadStatisticsEvent());
  }
}
