import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/models/settings.dart';
import 'package:tailor_made/rebloc/actions/common.dart';
import 'package:tailor_made/rebloc/actions/settings.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/rebloc/states/settings.dart';
import 'package:tailor_made/services/cloud_db.dart';
import 'package:tailor_made/services/settings.dart';

class SettingsBloc extends SimpleBloc<AppState> {
  @override
  Stream<WareContext<AppState>> applyMiddleware(
    Stream<WareContext<AppState>> input,
  ) {
    return Observable(input).map(
      (context) {
        if (context.action is OnInitAction ||
            context.action is InitSettingsEvents) {
          CloudDb.settings
              .snapshots()
              .map(
                (snapshot) {
                  if (snapshot.data == null) {
                    throw FormatException("Internet Error");
                  }
                  return SettingsModel.fromJson(snapshot.data);
                },
              )
              .takeWhile((action) => action is! OnDisposeAction)
              .listen(
                (settings) {
                  // Keep Static copy
                  Settings.setData(settings);
                  context.dispatcher(OnDataSettingAction(payload: settings));
                },
                onError: () {
                  context.dispatcher(const OnErrorSettingsEvents());
                },
              );
        }
        return context;
      },
    );
  }

  @override
  AppState reducer(AppState state, Action action) {
    final _settings = state.settings;

    if (action is OnInitAction || action is InitSettingsEvents) {
      return state.copyWith(
        settings: _settings.copyWith(
          status: SettingsStatus.loading,
        ),
      );
    }

    if (action is OnDataSettingAction) {
      return state.copyWith(
        settings: _settings.copyWith(
          settings: action.payload,
          status: SettingsStatus.success,
        ),
      );
    }

    if (action is OnErrorSettingsEvents) {
      return state.copyWith(
        settings: _settings.copyWith(
          status: SettingsStatus.failure,
        ),
      );
    }

    return state;
  }
}
