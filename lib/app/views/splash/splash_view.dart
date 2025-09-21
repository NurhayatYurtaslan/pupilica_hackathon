import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:pupilica_hackathon/core/helpers/logger.dart';
import 'package:pupilica_hackathon/app/routes/app_router.dart';
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
          // Auto navigation after 2 seconds
          Future.delayed(const Duration(seconds: 2), () {
            if (context.mounted) {
              context.go(AppRouter.home);
            }
          });

          return Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App logo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.4),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.psychology_alt,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // App title
                  const Text(
                    'Pupilica AI',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  // Loading indicator
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withValues(alpha: 0.9),
                        ),
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
