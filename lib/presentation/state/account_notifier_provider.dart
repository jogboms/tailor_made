import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tailor_made/domain.dart';

import 'account_provider.dart';
import 'registry_provider.dart';
import 'settings_provider.dart';

part 'account_notifier_provider.g.dart';

@Riverpod(dependencies: <Object>[registry, account, settings])
class AccountNotifier extends _$AccountNotifier {
  @override
  Future<AccountEntity> build() async => ref.watch(accountProvider.future);

  void updateStoreName(String name) async {
    final AccountEntity account = state.requireValue;
    await ref.read(registryProvider).get<Accounts>().updateAccount(
          account.uid,
          id: account.reference.id,
          path: account.reference.path,
          storeName: name,
        );
    ref.invalidate(accountProvider);
  }

  void readNotice() async {
    final AccountEntity account = state.requireValue;
    await ref.read(registryProvider).get<Accounts>().updateAccount(
          account.uid,
          id: account.reference.id,
          path: account.reference.path,
          hasReadNotice: true,
        );
    ref.invalidate(accountProvider);
  }

  void sendRating(int rating) async {
    final AccountEntity account = state.requireValue;
    await ref.read(registryProvider).get<Accounts>().updateAccount(
          account.uid,
          id: account.reference.id,
          path: account.reference.path,
          hasSendRating: true,
          rating: rating,
        );
    ref.invalidate(accountProvider);
  }

  void premiumSetup() async {
    final SettingEntity settings = await ref.watch(settingsProvider.future);
    await ref.read(registryProvider).get<Accounts>().signUp(
          state.requireValue.copyWith(
            status: AccountStatus.pending,
            notice: settings.premiumNotice,
            hasReadNotice: false,
            hasPremiumEnabled: true,
          ),
        );
    ref.invalidate(accountProvider);
  }
}
