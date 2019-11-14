import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
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

  static SharedCoordinator di() => Injector.appInstance.getDependency<SharedCoordinator>();

  void toHome() {
    navigator?.pushAndRemoveUntil<void>(MkNavigate.fadeIn(const HomePage()), (Route<void> route) => false);
  }

  Future<String> toStoreNameDialog(AccountModel account) {
    return navigator?.push<String>(MkNavigate.fadeIn(StoreNameDialog(account: account)));
  }

  void toSplash() {
    navigator?.pushAndRemoveUntil<void>(
      MkNavigate.fadeIn<void>(const SplashPage(isColdStart: false), name: MkRoutes.start),
      (Route<void> route) => false,
    );
  }
}
