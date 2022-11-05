import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:tailor_made/models/settings.dart';
import 'package:tailor_made/repository/firebase/main.dart';
import 'package:tailor_made/wrappers/mk_exceptions.dart';

import 'settings.dart';

class SettingsImpl extends Settings {
  const SettingsImpl(this.repository);

  final FirebaseRepository repository;

  @override
  Stream<SettingsModel?> fetch() {
    return repository.db.settings.snapshots().map((firestore.DocumentSnapshot<Object> snapshot) {
      if (snapshot.data() == null) {
        throw NoInternetException();
      }
      return SettingsModel.fromJson(snapshot.data() as Map<String, dynamic>?);
    });
  }
}
