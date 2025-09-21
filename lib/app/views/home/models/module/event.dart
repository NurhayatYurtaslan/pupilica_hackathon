import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Base event class for Home
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Initial event to initialize the Home
class HomeInitialEvent extends HomeEvent {
  final BuildContext context;

  const HomeInitialEvent(this.context);

  @override
  List<Object?> get props => [context];
}

/// Event to refresh home data
class HomeRefreshEvent extends HomeEvent {
  const HomeRefreshEvent();
}

/// Event to load statistics
class HomeLoadStatisticsEvent extends HomeEvent {
  const HomeLoadStatisticsEvent();
}

/// Event to navigate to specific section
class HomeNavigateEvent extends HomeEvent {
  final String route;

  const HomeNavigateEvent(this.route);

  @override
  List<Object?> get props => [route];
}
