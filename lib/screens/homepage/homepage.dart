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
import 'package:tailor_made/utils/ui/mk_choice_dialog.dart';
import 'package:tailor_made/utils/ui/mk_status_bar.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:version/version.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key, @required this.version})
      : assert(version != null),
        super(key: key);

  final String version;

  @override
  Widget build(BuildContext context) {
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
              Builder(
                builder: (context) {
                  final currentVersion = Version.parse(version);
                  final state = StoreProvider.of<AppState>(context).states.value;
                  final latestVersion = Version.parse(state?.settings?.settings?.versionName ?? "1.0.0");

                  if (latestVersion > currentVersion) {
                    return OutDatedPage(onUpdate: () {
                      // TODO: take note for apple if that ever happens
                      open('https://play.google.com/store/apps/details?id=io.github.jogboms.tailormade');
                    });
                  }

                  return ViewModelSubscriber<AppState, HomeViewModel>(
                    converter: (store) => HomeViewModel(store),
                    builder: (_, dispatch, vm) => _Body(viewModel: vm, dispatch: dispatch, version: version),
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

class _Body extends StatelessWidget {
  const _Body({Key key, @required this.dispatch, @required this.viewModel, @required this.version})
      : assert(version != null),
        super(key: key);

  final HomeViewModel viewModel;
  final DispatchFunction dispatch;
  final String version;

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
            Expanded(flex: 2, child: MidRowWidget(userId: viewModel.account.uid, stats: viewModel.stats)),
            Expanded(flex: 2, child: BottomRowWidget(stats: viewModel.stats, account: viewModel.account)),
            SizedBox(height: kButtonHeight + MediaQuery.of(context).padding.bottom),
          ],
        ),
        CreateButton(userId: viewModel.account.uid, contacts: viewModel.contacts),
        TopButtonBar(
          account: viewModel.account,
          shouldSendRating: viewModel.shouldSendRating,
          onLogout: () async {
            dispatch(const OnLogoutAction());
            Dependencies.di().sharedCoordinator.toSplash(version);
          },
        ),
      ],
    );
  }
}
