import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tailor_made/domain.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockValueChangedCallback<T> extends Mock {
  void call(T data);
}

class MockAsyncCallback<T> extends Mock {
  Future<T> call();
}

class MockAccounts extends Mock implements Accounts {}

class MockContacts extends Mock implements Contacts {}

class MockJobs extends Mock implements Jobs {}

class MockGallery extends Mock implements Gallery {}

class MockSettings extends Mock implements Settings {}

class MockPayments extends Mock implements Payments {}

class MockMeasures extends Mock implements Measures {}

class MockStats extends Mock implements Stats {}

class FakeAccountModel extends Fake implements AccountModel {}

class FakeRoute extends Fake implements Route<dynamic> {}
