import 'package:equatable/equatable.dart';

/// Base state class for Home
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class HomeInitialState extends HomeState {
  const HomeInitialState();
}

/// Loading state
class HomeLoadingState extends HomeState {
  const HomeLoadingState();
}

/// Loaded state with data
class HomeLoadedState extends HomeState {
  final Map<String, dynamic> statistics;
  final List<dynamic> recentLessons;

  const HomeLoadedState({
    required this.statistics,
    required this.recentLessons,
  });

  @override
  List<Object?> get props => [statistics, recentLessons];

  /// Copy with updated values
  HomeLoadedState copyWith({
    Map<String, dynamic>? statistics,
    List<dynamic>? recentLessons,
  }) {
    return HomeLoadedState(
      statistics: statistics ?? this.statistics,
      recentLessons: recentLessons ?? this.recentLessons,
    );
  }
}

/// Error state
class HomeErrorState extends HomeState {
  final String error;

  const HomeErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}
