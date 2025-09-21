import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:pupilica_hackathon/core/models/onboarding_page.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;

  const OnboardingPageWidget({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: OsmeaComponents.column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
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

          // Title
          OsmeaComponents.text(
            page.title,
            fontSize: context.fontSizeExtraLarge,
            fontWeight: context.bold,
            color: Colors.white,
            textAlign: context.textCenter,
          ),

          OsmeaComponents.sizedBox(height: context.height20),

          // Description
          OsmeaComponents.text(
            page.description,
            fontSize: context.fontSizeMedium,
            color: Colors.white.withValues(alpha: 0.9),
            textAlign: context.textCenter,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
