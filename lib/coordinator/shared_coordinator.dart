import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_routes.dart';
import 'package:tailor_made/coordinator/coordinator_base.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/screens/homepage/_partials/store_name_dialog.dart';
import 'package:tailor_made/screens/homepage/homepage.dart';
import 'package:tailor_made/screens/splash/splash.dart';
import 'package:tailor_made/wrappers/mk_navigate.dart';

@immutable
class SharedCoordinator extends CoordinatorBase {
  const SharedCoordinator(GlobalKey<NavigatorState> navigatorKey) : super(navigatorKey);

  void toHome(String version) {
    navigator?.pushAndRemoveUntil<void>(MkNavigate.fadeIn(HomePage(version: version)), (Route<void> route) => false);
  }

  Future<String> toStoreNameDialog(AccountModel account) {
    return navigator?.push<String>(MkNavigate.fadeIn(StoreNameDialog(account: account)));
  }

  void toSplash(String version) {
    navigator?.pushAndRemoveUntil<void>(
      MkNavigate.fadeIn<void>(SplashPage(isColdStart: false, version: version), name: MkRoutes.start),
      (Route<void> route) => false,
    );
  }
}
