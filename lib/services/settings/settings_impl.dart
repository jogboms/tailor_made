import 'package:tailor_made/firebase/cloud_db.dart';
import 'package:tailor_made/models/settings.dart';
import 'package:tailor_made/services/settings/settings.dart';

class SettingsImpl extends Settings {
  @override
  Stream<SettingsModel> fetch() {
    return CloudDb.settings.snapshots().map((snapshot) {
      if (snapshot.data == null) {
        throw FormatException("Internet Error");
      }
      return SettingsModel.fromJson(snapshot.data);
    });
  }
}
