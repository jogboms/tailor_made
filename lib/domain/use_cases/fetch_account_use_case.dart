import '../entities/account_entity.dart';
import '../repositories/accounts.dart';

class FetchAccountUseCase {
  const FetchAccountUseCase({required Accounts accounts}) : _accounts = accounts;

  final Accounts _accounts;

  Future<AccountEntity> call() => _accounts.fetch();
}
