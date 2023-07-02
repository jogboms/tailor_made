import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';
import 'package:tailor_made/presentation/screens/homepage/providers/home_notifier_provider.dart';
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
              Opacity(
                opacity: Theme.of(context).brightness == Brightness.light ? .5 : .1,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AppImages.pattern, fit: BoxFit.cover),
                  ),
                ),
              ),
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) => ref.watch(homeNotifierProvider).when(
                      skipLoadingOnReload: true,
                      data: (HomeState state) => AppVersionBuilder(
                        valueBuilder: () => AppVersion.retrieve(isMock),
                        builder: (BuildContext context, String? appVersion, Widget? child) {
                          if (appVersion == null) {
                            return child!;
                          }

                          final Version currentVersion = Version.parse(appVersion);
                          final Version latestVersion = Version.parse(state.settings.versionName);

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
                        child: _Body(
                          state: state,
                          homeNotifier: ref.read(homeNotifierProvider.notifier),
                          accountNotifier: ref.read(accountNotifierProvider.notifier),
                          isMock: isMock,
                        ),
                      ),
                      error: ErrorView.new,
                      loading: () => child!,
                    ),
                child: const Center(child: LoadingSpinner()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.state,
    required this.homeNotifier,
    required this.accountNotifier,
    required this.isMock,
  });

  final HomeState state;
  final HomeNotifier homeNotifier;
  final AccountNotifier accountNotifier;
  final bool isMock;

  @override
  Widget build(BuildContext context) {
    final AccountEntity account = state.account;
    final StatsEntity stats = state.stats;

    if (state.isDisabled) {
      return AccessDeniedPage(
        onSendMail: () {
          email(
            'jeremiahogbomo@gmail.com',
            '${context.l10n.appName} - Unwarranted%20Account%20Suspension%20%23${account.uid}',
          );
        },
      );
    }

    if (state.isWarning && state.hasSkippedPremium == false) {
      return RateLimitPage(
        onSignUp: accountNotifier.premiumSetup,
        onSkippedPremium: homeNotifier.skippedPremium,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(flex: 12, child: HeaderWidget(account: account)),
            StatsWidget(stats: stats),
            Expanded(flex: 2, child: TopRowWidget(stats: stats)),
            Expanded(flex: 2, child: MidRowWidget(userId: account.uid, stats: stats)),
            Expanded(flex: 2, child: BottomRowWidget(stats: stats)),
            SizedBox(height: Theme.of(context).buttonTheme.height + MediaQuery.of(context).padding.bottom),
          ],
        ),
        CreateButton(userId: account.uid, contacts: state.contacts),
        TopButtonBar(
          account: account,
          shouldSendRating: state.shouldSendRating,
          onLogout: () {
            accountNotifier.logout();
            context.registry.get<SharedCoordinator>().toSplash(isMock);
          },
        ),
      ],
    );
  }
}
