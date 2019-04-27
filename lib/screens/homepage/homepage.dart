import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/constants/mk_images.dart';
import 'package:tailor_made/constants/mk_routes.dart';
import 'package:tailor_made/constants/mk_strings.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/rebloc/actions/account.dart';
import 'package:tailor_made/rebloc/actions/common.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/rebloc/view_models/home_view_model.dart';
import 'package:tailor_made/screens/homepage/_partials/bottom_row.dart';
import 'package:tailor_made/screens/homepage/_partials/create_button.dart';
import 'package:tailor_made/screens/homepage/_partials/header.dart';
import 'package:tailor_made/screens/homepage/_partials/mid_row.dart';
import 'package:tailor_made/screens/homepage/_partials/stats.dart';
import 'package:tailor_made/screens/homepage/_partials/top_button_bar.dart';
import 'package:tailor_made/screens/homepage/_partials/top_row.dart';
import 'package:tailor_made/screens/splash/splash.dart';
import 'package:tailor_made/services/accounts.dart';
import 'package:tailor_made/utils/mk_choice_dialog.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/utils/mk_phone.dart';
import 'package:tailor_made/utils/mk_status_bar.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/_views/access_denied.dart';
import 'package:tailor_made/widgets/_views/out_dated.dart';
import 'package:tailor_made/widgets/_views/rate_limit.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => mkChoiceDialog(
            context: context,
            message: "Continue with Exit?",
          ),
      child: MkStatusBar(
        brightness: Brightness.dark,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              const Opacity(
                opacity: .5,
                child: const DecoratedBox(
                  decoration: const BoxDecoration(
                    image: const DecorationImage(
                      image: MkImages.pattern,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              ViewModelSubscriber<AppState, HomeViewModel>(
                converter: (store) => HomeViewModel(store),
                builder: (
                  BuildContext context,
                  DispatchFunction dispatcher,
                  HomeViewModel vm,
                ) {
                  if (vm.isLoading) {
                    return const MkLoadingSpinner();
                  }

                  if (vm.isOutdated) {
                    return OutDatedPage(
                      onUpdate: () {
                        open(
                          'https://play.google.com/store/apps/details?id=io.github.jogboms.tailormade',
                        );
                      },
                    );
                  }

                  if (vm.isDisabled) {
                    return AccessDeniedPage(
                      onSendMail: () {
                        email(
                          "jeremiahogbomo@gmail.com",
                          '${MkStrings.appName} - Unwarranted%20Account%20Suspension%20%23${vm.account.uid}',
                        );
                      },
                    );
                  }

                  if (vm.isWarning && vm.hasSkipedPremium == false) {
                    return RateLimitPage(
                      onSignUp: () {
                        dispatcher(OnPremiumSignUp(payload: vm.account));
                      },
                      onSkipedPremium: () {
                        dispatcher(const OnSkipedPremium());
                      },
                    );
                  }

                  return _Body(vm: vm);
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
  const _Body({
    Key key,
    @required this.vm,
  }) : super(key: key);

  final HomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 12,
              child: HeaderWidget(account: vm.account),
            ),
            StatsWidget(stats: vm.stats),
            Expanded(flex: 2, child: TopRowWidget(stats: vm.stats)),
            Expanded(flex: 2, child: MidRowWidget(stats: vm.stats)),
            Expanded(
              flex: 2,
              child: BottomRowWidget(
                stats: vm.stats,
                account: vm.account,
              ),
            ),
            SizedBox(
              height: kButtonHeight + MediaQuery.of(context).padding.bottom,
            ),
          ],
        ),
        CreateButton(contacts: vm.contacts),
        TopButtonBar(
          account: vm.account,
          shouldSendRating: vm.shouldSendRating,
          onLogout: () async {
            await Accounts.di().signout();
            StoreProvider.of<AppState>(context).dispatcher(
              const OnLogoutAction(),
            );
            await Navigator.pushAndRemoveUntil<void>(
              context,
              MkNavigate.fadeIn<void>(
                const SplashPage(isColdStart: false),
                name: MkRoutes.start,
              ),
              (Route<void> route) => false,
            );
          },
        ),
      ],
    );
  }
}
