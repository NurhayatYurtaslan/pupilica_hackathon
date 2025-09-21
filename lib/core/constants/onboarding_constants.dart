import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:pupilica_hackathon/core/models/onboarding_page.dart';

class OnboardingConstants {
  static final List<OnboardingPage> pages = [
    OnboardingPage(
      icon: Icons.psychology_alt,
      title: 'Welcome to RocketLica',
      description:
          'Transform your documents into PDFs with our AI-powered OCR technology.',
      color: OsmeaColors.nordicBlue,
    ),
    OnboardingPage(
      icon: Icons.upload_file,
      title: 'Upload Documents',
      description:
          'Easily upload images or PDF files and extract text using advanced OCR.',
      color: OsmeaColors.nordicBlue,
    ),
    OnboardingPage(
      icon: Icons.picture_as_pdf,
      title: 'Generate PDFs',
      description:
          'Convert your uploaded documents into professional PDFs with extracted text.',
      color: OsmeaColors.blue,
    ),
    OnboardingPage(
      icon: Icons.download,
      title: 'Download & Share',
      description: 'Download your generated PDFs and share them with others.',
      color: OsmeaColors.nordicBlue,
    ),
  ];
}
