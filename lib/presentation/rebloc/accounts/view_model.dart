import 'package:equatable/equatable.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

class AccountViewModel extends Equatable {
  AccountViewModel(AppState state)
      : model = state.account.account,
        isLoading = state.account.status == StateStatus.loading,
        hasError = state.account.status == StateStatus.failure,
        error = state.account.error;

  final AccountEntity? model;
  final bool isLoading;
  final bool hasError;
  final String? error;

  @override
  List<Object?> get props => <Object?>[model, isLoading, hasError, error];
}
