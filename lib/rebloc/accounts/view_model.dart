import 'package:equatable/equatable.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/rebloc/app_state.dart';

class AccountViewModel extends Equatable {
  AccountViewModel(AppState state)
      : model = state.account.account,
        isLoading = state.account.status == StateStatus.loading,
        hasError = state.account.status == StateStatus.failure,
        error = state.account.error;

  final AccountModel? model;
  final bool isLoading;
  final bool hasError;
  final dynamic error;

  @override
  List<Object?> get props => <Object?>[model, isLoading, hasError, error];
}
