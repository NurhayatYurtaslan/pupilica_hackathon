import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pupilica_hackathon/app/views/splash/models/module/event.dart';
import 'package:pupilica_hackathon/app/views/splash/models/module/state.dart';
import 'package:pupilica_hackathon/core/helpers/logger.dart';
import 'package:pupilica_hackathon/core/helpers/local_storage_helper.dart';
import 'package:pupilica_hackathon/app/routes/app_router.dart';

class SplashViewModel extends Bloc<SplashEvent, SplashState> {
  SplashViewModel() : super(SplashInitialState()) {
    on<SplashInitialEvent>(_onSplashInitial);
  }

  Future<FutureOr<void>> _onSplashInitial(
    SplashInitialEvent event,
    Emitter<SplashState> emit,
  ) async {
    // Simple logging
    Logger.info('Splash screen initialized', category: LogCategory.splash);

    // Wait for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    Logger.success(
      'Splash screen completed successfully',
      category: LogCategory.splash,
    );

    // Check onboarding status and navigate accordingly
    if (event.context.mounted) {
      try {
        final isOnboardingCompleted = LocalStorageHelper.getBoolOrDefault(
          'onboarding_completed',
          false,
        );

        if (isOnboardingCompleted) {
          Logger.info(
            'Onboarding completed, navigating to home',
            category: LogCategory.splash,
          );
          event.context.go(AppRouter.home);
        } else {
          Logger.info(
            'First time user, navigating to onboarding',
            category: LogCategory.splash,
          );
          event.context.go(AppRouter.onboarding);
        }
      } catch (e) {
        Logger.error(
          'Error checking onboarding status: $e',
          category: LogCategory.splash,
        );
        // Fallback to onboarding if there's an error
        event.context.go(AppRouter.onboarding);
      }
    } else {
      Logger.error(
        'Context not mounted, cannot navigate',
        category: LogCategory.splash,
      );
    }
  }
}
