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
  const SharedCoordinator(super.navigatorKey);

  void toHome(bool isMock) {
    navigator?.pushAndRemoveUntil<void>(MkNavigate.fadeIn(HomePage(isMock: isMock)), (Route<void> route) => false);
  }

  Future<String?>? toStoreNameDialog(AccountModel? account) {
    return navigator?.push<String>(MkNavigate.fadeIn(StoreNameDialog(account: account)));
  }

  void toSplash(bool isMock) {
    navigator?.pushAndRemoveUntil<void>(
      MkNavigate.fadeIn(SplashPage(isColdStart: false, isMock: isMock), name: MkRoutes.start),
      (Route<void> route) => false,
    );
  }
}
