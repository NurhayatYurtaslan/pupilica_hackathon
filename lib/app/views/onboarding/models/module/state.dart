import 'package:pupilica_hackathon/core/models/onboarding_page.dart';

abstract class OnboardingState {}

class OnboardingInitialState extends OnboardingState {}

class OnboardingLoadedState extends OnboardingState {
  final int currentPage;
  final List<OnboardingPage> pages;

  OnboardingLoadedState({required this.currentPage, required this.pages});
}
