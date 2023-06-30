import 'package:cloud_firestore/cloud_firestore.dart';

import 'models.dart';

class CloudDb {
  CloudDb(this._instance);

  final FirebaseFirestore _instance;

  MapCollectionReference collection(String path) => _instance.collection(path);

  MapDocumentReference doc(String path) => _instance.doc(path);

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
