import 'package:tailor_made/models/settings.dart';
import 'package:tailor_made/firebase/cloud_db.dart';

class Config {
  static Stream<SettingsModel> fetch() {
    return CloudDb.settings.snapshots().map((snapshot) {
      if (snapshot.data == null) {
        throw FormatException("Internet Error");
      }
      return SettingsModel.fromJson(snapshot.data);
    });
  }
}
