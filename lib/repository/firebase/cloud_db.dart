import 'package:cloud_firestore/cloud_firestore.dart';

class CloudDb {
  CloudDb(this._instance);

  final FirebaseFirestore _instance;

  DocumentReference<Map<String, dynamic>> account(String? userId) => _instance.doc('accounts/$userId');

  DocumentReference<Map<String, dynamic>> stats(String? userId) => _instance.doc('stats/$userId');

  DocumentReference<Map<String, dynamic>> get settings => _instance.doc('settings/common');

  CollectionReference<Map<String, dynamic>> measurements(String? userId) =>
      _instance.collection('measurements/$userId/common');

  CollectionReference<Map<String, dynamic>?> get premium => _instance.collection('premium');

  Query<Map<String, dynamic>> gallery(String userId) =>
      _instance.collection('gallery').where('userID', isEqualTo: userId);

  Query<Map<String, dynamic>> payments(String userId) =>
      _instance.collection('payments').where('userID', isEqualTo: userId);

  Query<Map<String, dynamic>> contacts(String? userId) =>
      _instance.collection('contacts').where('userID', isEqualTo: userId);

  Query<Map<String, dynamic>> jobs(String? userId) => _instance.collection('jobs').where('userID', isEqualTo: userId);

  Future<void> batchAction(void Function(WriteBatch batch) action) {
    final WriteBatch batch = _instance.batch();

    action(batch);

    return batch.commit();
  }
}
