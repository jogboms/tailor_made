import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/models/settings.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/common/actions.dart';
import 'package:tailor_made/rebloc/extensions.dart';
import 'package:tailor_made/rebloc/settings/actions.dart';

class SettingsBloc extends SimpleBloc<AppState> {
  @override
  Stream<WareContext<AppState>> applyMiddleware(Stream<WareContext<AppState>> input) {
    Observable(input)
        .whereAction<InitSettingsAction>()
        .switchMap(
          (context) => Dependencies.di()
              .settings
              .fetch()
              .handleError(() => context.dispatcher(const OnErrorSettingsAction()))
              .map((settings) => OnDataAction<SettingsModel>(settings))
              .map((action) => context.copyWith(action)),
        )
        .untilAction<OnDisposeAction>()
        .listen((context) => context.dispatcher(context.action));

    return input;
  }

  @override
  AppState reducer(AppState state, Action action) {
    final _settings = state.settings;

    if (action is OnDataAction<SettingsModel>) {
      return state.rebuild(
        (b) => b
          ..settings = _settings
              .rebuild((b) => b
                ..settings = action.payload.toBuilder()
                ..status = StateStatus.success)
              .toBuilder(),
      );
    }

    if (action is OnErrorSettingsAction) {
      return state.rebuild(
        (b) => b..settings = _settings.rebuild((b) => b..status = StateStatus.failure).toBuilder(),
      );
    }

    return state;
  }
}
