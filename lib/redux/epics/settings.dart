import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/models/settings.dart';
import 'package:tailor_made/redux/actions/settings.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/services/cloud_db.dart';
import 'package:tailor_made/services/settings.dart';

Stream<dynamic> settings(
  Stream<dynamic> actions,
  EpicStore<AppState> store,
) {
  return Observable<dynamic>(actions)
      .ofType(TypeToken<InitSettingsEvents>())
      .switchMap<dynamic>(
        (InitSettingsEvents action) => _getSettings()
            .map<dynamic>(
              (settings) {
                // Keep Static copy
                Settings.setData(settings);
                return OnDataSettingEvent(payload: settings);
              },
            )
            .onErrorReturn(OnErrorSettingsEvents())
            .takeUntil<dynamic>(
              actions
                  .where((dynamic action) => action is DisposeSettingsEvents),
            ),
      );
}

Observable<SettingsModel> _getSettings() {
  return Observable(CloudDb.settings.snapshots()).map(
    (DocumentSnapshot snapshot) {
      if (snapshot.data == null) {
        throw FormatException("Internet Error");
      }
      return SettingsModel.fromJson(snapshot.data);
    },
  );
}
