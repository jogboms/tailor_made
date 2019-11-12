import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/rebloc/app_state.dart';

part 'state.g.dart';

abstract class AccountState implements Built<AccountState, AccountStateBuilder> {
  factory AccountState([AccountState updates(AccountStateBuilder b)]) = _$AccountState;

  factory AccountState.initialState() => _$AccountState(
        (AccountStateBuilder b) => b
          ..account = null
          ..status = StateStatus.loading
          ..hasSkipedPremium = false
          ..message = ""
          ..error = null,
      );

  AccountState._();

  @nullable
  AccountModel get account;

  StateStatus get status;

  bool get hasSkipedPremium;

  String get message;

  @nullable
  String get error;

  static Serializer<AccountState> get serializer => _$accountStateSerializer;
}
