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
    Observable(input)
        .where((_) => _.action is InitSettingsAction)
        .switchMap(
          (context) => CloudDb.settings
              .snapshots()
              .map((snapshot) {
                if (snapshot.data == null) {
                  throw FormatException("Internet Error");
                }
                return SettingsModel.fromJson(snapshot.data);
              })
              .handleError(
                () => context.dispatcher(const OnErrorSettingsAction()),
              )
              .map((settings) {
                // Keep Static copy
                Settings.setData(settings);
                return OnDataSettingAction(payload: settings);
              })
              .map((action) => context.copyWith(action)),
        )
        .takeWhile((_) => _.action is! OnDisposeAction)
        .listen(
          (context) => context.dispatcher(context.action),
        );

    return input;
  }

  @override
  AppState reducer(AppState state, Action action) {
    final _settings = state.settings;

    if (action is OnDataSettingAction) {
      return state.copyWith(
        settings: _settings.copyWith(
          settings: action.payload,
          status: SettingsStatus.success,
        ),
      );
    }

    if (action is OnErrorSettingsAction) {
      return state.copyWith(
        settings: _settings.copyWith(
          status: SettingsStatus.failure,
        ),
      );
    }

    return state;
  }
}
