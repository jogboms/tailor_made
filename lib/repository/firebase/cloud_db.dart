import 'package:cloud_firestore/cloud_firestore.dart';

class CloudDb {
  CloudDb(this._instance);

  final Firestore _instance;

  DocumentReference account(String userId) => _instance.document('accounts/$userId');

  DocumentReference stats(String userId) => _instance.document('stats/$userId');

  DocumentReference get settings => _instance.document('settings/common');

  CollectionReference measurements(String userId) => _instance.collection('measurements/$userId/common');

  CollectionReference get premium => _instance.collection('premium');

  Query gallery(String userId) => _instance.collection('gallery').where('userID', isEqualTo: userId);

  Query payments(String userId) => _instance.collection('payments').where('userID', isEqualTo: userId);

  Query contacts(String userId) => _instance.collection('contacts').where('userID', isEqualTo: userId);

  Query jobs(String userId) => _instance.collection('jobs').where('userID', isEqualTo: userId);

  Future<void> batchAction(void Function(WriteBatch batch) action) {
    final WriteBatch batch = _instance.batch();

    action(batch);

    return batch.commit();
  }
}
