import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/common/actions.dart';
import 'package:tailor_made/rebloc/settings/actions.dart';
import 'package:tailor_made/services/settings/settings.dart';
import 'package:tailor_made/utils/mk_settings.dart';

class SettingsBloc extends SimpleBloc<AppState> {
  @override
  Stream<WareContext<AppState>> applyMiddleware(Stream<WareContext<AppState>> input) {
    Observable(input)
        .where((WareContext<AppState> context) => context.action is InitSettingsAction)
        .switchMap((context) =>
            Settings.di().fetch().handleError(() => context.dispatcher(const OnErrorSettingsAction())).map((settings) {
              // Keep Static copy
              MkSettings.setData(settings);
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
      return state.copyWith(
        settings: _settings.copyWith(settings: action.payload, status: StateStatus.success),
      );
    }

    if (action is OnErrorSettingsAction) {
      return state.copyWith(
        settings: _settings.copyWith(status: StateStatus.failure),
      );
    }

    return state;
  }
}
