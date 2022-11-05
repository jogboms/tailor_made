import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/presentation/constants.dart';
import 'package:tailor_made/presentation/rebloc.dart';
import 'package:tailor_made/presentation/theme.dart';
import 'package:tailor_made/presentation/utils.dart';
import 'package:tailor_made/presentation/widgets.dart';
import 'package:version/version.dart';

import 'widgets/access_denied.dart';
import 'widgets/bottom_row.dart';
import 'widgets/create_button.dart';
import 'widgets/header.dart';
import 'widgets/mid_row.dart';
import 'widgets/out_dated.dart';
import 'widgets/rate_limit.dart';
import 'widgets/stats.dart';
import 'widgets/top_button_bar.dart';
import 'widgets/top_row.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.isMock});

  final bool isMock;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showChoiceDialog(context: context, message: 'Continue with Exit?').then((bool? value) => value!),
      child: AppStatusBar(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              const Opacity(
                opacity: .5,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AppImages.pattern, fit: BoxFit.cover),
                  ),
                ),
              ),
              AppVersionBuilder(
                valueBuilder: () => AppVersion.retrieve(isMock),
                builder: (BuildContext context, String? appVersion, Widget? child) {
                  if (appVersion == null) {
                    return child!;
                  }

                  final Version currentVersion = Version.parse(appVersion);
                  final AppState state = StoreProvider.of<AppState>(context).states.valueWrapper!.value;
                  final Version latestVersion = Version.parse(state.settings.settings?.versionName ?? '1.0.0');

                  if (latestVersion > currentVersion) {
                    return OutDatedPage(
                      onUpdate: () {
                        // TODO(Jogboms): take note for apple if that ever happens
                        open('https://play.google.com/store/apps/details?id=io.github.jogboms.tailormade');
                      },
                    );
                  }

                  return child!;
                },
                child: ViewModelSubscriber<AppState, HomeViewModel>(
                  converter: HomeViewModel.new,
                  builder: (_, DispatchFunction dispatch, HomeViewModel vm) =>
                      _Body(viewModel: vm, dispatch: dispatch, isMock: isMock),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.dispatch, required this.viewModel, required this.isMock});

  final HomeViewModel viewModel;
  final DispatchFunction dispatch;
  final bool isMock;

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading) {
      return const LoadingSpinner();
    }

    if (viewModel.isDisabled) {
      return AccessDeniedPage(
        onSendMail: () {
          email(
            'jeremiahogbomo@gmail.com',
            '${AppStrings.appName} - Unwarranted%20Account%20Suspension%20%23${viewModel.account!.uid}',
          );
        },
      );
    }

    if (viewModel.isWarning && viewModel.hasSkipedPremium == false) {
      return RateLimitPage(
        onSignUp: () => dispatch(OnPremiumSignUp(viewModel.account)),
        onSkipedPremium: () => dispatch(const OnSkipedPremium()),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(flex: 12, child: HeaderWidget(account: viewModel.account)),
            StatsWidget(stats: viewModel.stats),
            Expanded(flex: 2, child: TopRowWidget(stats: viewModel.stats)),
            Expanded(flex: 2, child: MidRowWidget(userId: viewModel.account!.uid, stats: viewModel.stats)),
            Expanded(flex: 2, child: BottomRowWidget(stats: viewModel.stats, account: viewModel.account)),
            SizedBox(height: kButtonHeight + MediaQuery.of(context).padding.bottom),
          ],
        ),
        CreateButton(userId: viewModel.account!.uid, contacts: viewModel.contacts),
        TopButtonBar(
          account: viewModel.account,
          shouldSendRating: viewModel.shouldSendRating,
          onLogout: () async {
            dispatch(const OnLogoutAction());
            Dependencies.di().sharedCoordinator.toSplash(isMock);
          },
        ),
      ],
    );
  }
}
