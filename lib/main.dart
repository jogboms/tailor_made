import 'dart:async' as async;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:universal_io/io.dart' as io;

import 'bootstrap.dart';
import 'core.dart';
import 'data.dart';
import 'dependencies.dart';
import 'domain.dart';
import 'presentation.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: const Color(0x00000000),
    ),
  );
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);

  const Dependencies dependencies = Dependencies();

  final ReporterClient reporterClient;
  final NavigatorObserver navigationObserver;
  final Repository repository;
  switch (environment) {
    case Environment.dev:
    case Environment.prod:
      final Firebase firebase = await Firebase.initialize(
        options: null,
        isAnalyticsEnabled: environment.isProduction,
      );
      repository = FirebaseRepository(
        db: firebase.db,
        auth: firebase.auth,
        storage: firebase.storage,
      );
      reporterClient = _ReporterClient(firebase.crashlytics);
      navigationObserver = firebase.analytics.navigatorObserver;
      break;
    case Environment.testing:
    case Environment.mock:
      reporterClient = const _NoopReporterClient();
      repository = _MockRepository();
      navigationObserver = NavigatorObserver();
      break;
  }

  final ErrorReporter errorReporter = ErrorReporter(client: reporterClient);
  AppLog.init(
    logFilter: () => kDebugMode && !environment.isTesting,
    exceptionFilter: (Object error) {
      const List<Type> ignoreTypes = <Type>[
        io.SocketException,
        io.HandshakeException,
        async.TimeoutException,
      ];
      return !kDebugMode && !ignoreTypes.contains(error.runtimeType);
    },
    onException: errorReporter.report,
    onLog: (Object? message) => debugPrint(message?.toString()),
  );

  runApp(
    ErrorBoundary(
      isReleaseMode: !environment.isDebugging,
      errorViewBuilder: (_) => const AppCrashErrorView(),
      onException: AppLog.e,
      onCrash: errorReporter.reportCrash,
      child: App(
        bootstrap: await bootstrap(dependencies, repository, environment),
        store: storeFactory(dependencies, false),
        navigatorObservers: <NavigatorObserver>[navigationObserver],
      ),
    ),
  );
}

class _MockRepository extends Repository {}

class _ReporterClient implements ReporterClient {
  const _ReporterClient(this.client);

  final Crashlytics client;

  @override
  async.FutureOr<void> report({required StackTrace stackTrace, required Object error, Object? extra}) async =>
      client.report(error, stackTrace);

  @override
  async.FutureOr<void> reportCrash(FlutterErrorDetails details) async => client.reportCrash(details);

  @override
  void log(Object object) => AppLog.i(object);
}

class _NoopReporterClient implements ReporterClient {
  const _NoopReporterClient();

  @override
  async.FutureOr<void> report({required StackTrace stackTrace, required Object error, Object? extra}) {}

  @override
  async.FutureOr<void> reportCrash(FlutterErrorDetails details) {}

  @override
  void log(Object object) {}
}
