import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pupilica_hackathon/app/views/splash/splash_view.dart';
import 'package:pupilica_hackathon/app/views/onboarding/onboarding_view.dart';
import 'package:pupilica_hackathon/app/views/home/home_view.dart';
import 'package:pupilica_hackathon/app/views/document_upload/document_upload_view.dart';
import 'package:pupilica_hackathon/app/views/pdf_preview/pdf_preview_view.dart';

/// App router configuration using Go Router
class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String documentUpload = '/document-upload';
  static const String pdfPreview = '/pdf-preview';

  /// Go Router configuration
  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      // Splash Screen
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashView(),
      ),

      // Onboarding Screen
      GoRoute(
        path: onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingView(),
      ),

      // Home Screen
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomeView(),
      ),

      // Document Upload
      GoRoute(
        path: documentUpload,
        name: 'documentUpload',
        builder: (context, state) => const DocumentUploadView(),
      ),

      // PDF Preview
      GoRoute(
        path: pdfPreview,
        name: 'pdfPreview',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return PDFPreviewView(
            extractedText: extra?['extractedText'] ?? '',
            documentNames: extra?['documentNames'] ?? [],
            pdfBytes: extra?['pdfBytes'],
          );
        },
      ),
    ],
    errorBuilder: (context, state) => _buildErrorPage(context, state.error),
  );

  /// Build error page
  static Widget _buildErrorPage(BuildContext context, Exception? error) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 100, color: Colors.red),
            const SizedBox(height: 20),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              error?.toString() ?? 'Unknown error',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go(splash),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
