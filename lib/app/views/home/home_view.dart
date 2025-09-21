import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:pupilica_hackathon/app/routes/app_router.dart';
import 'package:pupilica_hackathon/app/views/home/models/module/event.dart';
import 'package:pupilica_hackathon/app/views/home/models/module/state.dart';
import 'package:pupilica_hackathon/app/views/home/models/home_view_model.dart';
import 'package:pupilica_hackathon/app/views/home/widgets/home_header_widget.dart';
import 'package:pupilica_hackathon/app/views/home/widgets/quick_actions_widget.dart';
import 'package:pupilica_hackathon/app/views/home/widgets/statistics_widget.dart';
import 'package:pupilica_hackathon/app/views/home/widgets/recent_lessons_widget.dart';

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
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF1E3A8A).withValues(alpha: 0.9),
              elevation: 0,
              leading: IconButton(
                onPressed: () => context.go(AppRouter.home),
                icon: const Icon(Icons.home, color: Colors.white),
              ),
              title: const Text(
                'Pupilica AI',
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
                  icon: const Icon(Icons.upload, color: Colors.white),
                ),
              ],
            ),
            body: Container(
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
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Header
                        const HomeHeaderWidget(),

                        const SizedBox(height: 30),

                        // Quick Actions
                        const QuickActionsWidget(),

                        const SizedBox(height: 30),

                        // Statistics
                        if (state is HomeLoadedState)
                          StatisticsWidget(statistics: state.statistics),

                        const SizedBox(height: 30),

                        // Recent Lessons
                        if (state is HomeLoadedState)
                          RecentLessonsWidget(
                            recentLessons: state.recentLessons,
                          )
                        else
                          _buildEmptyLessonsState(context),

                        // Bottom spacing
                        const SizedBox(height: 30),
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

  Widget _buildEmptyLessonsState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Recent Lessons',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Icon(
            Icons.library_books_outlined,
            size: 60,
            color: Colors.white.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 20),
          const Text(
            'No lessons yet',
            style: TextStyle(fontSize: 16, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Upload your first document to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
