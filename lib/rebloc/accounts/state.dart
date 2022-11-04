import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/rebloc/app_state.dart';

part 'state.g.dart';

abstract class AccountState implements Built<AccountState, AccountStateBuilder> {
  factory AccountState([void Function(AccountStateBuilder b) updates]) = _$AccountState;

  factory AccountState.initialState() => _$AccountState(
        (AccountStateBuilder b) => b
          ..account = null
          ..status = StateStatus.loading
          ..hasSkipedPremium = false
          ..error = null,
      );

  AccountState._();

  AccountModel? get account;

  StateStatus get status;

  bool get hasSkipedPremium;

  String? get error;

  static Serializer<AccountState> get serializer => _$accountStateSerializer;
}
