import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';

import '../../network/firebase.dart';

class SettingsImpl extends Settings {
  const SettingsImpl(this.repository);

  final FirebaseRepository repository;

  @override
  Stream<SettingsModel?> fetch() {
    return repository.db.settings.snapshots().map((firestore.DocumentSnapshot<Map<String, dynamic>> snapshot) {
      final Map<String, dynamic>? data = snapshot.data();
      if (data == null) {
        throw const NoInternetException();
      }
      return SettingsModel.fromJson(data);
    });
  }
}
