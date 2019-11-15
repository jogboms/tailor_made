import 'package:tailor_made/models/settings.dart';
import 'package:tailor_made/repository/firebase/main.dart';
import 'package:tailor_made/services/settings/settings.dart';
import 'package:tailor_made/wrappers/mk_exceptions.dart';

class SettingsImpl extends Settings<FirebaseRepository> {
  @override
  Stream<SettingsModel> fetch() {
    return repository.db.settings.snapshots().map((snapshot) {
      if (snapshot.data == null) {
        throw NoInternetException();
      }
      return SettingsModel.fromJson(snapshot.data);
    });
  }
}
