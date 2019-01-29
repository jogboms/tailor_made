import 'package:equatable/equatable.dart';
import 'package:tailor_made/rebloc/states/account.dart';
import 'package:tailor_made/rebloc/states/main.dart';

class AccountViewModel extends Equatable {
  AccountViewModel(AppState state)
      : model = state.account.account,
        isLoading = state.account.status == AccountStatus.loading,
        hasError = state.account.status == AccountStatus.failure,
        error = state.account.error,
        super(<AppState>[state]);

  final dynamic model;
  final bool isLoading;
  final bool hasError;
  final dynamic error;
}
