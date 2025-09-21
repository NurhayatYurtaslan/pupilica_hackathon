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
                    const Color(0xFF1E40AF), // Deep indigo
                    const Color(0xFF3B82F6), // Blue
                    const Color(0xFF60A5FA), // Light blue
                    const Color(0xFF93C5FD), // Very light blue
                    const Color(0xFFDBEAFE), // Almost white blue
                  ],
                  stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
                ),
              ),
              child: OsmeaComponents.column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App logo
                  OsmeaComponents.container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Image.asset(
                      'assets/images/rocket-lica.png',
                      height: 60,
                      width: 60,
                    ),
                  ),

                  OsmeaComponents.sizedBox(height: context.height40),

                  // App title
                  OsmeaComponents.text(
                    'RocketLica',
                    fontSize: context.fontSizeExtraLarge,
                    fontWeight: context.bold,
                    color: Colors.white,
                    textAlign: context.textCenter,
                  ),

                  OsmeaComponents.sizedBox(height: context.height20),

                  // Loading indicator
                  OsmeaComponents.container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    ),
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
