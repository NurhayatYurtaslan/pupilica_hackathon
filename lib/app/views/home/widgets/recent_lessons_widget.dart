import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';

class RecentLessonsWidget extends StatelessWidget {
  final List<dynamic> recentLessons;

  const RecentLessonsWidget({super.key, required this.recentLessons});

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: OsmeaColors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: OsmeaColors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: OsmeaComponents.column(
        children: [
          OsmeaComponents.text(
            'Recent Lessons',
            textStyle: OsmeaTextStyle.headlineSmall(context),
            color: OsmeaColors.white,
            textAlign: context.textCenter,
          ),
          OsmeaComponents.sizedBox(height: 20),
          OsmeaComponents.column(
            children: recentLessons
                .take(5)
                .map((lesson) => _buildLessonCard(context, lesson))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonCard(BuildContext context, dynamic lesson) {
    return OsmeaComponents.container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: OsmeaColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: OsmeaColors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: OsmeaComponents.row(
        children: [
          Icon(
            Icons.school,
            size: 28,
            color: OsmeaColors.white.withValues(alpha: 0.9),
          ),
          OsmeaComponents.sizedBox(width: 16),
          OsmeaComponents.expanded(
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OsmeaComponents.text(
                  lesson.title ?? 'Untitled Lesson',
                  textStyle: OsmeaTextStyle.bodyLarge(context),
                  color: OsmeaColors.white,
                ),
                OsmeaComponents.sizedBox(height: 4),
                OsmeaComponents.text(
                  lesson.subject ?? 'No subject',
                  textStyle: OsmeaTextStyle.bodySmall(context),
                  color: OsmeaColors.white.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: OsmeaColors.white.withValues(alpha: 0.6),
          ),
        ],
      ),
    );
  }
}
