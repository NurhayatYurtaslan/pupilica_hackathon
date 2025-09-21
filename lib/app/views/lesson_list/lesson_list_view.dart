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
          return OsmeaComponents.scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF059669).withValues(alpha: 0.9),
              elevation: 0,
              leading: IconButton(
                onPressed: () => context.go(AppRouter.home),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              title: OsmeaComponents.text(
                'My Lessons',
                fontSize: context.fontSizeLarge,
                fontWeight: context.bold,
                color: Colors.white,
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () => context.go(AppRouter.documentUpload),
                  icon: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            body: OsmeaComponents.container(
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
            OsmeaComponents.text(
              'Error: ${state.error}',
              fontSize: context.fontSizeMedium,
              color: Colors.white,
              textAlign: context.textCenter,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<LessonListViewModel>().add(
                  LessonListRefreshEvent(context),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                foregroundColor: Colors.white,
              ),
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
          OsmeaComponents.text(
            'No lessons yet',
            fontSize: context.fontSizeExtraLarge,
            fontWeight: context.bold,
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          OsmeaComponents.text(
            'Upload your first document to get started',
            fontSize: context.fontSizeMedium,
            color: Colors.white70,
            textAlign: context.textCenter,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => context.go(AppRouter.documentUpload),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Upload Documents'),
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
        title: OsmeaComponents.text(
          lesson.title,
          fontSize: context.fontSizeLarge,
          fontWeight: context.bold,
          color: Colors.white,
        ),
        subtitle: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OsmeaComponents.sizedBox(height: context.height4),
            OsmeaComponents.text(
              lesson.subject,
              fontSize: context.fontSizeSmall,
              color: Colors.white70,
            ),
            OsmeaComponents.sizedBox(height: context.height4),
            OsmeaComponents.text(
              '${lesson.documents.length} documents • ${lesson.isProcessed ? 'Processed' : 'Processing...'}',
              fontSize: context.fontSizeSmall,
              color: Colors.white60,
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
