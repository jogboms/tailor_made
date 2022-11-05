import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';

import '../../network/firebase.dart';

class SettingsImpl extends Settings {
  const SettingsImpl(this.repository);

  final FirebaseRepository repository;

  @override
  Stream<SettingsModel> fetch() {
    return repository.db.settings.snapshots().map((MapDocumentSnapshot snapshot) {
      final DynamicMap? data = snapshot.data();
      if (data == null) {
        throw const NoInternetException();
      }
      return SettingsModel.fromJson(data);
    });
  }
}
