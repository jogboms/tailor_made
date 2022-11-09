import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';

import '../../network/firebase.dart';

class SettingsImpl extends Settings {
  const SettingsImpl({
    required this.firebase,
    required this.isDev,
  });

  final Firebase firebase;
  final bool isDev;

  @override
  Stream<SettingsModel> fetch() {
    return firebase.db.settings.snapshots().map((MapDocumentSnapshot snapshot) {
      final DynamicMap? data = snapshot.data();
      if (data == null) {
        throw const NoInternetException();
      }
      return SettingsModel.fromJson(data);
    });
  }
}
