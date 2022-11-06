import 'package:firebase_analytics/firebase_analytics.dart';

import 'models.dart';

class CloudAnalytics {
  CloudAnalytics(this._analytics) : navigatorObserver = FirebaseAnalyticsObserver(analytics: _analytics);

  final FirebaseAnalytics _analytics;
  final FirebaseAnalyticsObserver navigatorObserver;

  Future<void> log(String name, [DynamicMap? parameters]) async =>
      _analytics.logEvent(name: name, parameters: parameters);

  Future<void> setCurrentScreen(String name) async => _analytics.setCurrentScreen(screenName: name);

  Future<void> setUserId(String id) async => _analytics.setUserId(id: id);

  Future<void> removeUserId() async => _analytics.setUserId();
}
