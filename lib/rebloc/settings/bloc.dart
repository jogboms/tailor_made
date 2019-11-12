import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/common/actions.dart';
import 'package:tailor_made/rebloc/settings/actions.dart';
import 'package:tailor_made/services/session.dart';
import 'package:tailor_made/services/settings/settings.dart';

class SettingsBloc extends SimpleBloc<AppState> {
  @override
  Stream<WareContext<AppState>> applyMiddleware(Stream<WareContext<AppState>> input) {
    Observable(input)
        .where((WareContext<AppState> context) => context.action is InitSettingsAction)
        .switchMap((context) =>
            Settings.di().fetch().handleError(() => context.dispatcher(const OnErrorSettingsAction())).map((settings) {
              // Keep Static copy
              Session.di().setData(settings);
              return OnDataSettingAction(payload: settings);
            }).map((action) => context.copyWith(action)))
        .takeWhile((WareContext<AppState> context) => context.action is! OnDisposeAction)
        .listen((context) => context.dispatcher(context.action));

    return input;
  }

  @override
  AppState reducer(AppState state, Action action) {
    final _settings = state.settings;

    if (action is OnDataSettingAction) {
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
