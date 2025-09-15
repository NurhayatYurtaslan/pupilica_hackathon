import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:pupilica_hackathon/app/views/splash/models/module/event.dart';
import 'package:pupilica_hackathon/app/views/splash/models/module/state.dart';
import 'package:pupilica_hackathon/core/helpers/logger/logger.dart';

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

    await Future.delayed(event.context.durationMedium);

    Logger.success(
      'Splash screen completed successfully',
      category: LogCategory.splash,
    );
  }
}
