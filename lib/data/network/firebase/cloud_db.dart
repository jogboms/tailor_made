import 'package:cloud_firestore/cloud_firestore.dart';

import 'models.dart';

class CloudDb {
  CloudDb(this._instance);

  final FirebaseFirestore _instance;

  MapCollectionReference collection(String path) => _instance.collection(path);

  MapDocumentReference doc(String path) => _instance.doc(path);

  MapDocumentReference stats(String? userId) => doc('stats/$userId');

  MapCollectionReference measurements(String? userId) => collection('measurements/$userId/common');

  MapCollectionReference get premium => collection('premium');

  MapQuery gallery(String userId) => collection('gallery').where('userID', isEqualTo: userId);

  MapQuery contacts(String? userId) => collection('contacts').where('userID', isEqualTo: userId);

  Future<void> batchAction(void Function(WriteBatch batch) action) {
    final WriteBatch batch = _instance.batch();

    action(batch);

    return batch.commit();
  }
}

class CloudDbCollection {
  const CloudDbCollection(this.db, this.path);

  final CloudDb db;

  final String path;

  MapCollectionReference fetchAll() => db.collection(path);

  MapDocumentReference fetchOne(String uuid) => db.doc('$path/$uuid');
}
