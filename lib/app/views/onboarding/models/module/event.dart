import 'package:flutter/material.dart';

abstract class OnboardingEvent {}

class OnboardingInitialEvent extends OnboardingEvent {
  final BuildContext context;
  OnboardingInitialEvent(this.context);
}

class OnboardingNextPageEvent extends OnboardingEvent {}

class OnboardingPreviousPageEvent extends OnboardingEvent {}

class OnboardingSkipEvent extends OnboardingEvent {}

class OnboardingCompleteEvent extends OnboardingEvent {}
