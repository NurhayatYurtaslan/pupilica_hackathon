import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';

class OnboardingNavigationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Color currentPageColor;
  final VoidCallback? onNext;
  final VoidCallback? onSkip;

  const OnboardingNavigationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.currentPageColor,
    this.onNext,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: OsmeaComponents.column(
        children: [
          // Page indicators
          OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              totalPages,
              (index) => OsmeaComponents.container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: currentPage == index
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          OsmeaComponents.sizedBox(height: context.height20),

          // Next/Get Started button
          OsmeaComponents.container(
            width: context.allWidth * 0.8,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextButton(
              onPressed: onNext,
              child: OsmeaComponents.text(
                currentPage == totalPages - 1 ? 'Get Started' : 'Continue',
                fontSize: context.fontSizeLarge,
                fontWeight: context.bold,
                color: currentPageColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
