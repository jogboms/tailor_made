import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tailor_made/pages/homepage/home_view_model.dart';
import 'package:tailor_made/pages/homepage/ui/bottom_row.dart';
import 'package:tailor_made/pages/homepage/ui/create_button.dart';
import 'package:tailor_made/pages/homepage/ui/header.dart';
import 'package:tailor_made/pages/homepage/ui/stats.dart';
import 'package:tailor_made/pages/homepage/ui/top_button_bar.dart';
import 'package:tailor_made/pages/homepage/ui/top_row.dart';
import 'package:tailor_made/pages/templates/access_denied.dart';
import 'package:tailor_made/pages/templates/rate_limit.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_images.dart';
import 'package:tailor_made/utils/tm_phone.dart';
import 'package:tailor_made/utils/tm_theme.dart';

const double _kBottomBarHeight = 46.0;
const double _kBottomGridsHeight = 280.0;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    return new Scaffold(
      backgroundColor: theme.scaffoldColor,
      resizeToAvoidBottomPadding: false,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Opacity(
            opacity: .5,
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: TMImages.pattern,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          new StoreConnector<ReduxState, HomeViewModel>(
            converter: (store) => HomeViewModel(store),
            onInit: (store) => store.dispatch(new InitDataEvents()),
            onDispose: (store) => store.dispatch(new DisposeDataEvents()),
            builder: (context, vm) {
              if (vm.isLoading) {
                return Center(
                  child: loadingSpinner(),
                );
              }

              if (vm.isDisabled) {
                return AccessDeniedPage(
                  onSendMail: () {
                    email(
                        'Unwarranted%20Account%20Suspension%20%23${vm.account.uid}');
                  },
                );
              }

              if (vm.isWarning && vm.hasSkipedPremium == false) {
                return RateLimitPage(
                  onSignUp: () {
                    vm.onPremiumSignUp();
                  },
                  onSkipedPremium: () {
                    vm.onSkipedPremium();
                  },
                );
              }

              return _buildBody(vm);
            },
          ),
        ],
      ),
    );
  }

  LayoutBuilder _buildBody(HomeViewModel vm) {
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
            new SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints.expand(height: _height),
                      child: HeaderWidget(account: vm.account),
                    ),
                    StatsWidget(stats: vm.stats, height: 40.0),
                    TopRowWidget(stats: vm.stats, height: 120.0),
                    BottomRowWidget(stats: vm.stats, height: 120.0),
                    SizedBox(height: _kBottomBarHeight),
                  ],
                ),
              ),
            ),
            CreateButton(contacts: vm.contacts, height: _kBottomBarHeight),
            TopButtonBar(vm: vm),
          ],
        );
      },
    );
  }
}
