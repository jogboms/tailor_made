import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/screens/homepage/homepage.dart';
import 'package:tailor_made/presentation/screens/splash/splash.dart';

import '../mocks.dart';
import '../utils.dart';

void main() {
  group('App', () {
    const AccountEntity dummyAccount = AccountEntity(
      reference: ReferenceEntity(id: 'id', path: 'path'),
      uid: '1',
      notice: 'Hello',
      phoneNumber: 123456789,
      email: 'jeremiah@gmail.com',
      displayName: 'Jogboms',
      status: AccountStatus.enabled,
      rating: 5,
      hasPremiumEnabled: true,
      hasReadNotice: false,
      hasSendRating: true,
      photoURL: 'https://secure.gravatar.com/avatar/96b338e14ff9d18b1b2d6e5dc279a710',
      storeName: 'Jogboms',
    );

    setUpAll(() {
      registerFallbackValue(FakeRoute());
    });

    testWidgets('shows SplashPage and navigates HomePage', (WidgetTester tester) async {
      final NavigatorObserver mockObserver = MockNavigatorObserver();

      when(mockRepositories.accounts.signIn).thenAnswer((_) async {});
      when(() => mockRepositories.accounts.onAuthStateChanged).thenAnswer((_) => Stream<String?>.value('1'));
      when(mockRepositories.accounts.fetch).thenAnswer((_) async => dummyAccount);

      await tester.pumpWidget(
        createApp(
          registry: createRegistry(),
          observers: <NavigatorObserver>[mockObserver],
          includeMaterial: false,
        ),
      );
      await tester.pump();

      expect(find.byType(SplashPage), findsOneWidget);

      await tester.pump();

      await tester.verifyPushNavigation<HomePage>(mockObserver);
    });
  });
}
