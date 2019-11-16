import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/repository/main.dart';
import 'package:tailor_made/services/session.dart';
import 'package:tailor_made/utils/mk_first_time_login_check.dart';
import 'package:tailor_made/widgets/dependencies.dart';

Future<BootstrapModel> bootstrap(Repository repository, Environment env, [bool isTestMode = false]) async {
  final _session = Session(environment: env, isTestMode: isTestMode);
  final _navigatorKey = GlobalKey<NavigatorState>();

  Dependencies(_session, _navigatorKey, repository);

  if (_session.isMock) {
    return BootstrapModel(navigatorKey: _navigatorKey, isFirstTime: true, isTestMode: isTestMode);
  }

  final isFirstTime = await MkFirstTimeLoginCheck.check(_session.environment);
  return BootstrapModel(navigatorKey: _navigatorKey, isFirstTime: isFirstTime, isTestMode: isTestMode);
}

class BootstrapModel {
  const BootstrapModel({@required this.navigatorKey, @required this.isFirstTime, this.isTestMode = false});

  final GlobalKey<NavigatorState> navigatorKey;
  final bool isFirstTime;
  final bool isTestMode;
}
