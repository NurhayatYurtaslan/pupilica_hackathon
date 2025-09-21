import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:pupilica_hackathon/core/models/onboarding_page.dart';

class OnboardingConstants {
  static final List<OnboardingPage> pages = [
    OnboardingPage(
      icon: Icons.psychology_alt,
      title: 'Welcome to Pupilica AI',
      description:
          'Transform your learning experience with our AI-powered education platform.',
      color: OsmeaColors.nordicBlue,
    ),
    OnboardingPage(
      icon: Icons.upload_file,
      title: 'Upload Documents',
      description:
          'Easily upload PDF, image, or text files and analyze them with AI.',
      color: OsmeaColors.nordicBlue,
    ),
    OnboardingPage(
      icon: Icons.school,
      title: 'Create Lessons',
      description:
          'Automatically generate interactive lessons from your uploaded documents.',
      color: OsmeaColors.blue,
    ),
    OnboardingPage(
      icon: Icons.quiz,
      title: 'Test Your Knowledge',
      description: 'Test what you\'ve learned and reinforce your knowledge.',
      color: OsmeaColors.nordicBlue,
    ),
  ];
}
