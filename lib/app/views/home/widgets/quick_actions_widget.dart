import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:pupilica_hackathon/app/routes/app_router.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

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
            'Quick Actions',
            textStyle: OsmeaTextStyle.headlineSmall(context),
            color: OsmeaColors.white,
            textAlign: context.textCenter,
          ),
          OsmeaComponents.sizedBox(height: 20),

          // Action buttons
          OsmeaComponents.row(
            children: [
              // Upload Documents
              OsmeaComponents.expanded(
                child: OsmeaComponents.container(
                  margin: const EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    onPressed: () => context.go(AppRouter.documentUpload),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: OsmeaColors.white.withValues(alpha: 0.2),
                      foregroundColor: OsmeaColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: OsmeaComponents.text(
                      'Upload Documents',
                      textStyle: OsmeaTextStyle.bodyMedium(context),
                      color: OsmeaColors.white,
                      textAlign: context.textCenter,
                    ),
                  ),
                ),
              ),

              // My Lessons
              OsmeaComponents.expanded(
                child: OsmeaComponents.container(
                  margin: const EdgeInsets.only(left: 8),
                  child: ElevatedButton(
                    onPressed: () => context.go(AppRouter.lessonList),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: OsmeaColors.white.withValues(alpha: 0.2),
                      foregroundColor: OsmeaColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: OsmeaComponents.text(
                      'My Lessons',
                      textStyle: OsmeaTextStyle.bodyMedium(context),
                      color: OsmeaColors.white,
                      textAlign: context.textCenter,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
