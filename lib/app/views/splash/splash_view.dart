import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:pupilica_hackathon/app/views/splash/models/module/event.dart';
import 'package:pupilica_hackathon/app/views/splash/models/module/state.dart';
import 'package:pupilica_hackathon/app/views/splash/models/splash_view_model.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    //system UI visibility management
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return BlocProvider(
      create: (context) => SplashViewModel()..add(SplashInitialEvent(context)),
      child: BlocBuilder<SplashViewModel, SplashState>(
        builder: (context, state) {
          return OsmeaComponents.scaffold(
            body: OsmeaComponents.center(
              child: OsmeaComponents.container(
                child: OsmeaComponents.text('Splash'),
              ),
            ),
          );
        },
      ),
    );
  }
}
