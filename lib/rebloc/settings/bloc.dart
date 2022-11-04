import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/models/settings.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/common/actions.dart';
import 'package:tailor_made/rebloc/extensions.dart';
import 'package:tailor_made/rebloc/settings/actions.dart';
import 'package:tailor_made/rebloc/settings/state.dart';
import 'package:tailor_made/services/settings/main.dart';

class SettingsBloc extends SimpleBloc<AppState> {
  SettingsBloc(this.settings);

  final Settings settings;

  @override
  Stream<WareContext<AppState>> applyMiddleware(Stream<WareContext<AppState>> input) {
    input
        .whereAction<InitSettingsAction>()
        .switchMap(
          (WareContext<AppState> context) => settings
              .fetch()
              .handleError((dynamic _) => context.dispatcher(const OnErrorSettingsAction()))
              .map(OnDataAction<SettingsModel?>.new)
              .map((OnDataAction<SettingsModel?> action) => context.copyWith(action)),
        )
        .untilAction<OnDisposeAction>()
        .listen((WareContext<AppState> context) => context.dispatcher(context.action));

    return input;
  }

  @override
  AppState reducer(AppState state, Action action) {
    final SettingsState settings = state.settings;

    if (action is OnDataAction<SettingsModel>) {
      return state.rebuild(
        (AppStateBuilder b) => b
          ..settings = settings
              .rebuild(
                (SettingsStateBuilder b) => b
                  ..settings = action.payload.toBuilder()
                  ..status = StateStatus.success,
              )
              .toBuilder(),
      );
    }

    if (action is OnErrorSettingsAction) {
      return state.rebuild(
        (AppStateBuilder b) =>
            b..settings = settings.rebuild((SettingsStateBuilder b) => b..status = StateStatus.failure).toBuilder(),
      );
    }

    return state;
  }
}
