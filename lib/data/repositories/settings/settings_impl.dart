import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';

import '../../network/firebase.dart';

class SettingsImpl extends Settings {
  SettingsImpl({
    required Firebase firebase,
    required this.isDev,
  }) : collection = CloudDbCollection(firebase.db, collectionName);

  final bool isDev;
  final CloudDbCollection collection;

  static const String collectionName = 'settings';

  @override
  Stream<SettingEntity> fetch() {
    return collection.fetchOne('common').snapshots().map((MapDocumentSnapshot snapshot) {
      final DynamicMap? data = snapshot.data();
      if (data == null) {
        throw const NoInternetException();
      }
      return SettingEntity(
        premiumNotice: data['premiumNotice'] as String,
        versionName: data['versionName'] as String,
      );
    });
  }
}
