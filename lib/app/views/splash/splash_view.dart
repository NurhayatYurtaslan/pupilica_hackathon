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
    // System UI visibility management
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return BlocProvider(
      create: (context) {
        return SplashViewModel()..add(SplashInitialEvent(context));
      },
      child: BlocBuilder<SplashViewModel, SplashState>(
        builder: (context, state) {
          return OsmeaComponents.scaffold(
            body: OsmeaComponents.container(
              width: context.allWidth,
              height: context.allHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    OsmeaColors.nordicBlue,
                    OsmeaColors.blue,
                    OsmeaColors.nordicBlue,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
              child: OsmeaComponents.column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App logo
                  Image.asset(
                    'assets/images/rocket-lica.png',

                  ),

                  // Loading indicator
                  OsmeaComponents.loading(
                    type: LoadingType.gridPulse,
                    color: Colors.white,
                    size: context.allHeight * .1,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
