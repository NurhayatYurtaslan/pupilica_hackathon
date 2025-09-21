import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:pupilica_hackathon/core/services/onboarding_service.dart';
import 'package:pupilica_hackathon/core/constants/onboarding_constants.dart';
import 'package:pupilica_hackathon/app/views/onboarding/models/module/event.dart';
import 'package:pupilica_hackathon/app/views/onboarding/models/module/state.dart';

class OnboardingViewModel extends Bloc<OnboardingEvent, OnboardingState> {
  late PageController pageController;
  int currentIndex = 0;
  bool isSkipping = false;

  OnboardingViewModel() : super(OnboardingInitialState()) {
    pageController = PageController();
    on<OnboardingInitialEvent>(_onOnboardingInitialEvent);
    on<OnboardingNextPageEvent>(_onOnboardingNextPageEvent);
    on<OnboardingPreviousPageEvent>(_onOnboardingPreviousPageEvent);
    on<OnboardingSkipEvent>(_onOnboardingSkipEvent);
    on<OnboardingCompleteEvent>(_onOnboardingCompleteEvent);
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }

  Future<FutureOr<void>> _onOnboardingInitialEvent(
    OnboardingInitialEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    currentIndex = 0;
    emit(
      OnboardingLoadedState(
        currentPage: currentIndex,
        pages: OnboardingConstants.pages,
      ),
    );
  }

  Future<FutureOr<void>> _onOnboardingNextPageEvent(
    OnboardingNextPageEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    currentIndex++;
    if (currentIndex < OnboardingConstants.pages.length) {
      pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      emit(
        OnboardingLoadedState(
          currentPage: currentIndex,
          pages: OnboardingConstants.pages,
        ),
      );
    } else {
      add(OnboardingCompleteEvent());
    }
  }

  Future<FutureOr<void>> _onOnboardingPreviousPageEvent(
    OnboardingPreviousPageEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    if (currentIndex > 0) {
      currentIndex--;
      pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      emit(
        OnboardingLoadedState(
          currentPage: currentIndex,
          pages: OnboardingConstants.pages,
        ),
      );
    }
  }

  Future<FutureOr<void>> _onOnboardingSkipEvent(
    OnboardingSkipEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    // Skip to last page (Get Started page)
    final totalPages = OnboardingConstants.pages.length;
    currentIndex = totalPages - 1;
    isSkipping = true;

    pageController.animateToPage(
      currentIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    // Reset skipping flag after animation
    Future.delayed(const Duration(milliseconds: 350), () {
      isSkipping = false;
    });

    emit(
      OnboardingLoadedState(
        currentPage: currentIndex,
        pages: OnboardingConstants.pages,
      ),
    );
  }

  Future<FutureOr<void>> _onOnboardingCompleteEvent(
    OnboardingCompleteEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    await OnboardingService.completeOnboarding();
  }
}
