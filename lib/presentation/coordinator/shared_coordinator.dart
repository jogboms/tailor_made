import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/utils/route_transitions.dart';

import '../constants/app_routes.dart';
import '../screens/homepage/homepage.dart';
import '../screens/homepage/widgets/store_name_dialog.dart';
import '../screens/splash/splash.dart';
import 'coordinator_base.dart';

@immutable
class SharedCoordinator extends CoordinatorBase {
  const SharedCoordinator(super.navigatorKey);

  void toHome(bool isMock) {
    navigator?.pushAndRemoveUntil<void>(
      RouteTransitions.fadeIn(HomePage(isMock: isMock)),
      (Route<void> route) => false,
    );
  }

  Future<String?>? toStoreNameDialog(AccountEntity account) {
    return navigator?.push<String>(RouteTransitions.fadeIn(StoreNameDialog(account: account)));
  }

  void toSplash(bool isMock) {
    navigator?.pushAndRemoveUntil<void>(
      RouteTransitions.fadeIn(SplashPage(isColdStart: false, isMock: isMock), name: AppRoutes.start),
      (Route<void> route) => false,
    );
  }
}
