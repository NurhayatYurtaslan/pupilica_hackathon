import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';

class StatisticsWidget extends StatelessWidget {
  final Map<String, dynamic> statistics;

  const StatisticsWidget({super.key, required this.statistics});

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
            'Your Progress',
            textStyle: OsmeaTextStyle.headlineSmall(context),
            color: OsmeaColors.white,
            textAlign: context.textCenter,
          ),
          OsmeaComponents.sizedBox(height: 20),

          OsmeaComponents.row(
            children: [
              _buildStatCard(
                context,
                'Total Lessons',
                '${statistics['totalNotes'] ?? 0}',
                Icons.library_books,
              ),
              _buildStatCard(
                context,
                'Processed',
                '${statistics['processedNotes'] ?? 0}',
                Icons.check_circle,
              ),
              _buildStatCard(
                context,
                'Documents',
                '${statistics['totalDocuments'] ?? 0}',
                Icons.description,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return OsmeaComponents.expanded(
      child: OsmeaComponents.container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: OsmeaColors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: OsmeaColors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: OsmeaComponents.column(
          children: [
            Icon(
              icon,
              size: 32,
              color: OsmeaColors.white.withValues(alpha: 0.9),
            ),
            OsmeaComponents.sizedBox(height: 12),
            OsmeaComponents.text(
              value,
              textStyle: OsmeaTextStyle.headlineSmall(context),
              color: OsmeaColors.white,
              textAlign: context.textCenter,
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.text(
              title,
              textStyle: OsmeaTextStyle.bodySmall(context),
              color: OsmeaColors.white.withValues(alpha: 0.8),
              textAlign: context.textCenter,
            ),
          ],
        ),
      ),
    );
  }
}
