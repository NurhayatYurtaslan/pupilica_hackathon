import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';

class OnboardingSkipButtonWidget extends StatelessWidget {
  final VoidCallback? onSkip;

  const OnboardingSkipButtonWidget({super.key, this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.topRight,
        child: TextButton(
          onPressed: onSkip,
          child: OsmeaComponents.text(
            'Skip',
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: context.fontSizeMedium,
          ),
        ),
      ),
    );
  }
}
