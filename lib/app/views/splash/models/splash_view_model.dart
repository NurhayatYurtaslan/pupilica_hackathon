import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pupilica_hackathon/app/views/splash/models/module/event.dart';
import 'package:pupilica_hackathon/app/views/splash/models/module/state.dart';
import 'package:pupilica_hackathon/core/helpers/logger.dart';
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

    // Navigate to home after splash
    if (event.context.mounted) {
      Logger.info('Navigating to home', category: LogCategory.splash);
      event.context.go(AppRouter.home);
    } else {
      Logger.error(
        'Context not mounted, cannot navigate',
        category: LogCategory.splash,
      );
    }
  }
}
