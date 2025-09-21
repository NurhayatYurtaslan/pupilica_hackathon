import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:pupilica_hackathon/core/models/lesson_note.dart';
import 'package:pupilica_hackathon/app/routes/app_router.dart';
import 'package:pupilica_hackathon/app/views/lesson_detail/models/lesson_detail_view_model.dart';
import 'package:pupilica_hackathon/app/views/lesson_detail/models/module/event.dart';
import 'package:pupilica_hackathon/app/views/lesson_detail/models/module/state.dart';

class LessonDetailView extends StatelessWidget {
  final LessonNote lesson;

  const LessonDetailView({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return BlocProvider(
      create: (context) {
        return LessonDetailViewModel()
          ..add(LessonDetailInitialEvent(lesson: lesson));
      },
      child: BlocBuilder<LessonDetailViewModel, LessonDetailState>(
        builder: (context, state) {
          return OsmeaComponents.scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFFDC2626).withValues(alpha: 0.9),
              elevation: 0,
              leading: IconButton(
                onPressed: () => context.go(AppRouter.lessonList),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              title: OsmeaComponents.text(
                lesson.title,
                fontSize: context.fontSizeLarge,
                fontWeight: context.bold,
                color: Colors.white,
                overflow: context.ellipsis,
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () => _showOptions(context),
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                ),
              ],
            ),
            body: OsmeaComponents.container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFDC2626), // Red
                    const Color(0xFFEF4444), // Light red
                    const Color(0xFFF87171), // Very light red
                    const Color(0xFFFCA5A5), // Pink
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

  Widget _buildContent(BuildContext context, LessonDetailState state) {
    if (state is LessonDetailLoadingState) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (state is LessonDetailErrorState) {
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
                context.read<LessonDetailViewModel>().add(
                  LessonDetailRefreshEvent(lesson: lesson),
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

    if (state is LessonDetailLoadedState) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lesson info card
            _buildLessonInfoCard(context, state.lesson),

            const SizedBox(height: 20),

            // Documents section
            _buildDocumentsSection(context, state.lesson),

            const SizedBox(height: 20),

            // Extracted text section
            if (state.lesson.isProcessed &&
                state.lesson.extractedText.isNotEmpty)
              _buildExtractedTextSection(context, state.lesson),
          ],
        ),
      );
    }

    return const Center(child: CircularProgressIndicator(color: Colors.white));
  }

  Widget _buildLessonInfoCard(BuildContext context, LessonNote lesson) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.school, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OsmeaComponents.text(
                      lesson.title,
                      fontSize: context.fontSizeLarge,
                      fontWeight: context.bold,
                      color: Colors.white,
                    ),
                    OsmeaComponents.sizedBox(height: context.height4),
                    OsmeaComponents.text(
                      lesson.subject,
                      fontSize: context.fontSizeMedium,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: lesson.isProcessed
                      ? Colors.green.withValues(alpha: 0.2)
                      : Colors.orange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: lesson.isProcessed ? Colors.green : Colors.orange,
                    width: 1,
                  ),
                ),
                child: Text(
                  lesson.isProcessed ? 'Processed' : 'Processing',
                  style: TextStyle(
                    color: lesson.isProcessed ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          if (lesson.description.isNotEmpty) ...[
            const SizedBox(height: 16),
            OsmeaComponents.text(
              'Description',
              fontSize: context.fontSizeMedium,
              fontWeight: context.semiBold,
              color: Colors.white,
            ),
            OsmeaComponents.sizedBox(height: context.height8),
            OsmeaComponents.text(
              lesson.description,
              fontSize: context.fontSizeSmall,
              color: Colors.white70,
            ),
          ],

          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoItem(
                Icons.description,
                '${lesson.documents.length} Documents',
              ),
              const SizedBox(width: 20),
              _buildInfoItem(Icons.access_time, _formatDate(lesson.createdAt)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white70, fontSize: 14)),
      ],
    );
  }

  Widget _buildDocumentsSection(BuildContext context, LessonNote lesson) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          'Documents',
          fontSize: context.fontSizeLarge,
          fontWeight: context.bold,
          color: Colors.white,
        ),
        const SizedBox(height: 12),
        ...lesson.documents.map((doc) => _buildDocumentCard(doc)),
      ],
    );
  }

  Widget _buildDocumentCard(dynamic doc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(_getDocumentIcon(doc.name), color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              doc.name,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          Text(
            _formatFileSize(doc.size),
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildExtractedTextSection(BuildContext context, LessonNote lesson) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            OsmeaComponents.text(
              'Extracted Text',
              fontSize: context.fontSizeLarge,
              fontWeight: context.bold,
              color: Colors.white,
            ),
            const Spacer(),
            IconButton(
              onPressed: () => _copyText(context, lesson),
              icon: const Icon(Icons.copy, color: Colors.white70),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: SelectableText(
            lesson.extractedText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  IconData _getDocumentIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'png':
      case 'jpg':
      case 'jpeg':
        return Icons.image;
      default:
        return Icons.description;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _copyText(BuildContext context, LessonNote lesson) {
    Clipboard.setData(ClipboardData(text: lesson.extractedText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Text copied to clipboard'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Lesson'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement edit functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement share functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Lesson'),
        content: const Text('Are you sure you want to delete this lesson?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<LessonDetailViewModel>().add(
                LessonDetailDeleteEvent(lessonId: lesson.id),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
