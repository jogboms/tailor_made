import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/constants/mk_images.dart';
import 'package:tailor_made/rebloc/actions/account.dart';
import 'package:tailor_made/rebloc/actions/common.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/services/auth.dart';
import 'package:tailor_made/utils/mk_choice_dialog.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/utils/mk_phone.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/_views/access_denied.dart';
import 'package:tailor_made/widgets/_views/out_dated.dart';
import 'package:tailor_made/widgets/_views/rate_limit.dart';
import 'package:tailor_made/widgets/screens/homepage/home_view_model.dart';
import 'package:tailor_made/widgets/screens/homepage/ui/bottom_row.dart';
import 'package:tailor_made/widgets/screens/homepage/ui/create_button.dart';
import 'package:tailor_made/widgets/screens/homepage/ui/header.dart';
import 'package:tailor_made/widgets/screens/homepage/ui/mid_row.dart';
import 'package:tailor_made/widgets/screens/homepage/ui/stats.dart';
import 'package:tailor_made/widgets/screens/homepage/ui/top_button_bar.dart';
import 'package:tailor_made/widgets/screens/homepage/ui/top_row.dart';
import 'package:tailor_made/widgets/screens/splash/splash.dart';

const double _kBottomBarHeight = 46.0;
const double _kBottomGridsHeight = 280.0;
const double _kStatGridsHeight = 40.0;
const double _kRowGridsHeight = (_kBottomGridsHeight - _kStatGridsHeight) / 3;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // did this to avoid passing a reference of HomePage context to TopButtonBar
    // without this, i can not replace this route with SplashPage on logout
    final _context = context;

    return WillPopScope(
      onWillPop: () async {
        return await mkChoiceDialog(
          context: _context,
          title: "",
          message: "Continue with Exit?",
        );
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Opacity(
              opacity: .5,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
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
                  return Center(
                    child: const MkLoadingSpinner(),
                  );
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
                        'Unwarranted%20Account%20Suspension%20%23${vm.account.uid}',
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

                return _buildBody(_context, vm);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext _context, HomeViewModel vm) {
    return LayoutBuilder(
      builder: (context, constraint) {
        final bool isLandscape = constraint.maxWidth > constraint.maxHeight;

        // Somehow, i mathematically came up w/ these numbers & they made sense :)
        final _height = constraint.maxHeight -
            (isLandscape
                ? _kBottomBarHeight
                : _kBottomGridsHeight + (_kBottomBarHeight * 1.45));

        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints.expand(height: _height),
                      child: HeaderWidget(account: vm.account),
                    ),
                    StatsWidget(stats: vm.stats, height: _kStatGridsHeight),
                    TopRowWidget(stats: vm.stats, height: _kRowGridsHeight),
                    MidRowWidget(stats: vm.stats, height: _kRowGridsHeight),
                    BottomRowWidget(
                      stats: vm.stats,
                      account: vm.account,
                      height: _kRowGridsHeight,
                    ),
                    SizedBox(height: _kBottomBarHeight),
                  ],
                ),
              ),
            ),
            CreateButton(contacts: vm.contacts, height: _kBottomBarHeight),
            TopButtonBar(
              vm: vm,
              // did this to avoid passing a reference of HomePage context to TopButtonBar
              // without this, i can not replace this route with SplashPage on logout
              onLogout: _onLogout(_context, vm),
            ),
          ],
        );
      },
    );
  }

  VoidCallback _onLogout(BuildContext context, HomeViewModel vm) {
    return () async {
      StoreProvider.of<AppState>(context).dispatcher(
        const OnLogoutEvent(),
      );
      await Auth.signOutWithGoogle();
      Navigator.pushReplacement<dynamic, dynamic>(
        context,
        MkNavigate.fadeIn<String>(
          SplashPage(isColdStart: false),
        ),
      );
    };
  }
}
