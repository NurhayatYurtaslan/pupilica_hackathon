import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:pupilica_hackathon/app/routes/app_router.dart';
import 'package:pupilica_hackathon/app/views/home/models/module/event.dart';
import 'package:pupilica_hackathon/app/views/home/models/module/state.dart';
import 'package:pupilica_hackathon/app/views/home/models/home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // System UI visibility management
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return BlocProvider(
      create: (context) {
        return HomeViewModel()..add(HomeInitialEvent(context));
      },
      child: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          return OsmeaComponents.scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF1E3A8A).withValues(alpha: 0.9),
              elevation: 0,
              leading: IconButton(
                onPressed: () => context.go(AppRouter.home),
                icon: const Icon(Icons.home, color: Colors.white),
              ),
              title: OsmeaComponents.text(
                'Pupilica AI',
                fontSize: context.fontSizeLarge,
                fontWeight: context.bold,
                color: Colors.white,
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () => context.go(AppRouter.documentUpload),
                  icon: const Icon(Icons.upload, color: Colors.white),
                ),
              ],
            ),
            body: OsmeaComponents.container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF1E3A8A), // Deep blue
                    const Color(0xFF3B82F6), // Blue
                    const Color(0xFF60A5FA), // Light blue
                    const Color(0xFF93C5FD), // Very light blue
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(context.spacing20),
                    child: OsmeaComponents.column(
                      children: [
                        // Header - More compact
                        _buildModernHeader(context),

                        OsmeaComponents.sizedBox(height: context.height40),

                        // Quick Actions - More modern
                        _buildModernQuickActions(context),

                        OsmeaComponents.sizedBox(height: context.height40),

                        // Statistics - Grid layout
                        if (state is HomeLoadedState)
                          _buildModernStatistics(context, state.statistics),

                        OsmeaComponents.sizedBox(height: context.height40),

                        // Recent Lessons - Card style
                        if (state is HomeLoadedState)
                          _buildModernRecentLessons(
                            context,
                            state.recentLessons,
                          )
                        else
                          _buildModernEmptyState(context),

                        OsmeaComponents.sizedBox(height: context.height40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildModernHeader(BuildContext context) {
    return OsmeaComponents.column(
      children: [
        // Modern logo with glow effect
        OsmeaComponents.container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.3),
                Colors.white.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            Icons.psychology_alt,
            size: 50,
            color: Colors.white,
          ),
        ),
        OsmeaComponents.sizedBox(height: context.height24),
        OsmeaComponents.text(
          'Pupilica AI',
          fontSize: context.fontSizeExtraLarge,
          fontWeight: context.extraBold,
          letterSpacing: context.letterSpacingWide,
          color: Colors.white,
        ),
        OsmeaComponents.sizedBox(height: context.height8),
        OsmeaComponents.text(
          'Smart Learning Assistant',
          fontSize: context.fontSizeMedium,
          fontWeight: context.light,
          color: Colors.white.withValues(alpha: 0.8),
        ),
      ],
    );
  }

  Widget _buildModernQuickActions(BuildContext context) {
    return OsmeaComponents.row(
      children: [
        OsmeaComponents.expanded(
          child: _buildActionCard(
            context,
            'Upload',
            Icons.cloud_upload_outlined,
            () => context.go(AppRouter.documentUpload),
          ),
        ),
        OsmeaComponents.sizedBox(width: context.width16),
        OsmeaComponents.expanded(
          child: _buildActionCard(
            context,
            'Lessons',
            Icons.school_outlined,
            () => context.go(AppRouter.lessonList),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: OsmeaComponents.container(
        height: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.2),
              Colors.white.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: OsmeaComponents.column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.white),
            const SizedBox(height: 12),
            OsmeaComponents.text(
              title,
              fontSize: context.fontSizeMedium,
              fontWeight: context.semiBold,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernStatistics(
    BuildContext context,
    Map<String, dynamic> statistics,
  ) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          'Your Progress',
          fontSize: context.fontSizeLarge,
          fontWeight: context.bold,
          color: Colors.white,
        ),
        OsmeaComponents.sizedBox(height: context.height20),
        OsmeaComponents.row(
          children: [
            OsmeaComponents.expanded(
              child: _buildStatItem(
                '${statistics['totalNotes']}',
                'Lessons',
                Icons.library_books_outlined,
              ),
            ),
            OsmeaComponents.sizedBox(width: context.width12),
            OsmeaComponents.expanded(
              child: _buildStatItem(
                '${statistics['processedNotes']}',
                'Processed',
                Icons.check_circle_outline,
              ),
            ),
            OsmeaComponents.sizedBox(width: context.width12),
            OsmeaComponents.expanded(
              child: _buildStatItem(
                '${statistics['totalDocuments']}',
                'Documents',
                Icons.description_outlined,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return OsmeaComponents.container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: OsmeaComponents.column(
        children: [
          Icon(icon, size: 24, color: Colors.white.withValues(alpha: 0.8)),
          const SizedBox(height: 8),
          OsmeaComponents.text(
            value,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          OsmeaComponents.text(
            label,
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ],
      ),
    );
  }

  Widget _buildModernRecentLessons(
    BuildContext context,
    List<dynamic> recentLessons,
  ) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          'Recent Lessons',
          fontSize: context.fontSizeLarge,
          fontWeight: context.bold,
          color: Colors.white,
        ),
        OsmeaComponents.sizedBox(height: context.height16),
        ...recentLessons.take(3).map((lesson) => _buildLessonItem(lesson)),
      ],
    );
  }

  Widget _buildLessonItem(dynamic lesson) {
    return OsmeaComponents.container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.school_outlined,
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OsmeaComponents.text(
                  lesson.title ?? 'Untitled Lesson',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                OsmeaComponents.text(
                  lesson.subject ?? 'No subject',
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildModernEmptyState(BuildContext context) {
    return OsmeaComponents.column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.library_books_outlined,
            size: 40,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
        OsmeaComponents.sizedBox(height: context.height20),
        OsmeaComponents.text(
          'No lessons yet',
          fontSize: context.fontSizeLarge,
          fontWeight: context.bold,
          color: Colors.white,
        ),
        OsmeaComponents.sizedBox(height: context.height8),
        OsmeaComponents.text(
          'Upload your first document to get started',
          fontSize: context.fontSizeSmall,
          color: Colors.white.withValues(alpha: 0.7),
          textAlign: context.textCenter,
        ),
      ],
    );
  }
}
