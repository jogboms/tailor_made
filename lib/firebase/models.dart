import 'package:cloud_firestore/cloud_firestore.dart';

class Snapshot {
  Snapshot({this.data, this.reference});

  Snapshot.fromDocumentSnapshot(DocumentSnapshot doc)
      : data = doc.data,
        reference = doc.reference;

  final Map<String, dynamic> data;
  final DocumentReference reference;
}
