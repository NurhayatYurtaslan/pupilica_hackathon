import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:pupilica_hackathon/app/routes/app_router.dart';
import 'package:pupilica_hackathon/app/views/onboarding/models/module/event.dart';
import 'package:pupilica_hackathon/app/views/onboarding/models/module/state.dart';
import 'package:pupilica_hackathon/app/views/onboarding/models/onboarding_view_model.dart';
import 'package:pupilica_hackathon/app/views/onboarding/widgets/onboarding_page_widget.dart';
import 'package:pupilica_hackathon/app/views/onboarding/widgets/onboarding_navigation_widget.dart';
import 'package:pupilica_hackathon/app/views/onboarding/widgets/onboarding_skip_button_widget.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    // System UI visibility management
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return BlocProvider(
      create: (context) =>
          OnboardingViewModel()..add(OnboardingInitialEvent(context)),
      child: BlocBuilder<OnboardingViewModel, OnboardingState>(
        builder: (context, state) {
          if (state is OnboardingLoadedState) {
            return _buildOnboardingContent(context, state);
          }

          return OsmeaComponents.scaffold(
            body: OsmeaComponents.center(
              child: OsmeaComponents.loading(type: LoadingType.atom),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOnboardingContent(
    BuildContext context,
    OnboardingLoadedState state,
  ) {
    return OsmeaComponents.scaffold(
      body: OsmeaComponents.container(
        width: context.allWidth,
        height: context.allHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              state.pages[state.currentPage].color,
              state.pages[state.currentPage].color.withValues(alpha: 0.8),
              state.pages[state.currentPage].color.withValues(alpha: 0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: OsmeaComponents.column(
            children: [
              // Skip button
              OnboardingSkipButtonWidget(
                onSkip: () {
                  // Skip to last page (Get Started page)
                  context.read<OnboardingViewModel>().add(
                    OnboardingSkipEvent(),
                  );
                },
              ),

              // Page view
              OsmeaComponents.expanded(
                child: PageView.builder(
                  controller: context
                      .read<OnboardingViewModel>()
                      .pageController,
                  itemCount: state.pages.length,
                  onPageChanged: (index) {
                    final viewModel = context.read<OnboardingViewModel>();

                    // Skip işlemi sırasında onPageChanged'i tamamen devre dışı bırak
                    if (viewModel.isSkipping) {
                      return;
                    }

                    if (index != state.currentPage) {
                      if (index > state.currentPage) {
                        viewModel.add(OnboardingNextPageEvent());
                      } else {
                        viewModel.add(OnboardingPreviousPageEvent());
                      }
                    }
                  },
                  itemBuilder: (context, index) {
                    return OnboardingPageWidget(page: state.pages[index]);
                  },
                ),
              ),

              // Page indicator and navigation
              OnboardingNavigationWidget(
                currentPage: state.currentPage,
                totalPages: state.pages.length,
                currentPageColor: state.pages[state.currentPage].color,
                onNext: () {
                  if (state.currentPage == state.pages.length - 1) {
                    // Get Started button - complete onboarding and navigate
                    context.read<OnboardingViewModel>().add(
                      OnboardingCompleteEvent(),
                    );
                    context.go(AppRouter.home);
                  } else {
                    // Continue button - go to next page
                    context.read<OnboardingViewModel>().add(
                      OnboardingNextPageEvent(),
                    );
                  }
                },
                onSkip: () {
                  context.read<OnboardingViewModel>().add(
                    OnboardingSkipEvent(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
