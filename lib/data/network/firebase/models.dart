import 'package:cloud_firestore/cloud_firestore.dart';

typedef DynamicMap = Map<String, dynamic>;
typedef MapQuery = Query<DynamicMap>;
typedef MapQuerySnapshot = QuerySnapshot<DynamicMap>;
typedef MapQueryDocumentSnapshot = QueryDocumentSnapshot<DynamicMap>;
typedef MapDocumentSnapshot = DocumentSnapshot<DynamicMap>;
typedef MapDocumentReference = DocumentReference<DynamicMap>;
typedef MapCollectionReference = CollectionReference<DynamicMap>;

typedef CloudTimestamp = Timestamp;
typedef CloudValue = FieldValue;
