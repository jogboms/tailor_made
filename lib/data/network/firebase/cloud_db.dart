import 'package:cloud_firestore/cloud_firestore.dart';

import 'models.dart';

class CloudDb {
  CloudDb(this._instance);

  final FirebaseFirestore _instance;

  MapDocumentReference account(String? userId) => _instance.doc('accounts/$userId');

  MapDocumentReference stats(String? userId) => _instance.doc('stats/$userId');

  MapDocumentReference get settings => _instance.doc('settings/common');

  MapCollectionReference measurements(String? userId) => _instance.collection('measurements/$userId/common');

  MapCollectionReference get premium => _instance.collection('premium');

  MapQuery gallery(String userId) => _instance.collection('gallery').where('userID', isEqualTo: userId);

  MapQuery payments(String userId) => _instance.collection('payments').where('userID', isEqualTo: userId);

  MapQuery contacts(String? userId) => _instance.collection('contacts').where('userID', isEqualTo: userId);

  MapQuery jobs(String? userId) => _instance.collection('jobs').where('userID', isEqualTo: userId);

  Future<void> batchAction(void Function(WriteBatch batch) action) {
    final WriteBatch batch = _instance.batch();

    action(batch);

    return batch.commit();
  }
}
