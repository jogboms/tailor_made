import 'dart:async' as async;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registry/registry.dart';
import 'package:universal_io/io.dart' as io;

import 'core.dart';
import 'data.dart';
import 'domain.dart';
import 'firebase_options.dev.dart' as dev;
import 'firebase_options.prod.dart' as prod;
import 'presentation.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: const Color(0x00000000),
    ),
  );
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);

  final _Repository repository;
  final ReporterClient reporterClient;
  final NavigatorObserver navigationObserver;
  switch (environment) {
    case Environment.dev:
    case Environment.prod:
      final bool isDev = environment.isDev;
      final Firebase firebase = await Firebase.initialize(
        options: isDev ? dev.DefaultFirebaseOptions.currentPlatform : prod.DefaultFirebaseOptions.currentPlatform,
        isAnalyticsEnabled: environment.isProduction,
      );
      reporterClient = _ReporterClient(firebase.crashlytics);
      repository = _Repository.firebase(firebase, isDev);
      navigationObserver = firebase.analytics.navigatorObserver;
      break;
    case Environment.testing:
    case Environment.mock:
      reporterClient = const _NoopReporterClient();
      repository = _Repository.mock();
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

  final Registry registry = Registry()
    ..set<Environment>(environment)
    ..set<Accounts>(repository.accounts)
    ..set<Contacts>(repository.contacts)
    ..set<Jobs>(repository.jobs)
    ..set<Gallery>(repository.gallery)
    ..set<ImageStorage>(repository.imageStorage)
    ..set<Settings>(repository.settings)
    ..set<Payments>(repository.payments)
    ..set<Measures>(repository.measures)
    ..set<Stats>(repository.stats)
    ..factory((RegistryFactory di) => FetchAccountUseCase(accounts: di()))
    ..factory((RegistryFactory di) => SignInUseCase(accounts: di()))
    ..factory((RegistryFactory di) => SignOutUseCase(accounts: di()));

  runApp(
    ProviderScope(
      overrides: <Override>[
        registryProvider.overrideWithValue(registry),
      ],
      child: ErrorBoundary(
        isReleaseMode: !environment.isDebugging,
        errorViewBuilder: (_) => const AppCrashErrorView(),
        onException: AppLog.e,
        onCrash: errorReporter.reportCrash,
        child: App(
          registry: registry,
          navigatorObservers: <NavigatorObserver>[navigationObserver],
        ),
      ),
    ),
  );
}

class _Repository {
  _Repository.firebase(Firebase firebase, bool isDev)
      : accounts = AccountsImpl(firebase: firebase, isDev: isDev),
        contacts = ContactsImpl(firebase: firebase, isDev: isDev),
        jobs = JobsImpl(firebase: firebase, isDev: isDev),
        gallery = GalleryImpl(firebase: firebase, isDev: isDev),
        imageStorage = ImageStorageImpl(firebase: firebase, isDev: isDev),
        settings = SettingsImpl(firebase: firebase, isDev: isDev),
        payments = PaymentsImpl(firebase: firebase, isDev: isDev),
        measures = MeasuresImpl(firebase: firebase, isDev: isDev),
        stats = StatsImpl(firebase: firebase, isDev: isDev);

  _Repository.mock()
      : accounts = AccountsMockImpl(),
        contacts = ContactsMockImpl(),
        jobs = JobsMockImpl(),
        gallery = GalleryMockImpl(),
        imageStorage = ImageStorageMockImpl(),
        settings = SettingsMockImpl(),
        payments = PaymentsMockImpl(),
        measures = MeasuresMockImpl(),
        stats = StatsMockImpl();

  final Accounts accounts;
  final Contacts contacts;
  final Jobs jobs;
  final Gallery gallery;
  final ImageStorage imageStorage;
  final Settings settings;
  final Payments payments;
  final Measures measures;
  final Stats stats;
}

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
