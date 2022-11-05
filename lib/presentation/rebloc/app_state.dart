import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tailor_made/presentation/rebloc.dart';

part 'app_state.freezed.dart';

@freezed
class AppState with _$AppState {
  const factory AppState({
    required ContactsState contacts,
    required JobsState jobs,
    required StatsState stats,
    required AccountState account,
    required MeasuresState measures,
    required SettingsState settings,
  }) = _AppState;

  static const AppState initialState = AppState(
    contacts: ContactsState(
      contacts: null,
      status: StateStatus.loading,
      hasSortFn: true,
      sortFn: ContactsSortType.names,
      searchResults: null,
      isSearching: false,
      error: null,
    ),
    jobs: JobsState(
      jobs: null,
      status: StateStatus.loading,
      hasSortFn: true,
      sortFn: JobsSortType.active,
      searchResults: null,
      isSearching: false,
      error: null,
    ),
    account: AccountState(
      account: null,
      error: null,
      status: StateStatus.loading,
      hasSkipedPremium: false,
    ),
    measures: MeasuresState(
      measures: null,
      grouped: null,
      status: StateStatus.loading,
      hasSkipedPremium: false,
      error: null,
    ),
    settings: SettingsState(
      settings: null,
      status: StateStatus.loading,
      error: null,
    ),
    stats: StatsState(
      stats: null,
      status: StateStatus.loading,
      error: null,
    ),
  );
}
