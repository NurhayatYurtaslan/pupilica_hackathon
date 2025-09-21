import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pupilica_hackathon/app/views/splash/splash_view.dart';
import 'package:pupilica_hackathon/app/views/onboarding/onboarding_view.dart';
import 'package:pupilica_hackathon/app/views/home/home_view.dart';
import 'package:pupilica_hackathon/app/views/document_upload/document_upload_view.dart';
import 'package:pupilica_hackathon/app/views/lesson_list/lesson_list_view.dart';
import 'package:pupilica_hackathon/app/views/lesson_detail/lesson_detail_view.dart';
import 'package:pupilica_hackathon/app/views/lesson_creation/lesson_creation_view.dart';
import 'package:pupilica_hackathon/core/services/document_service.dart';
import 'package:pupilica_hackathon/core/models/lesson_note.dart';

/// App router configuration using Go Router
class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String documentUpload = '/document-upload';
  static const String lessonCreation = '/lesson-creation';
  static const String lessonList = '/lesson-list';
  static const String lessonDetail = '/lesson-detail';

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

      // Lesson List
      GoRoute(
        path: lessonList,
        name: 'lessonList',
        builder: (context, state) => const LessonListView(),
      ),

      // Lesson Detail
      GoRoute(
        path: lessonDetail,
        name: 'lessonDetail',
        builder: (context, state) {
          final lesson = state.extra as LessonNote?;
          if (lesson == null) {
            return _buildErrorPage(context, Exception('Lesson not found'));
          }
          return LessonDetailView(lesson: lesson);
        },
      ),

      // Lesson Creation
      GoRoute(
        path: lessonCreation,
        name: 'lessonCreation',
        builder: (context, state) {
          if (state.extra is Map<String, dynamic>) {
            final extra = state.extra as Map<String, dynamic>;
            final documents = extra['documents'] as List<DocumentFile>? ?? [];
            final extractedText = extra['extractedText'] as String? ?? '';
            return LessonCreationView(
              documents: documents,
              extractedText: extractedText,
            );
          } else if (state.extra is List<DocumentFile>) {
            final documents = state.extra as List<DocumentFile>;
            return LessonCreationView(documents: documents, extractedText: '');
          } else {
            return _buildErrorPage(
              context,
              Exception('Invalid lesson creation data'),
            );
          }
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
