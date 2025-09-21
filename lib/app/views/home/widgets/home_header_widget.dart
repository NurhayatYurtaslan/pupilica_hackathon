import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.column(
      children: [
        // App logo/icon
        OsmeaComponents.container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: OsmeaColors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: OsmeaColors.white.withValues(alpha: 0.4),
              width: 2,
            ),
          ),
          child: Icon(Icons.psychology_alt, size: 40, color: OsmeaColors.white),
        ),

        OsmeaComponents.sizedBox(height: 20),

        // App title
        OsmeaComponents.text(
          'Pupilica AI',
          textStyle: OsmeaTextStyle.headlineLarge(context),
          color: OsmeaColors.white,
          textAlign: context.textCenter,
        ),

        OsmeaComponents.sizedBox(height: 8),

        // App description
        OsmeaComponents.text(
          'Intelligent Learning Platform',
          textStyle: OsmeaTextStyle.bodyLarge(context),
          color: OsmeaColors.white.withValues(alpha: 0.8),
          textAlign: context.textCenter,
        ),
      ],
    );
  }
}
