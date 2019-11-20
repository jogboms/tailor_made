import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/repository/main.dart';
import 'package:tailor_made/services/session.dart';
import 'package:tailor_made/utils/mk_first_time_login_check.dart';

Future<BootstrapModel> bootstrap(Dependencies dependencies, Repository repository, Environment env) async {
  final _session = Session(environment: env);
  final _navigatorKey = GlobalKey<NavigatorState>();

  dependencies.initialize(_session, _navigatorKey, repository);

  if (_session.isMock) {
    return BootstrapModel(navigatorKey: _navigatorKey, isFirstTime: true, isMock: true);
  }

  final isFirstTime = await MkFirstTimeLoginCheck.check(env);
  return BootstrapModel(navigatorKey: _navigatorKey, isFirstTime: isFirstTime, isMock: false);
}

class BootstrapModel {
  const BootstrapModel({@required this.navigatorKey, @required this.isFirstTime, @required this.isMock});

  final GlobalKey<NavigatorState> navigatorKey;
  final bool isFirstTime;
  final bool isMock;
}
