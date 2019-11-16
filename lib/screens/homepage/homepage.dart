import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/constants/mk_images.dart';
import 'package:tailor_made/constants/mk_strings.dart';
import 'package:tailor_made/constants/mk_style.dart';
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
import 'package:tailor_made/widgets/dependencies.dart';
import 'package:version/version.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    return WillPopScope(
      onWillPop: () => mkChoiceDialog(context: context, message: "Continue with Exit?"),
      child: MkStatusBar(
        brightness: Brightness.dark,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
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
                valueBuilder: () => AppVersion.retrieve(Dependencies.di().session.isMock),
                builder: (context, appVersion, child) {
                  final currentVersion = Version.parse(appVersion);
                  final latestVersion = Version.parse(store.states.value?.settings?.settings?.versionName ?? "1.0.0");

                  if (latestVersion > currentVersion) {
                    return OutDatedPage(onUpdate: () {
                      // TODO: take note for apple if that ever happens
                      open('https://play.google.com/store/apps/details?id=io.github.jogboms.tailormade');
                    });
                  }

                  return child;
                },
                child: _Body(viewModel: HomeViewModel(store.states.value), dispatch: store.dispatch),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key key, @required this.dispatch, @required this.viewModel}) : super(key: key);

  final HomeViewModel viewModel;
  final DispatchFunction dispatch;

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading) {
      return const MkLoadingSpinner();
    }

    if (viewModel.isDisabled) {
      return AccessDeniedPage(onSendMail: () {
        email(
          "jeremiahogbomo@gmail.com",
          '${MkStrings.appName} - Unwarranted%20Account%20Suspension%20%23${viewModel.account.uid}',
        );
      });
    }

    if (viewModel.isWarning && viewModel.hasSkipedPremium == false) {
      return RateLimitPage(
        onSignUp: () => dispatch(OnPremiumSignUp(payload: viewModel.account)),
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
            Expanded(flex: 2, child: MidRowWidget(stats: viewModel.stats)),
            Expanded(flex: 2, child: BottomRowWidget(stats: viewModel.stats, account: viewModel.account)),
            SizedBox(height: kButtonHeight + MediaQuery.of(context).padding.bottom),
          ],
        ),
        CreateButton(contacts: viewModel.contacts),
        TopButtonBar(
          account: viewModel.account,
          shouldSendRating: viewModel.shouldSendRating,
          onLogout: () async {
            await Dependencies.di().accounts.signout();
            dispatch(const OnLogoutAction());
            Dependencies.di().sharedCoordinator.toSplash();
          },
        ),
      ],
    );
  }
}
