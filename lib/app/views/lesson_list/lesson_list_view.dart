import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:pupilica_hackathon/core/models/lesson_note.dart';
import 'package:pupilica_hackathon/app/routes/app_router.dart';
import 'package:pupilica_hackathon/app/views/lesson_list/models/lesson_list_view_model.dart';
import 'package:pupilica_hackathon/app/views/lesson_list/models/module/event.dart';
import 'package:pupilica_hackathon/app/views/lesson_list/models/module/state.dart';

class LessonListView extends StatelessWidget {
  const LessonListView({super.key});

  @override
  Widget build(BuildContext context) {
    // System UI visibility management
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return BlocProvider(
      create: (context) {
        return LessonListViewModel()..add(LessonListInitialEvent(context));
      },
      child: BlocBuilder<LessonListViewModel, LessonListState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF059669).withValues(alpha: 0.9),
              elevation: 0,
              leading: IconButton(
                onPressed: () => context.go(AppRouter.home),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              title: const Text(
                'My Lessons',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () => context.go(AppRouter.documentUpload),
                  icon: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF059669), // Emerald
                    const Color(0xFF10B981), // Light emerald
                    const Color(0xFF34D399), // Very light emerald
                    const Color(0xFF6EE7B7), // Mint
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
              child: SafeArea(child: _buildContent(context, state)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, LessonListState state) {
    if (state is LessonListLoadingState) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (state is LessonListErrorState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.white, size: 64),
            const SizedBox(height: 16),
            Text(
              'Error: ${state.error}',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<LessonListViewModel>().add(
                  LessonListRefreshEvent(context),
                );
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is LessonListLoadedState) {
      final lessons = state.lessons;

      if (lessons.isEmpty) {
        return _buildEmptyState(context);
      }

      return _buildLessonsList(context, lessons);
    }

    return const Center(child: CircularProgressIndicator(color: Colors.white));
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.library_books_outlined,
            color: Colors.white,
            size: 80,
          ),
          const SizedBox(height: 20),
          const Text(
            'No lessons yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Upload your first document to get started',
            style: TextStyle(fontSize: 16, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => context.go(AppRouter.documentUpload),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Upload Documents',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonsList(BuildContext context, List<LessonNote> lessons) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        return _buildLessonCard(context, lesson);
      },
    );
  }

  Widget _buildLessonCard(BuildContext context, LessonNote lesson) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.school, color: Colors.white, size: 24),
        ),
        title: Text(
          lesson.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              lesson.subject,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              '${lesson.documents.length} documents • ${lesson.isProcessed ? 'Processed' : 'Processing...'}',
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: 16,
        ),
        onTap: () {
          context.go(AppRouter.lessonDetail, extra: lesson);
        },
      ),
    );
  }
}
