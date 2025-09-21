import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:pupilica_hackathon/core/helpers/logger/logger.dart';
import 'package:pupilica_hackathon/app/views/splash/models/module/event.dart';
import 'package:pupilica_hackathon/app/views/splash/models/module/state.dart';
import 'package:pupilica_hackathon/app/views/splash/models/splash_view_model.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Logger.info('SplashView build method called', category: LogCategory.splash);

    //system UI visibility management
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return BlocProvider(
      create: (context) {
        Logger.debug('Creating SplashViewModel', category: LogCategory.splash);
        return SplashViewModel()..add(SplashInitialEvent(context));
      },
      child: BlocBuilder<SplashViewModel, SplashState>(
        builder: (context, state) {
          Logger.debug(
            'SplashView state changed',
            category: LogCategory.splash,
            data: {'state': state.runtimeType.toString()},
          );
          return OsmeaComponents.scaffold(
            body: OsmeaComponents.container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    OsmeaColors.nordicBlue,
                    OsmeaColors.nordicBlue.withValues(alpha: 0.9),
                    OsmeaColors.nordicBlue.withValues(alpha: 0.7),
                    OsmeaColors.nordicBlue.withValues(alpha: 0.5),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
              child: SafeArea(
                child: OsmeaComponents.padding(
                  padding: context.paddingHigh,
                  child: OsmeaComponents.column(
                    children: [
                      // Top section with more whitespace
                      OsmeaComponents.expanded(
                        flex: 2,
                        child: OsmeaComponents.sizedBox(
                          height: context.spacingNormal,
                        ),
                      ),

                      // Main content with better spacing
                      OsmeaComponents.expanded(
                        flex: 6,
                        child: OsmeaComponents.column(
                          mainAxisAlignment: context.centerMain,
                          children: [
                            // Modern logo container with glassmorphism effect
                            OsmeaComponents.container(
                              width: context.dynamicWidth(0.3),
                              height: context.dynamicHeight(0.2),
                              decoration: BoxDecoration(
                                color: OsmeaColors.white.withValues(alpha: 0.2),
                                borderRadius: context.borderRadiusHigh,
                                border: Border.all(
                                  color: OsmeaColors.white.withValues(
                                    alpha: 0.4,
                                  ),
                                  width: context.borderWidth * 4,
                                ),
                              ),
                              child: Icon(
                                Icons.psychology_alt,
                                size: context.iconSizeExtraHigh,
                                color: OsmeaColors.white,
                              ),
                            ),

                            // Generous whitespace
                            OsmeaComponents.sizedBox(
                              height: context.spacingNormal,
                            ),

                            // App name with modern typography
                            OsmeaComponents.text(
                              'Pupilica AI',
                              fontSize: context.fontSizeExtraLarge,
                              fontFamily: context.fontMontserrat,
                              fontWeight: context.extraBold,
                              color: OsmeaColors.white,
                              letterSpacing: context.letterSpacingExtraLoose,
                              textAlign: context.textCenter,
                            ),

                            // Subtitle with more whitespace
                            OsmeaComponents.sizedBox(
                              height: context.spacingLow,
                            ),

                            OsmeaComponents.text(
                              'Intelligent Learning Platform',
                              fontSize: context.fontSizeExtraSmallMedium,
                              fontFamily: context.fontRoboto,
                              fontWeight: context.light,
                              color: OsmeaColors.white.withValues(alpha: 0.8),
                              letterSpacing: context.letterSpacingWide,
                              textAlign: context.textCenter,
                            ),

                            // More whitespace
                            OsmeaComponents.sizedBox(
                              height: context.spacingNormal,
                            ),

                            // Modern badge with better styling
                            OsmeaComponents.container(
                              padding:
                                  context.horizontalPaddingHigh +
                                  context.verticalPaddingMedium,
                              decoration: BoxDecoration(
                                color: OsmeaColors.white.withValues(alpha: 0.1),
                                borderRadius: context.borderRadiusHigh,
                                border: Border.all(
                                  color: OsmeaColors.white.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: context.borderWidth * 3,
                                ),
                              ),
                              child: OsmeaComponents.text(
                                'Yapay Zeka Hackathonu 2024',
                                fontSize: context.fontSizeMedium,
                                fontFamily: context.fontRoboto,
                                fontWeight: context.semiBold,
                                color: OsmeaColors.white,
                                letterSpacing: context.letterSpacingWide,
                                textAlign: context.textCenter,
                              ),
                            ),

                            // Generous whitespace before loading
                            OsmeaComponents.sizedBox(
                              height: context.spacingNormal,
                            ),

                            // Modern loading indicator
                            OsmeaComponents.container(
                              width: context.width48,
                              height: context.height48,
                              decoration: BoxDecoration(
                                color: OsmeaColors.white.withValues(alpha: 0.1),
                                borderRadius: context.borderRadiusHigh,
                                border: Border.all(
                                  color: OsmeaColors.white.withValues(
                                    alpha: 0.2,
                                  ),
                                  width: context.borderWidth * 2,
                                ),
                              ),
                              child: OsmeaComponents.padding(
                                padding: context.paddingLow,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    OsmeaColors.white.withValues(alpha: 0.9),
                                  ),
                                  strokeWidth: 2.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Bottom section with more whitespace
                      OsmeaComponents.expanded(
                        flex: 2,
                        child: OsmeaComponents.column(
                          mainAxisAlignment: context.end,
                          children: [
                            // Version info with better spacing
                            OsmeaComponents.container(
                              padding:
                                  context.horizontalPaddingMedium +
                                  context.verticalPaddingLow,
                              decoration: BoxDecoration(
                                color: OsmeaColors.white.withValues(
                                  alpha: 0.05,
                                ),
                                borderRadius: context.borderRadiusNormal,
                                border: Border.all(
                                  color: OsmeaColors.white.withValues(
                                    alpha: 0.1,
                                  ),
                                  width: context.borderWidth * 2,
                                ),
                              ),
                              child: OsmeaComponents.column(
                                children: [
                                  OsmeaComponents.text(
                                    'Version 1.0.0',
                                    fontSize: context.fontSizeExtraSmallMedium,
                                    fontFamily: context.fontRoboto,
                                    fontWeight: context.medium,
                                    color: OsmeaColors.white.withValues(
                                      alpha: 0.8,
                                    ),
                                    letterSpacing: context.letterSpacingNormal,
                                    textAlign: context.textCenter,
                                  ),
                                  OsmeaComponents.sizedBox(
                                    height: context.spacingLow,
                                  ),
                                  OsmeaComponents.text(
                                    'Powered by Flutter & AI',
                                    fontSize: context.fontSizeSmall,
                                    fontFamily: context.fontRoboto,
                                    fontWeight: context.normal,
                                    color: OsmeaColors.white.withValues(
                                      alpha: 0.6,
                                    ),
                                    letterSpacing: context.letterSpacingNormal,
                                    textAlign: context.textCenter,
                                  ),
                                ],
                              ),
                            ),

                            // Bottom spacing
                            OsmeaComponents.sizedBox(
                              height: context.spacingMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
