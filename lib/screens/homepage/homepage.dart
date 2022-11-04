import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/constants/mk_images.dart';
import 'package:tailor_made/constants/mk_strings.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/rebloc/accounts/actions.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/auth/actions.dart';
import 'package:tailor_made/rebloc/common/home_view_model.dart';
import 'package:tailor_made/screens/homepage/_partials/bottom_row.dart';
import 'package:tailor_made/screens/homepage/_partials/create_button.dart';
import 'package:tailor_made/screens/homepage/_partials/header.dart';
import 'package:tailor_made/screens/homepage/_partials/mid_row.dart';
import 'package:tailor_made/screens/homepage/_partials/stats.dart';
import 'package:tailor_made/screens/homepage/_partials/top_button_bar.dart';
import 'package:tailor_made/screens/homepage/_partials/top_row.dart';
import 'package:tailor_made/screens/homepage/_views/access_denied.dart';
import 'package:tailor_made/screens/homepage/_views/out_dated.dart';
import 'package:tailor_made/screens/homepage/_views/rate_limit.dart';
import 'package:tailor_made/utils/mk_phone.dart';
import 'package:tailor_made/utils/ui/app_version_builder.dart';
import 'package:tailor_made/utils/ui/mk_choice_dialog.dart';
import 'package:tailor_made/utils/ui/mk_status_bar.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:version/version.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.isMock});

  final bool isMock;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => mkChoiceDialog(context: context, message: 'Continue with Exit?').then((bool? value) => value!),
      child: MkStatusBar(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              const Opacity(
                opacity: .5,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: MkImages.pattern, fit: BoxFit.cover),
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
      return const MkLoadingSpinner();
    }

    if (viewModel.isDisabled) {
      return AccessDeniedPage(
        onSendMail: () {
          email(
            'jeremiahogbomo@gmail.com',
            '${MkStrings.appName} - Unwarranted%20Account%20Suspension%20%23${viewModel.account!.uid}',
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
