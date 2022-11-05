import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

part 'state.freezed.dart';

@freezed
class AccountState with _$AccountState {
  const factory AccountState({
    required AccountModel? account,
    required StateStatus status,
    required bool hasSkipedPremium,
    required String? error,
  }) = _AccountState;
}
