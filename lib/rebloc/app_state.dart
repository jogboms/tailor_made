import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tailor_made/rebloc/accounts/state.dart';
import 'package:tailor_made/rebloc/contacts/state.dart';
import 'package:tailor_made/rebloc/jobs/state.dart';
import 'package:tailor_made/rebloc/measures/state.dart';
import 'package:tailor_made/rebloc/settings/state.dart';
import 'package:tailor_made/rebloc/stats/state.dart';

part 'app_state.g.dart';

abstract class AppState implements Built<AppState, AppStateBuilder> {
  factory AppState([void updates(AppStateBuilder b)]) = _$AppState;

  factory AppState.initialState() => _$AppState(
        (AppStateBuilder b) => b
          ..contacts = ContactsState.initialState().toBuilder()
          ..jobs = JobsState.initialState().toBuilder()
          ..account = AccountState.initialState().toBuilder()
          ..measures = MeasuresState.initialState().toBuilder()
          ..settings = SettingsState.initialState().toBuilder()
          ..stats = StatsState.initialState().toBuilder(),
      );

  AppState._();

  ContactsState get contacts;

  JobsState get jobs;

  StatsState get stats;

  AccountState get account;

  MeasuresState get measures;

  SettingsState get settings;

  static Serializer<AppState> get serializer => _$appStateSerializer;
}

class StateStatus extends EnumClass {
  const StateStatus._(String name) : super(name);

  static const StateStatus loading = _$loading;
  static const StateStatus success = _$success;
  static const StateStatus failure = _$failure;

  static Serializer<StateStatus> get serializer => _$stateStatusSerializer;

  static BuiltSet<StateStatus> get values => _$values;

  static StateStatus valueOf(String name) => _$valueOf(name);
}
