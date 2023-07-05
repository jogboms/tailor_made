import 'package:tailor_made/domain.dart';

import '../../network/firebase.dart';

class PaymentsImpl extends Payments {
  PaymentsImpl({
    required Firebase firebase,
    required this.isDev,
  }) : collection = CloudDbCollection(firebase.db, collectionName);

  final bool isDev;
  final CloudDbCollection collection;

  static const String collectionName = 'payments';

  @override
  Stream<List<PaymentEntity>> fetchAll(String userId) {
    return collection.fetchAll().where('userID', isEqualTo: userId).snapshots().map(
          (MapQuerySnapshot snap) => snap.docs
              .map((MapQueryDocumentSnapshot item) => derivePaymentEntity(item.id, item.reference.path, item.data()))
              .toList(),
        );
  }
}

PaymentEntity derivePaymentEntity(String id, String? path, DynamicMap data) {
  return PaymentEntity(
    reference: ReferenceEntity(id: id, path: path ?? '${PaymentsImpl.collectionName}/$id'),
    id: id,
    userID: data['userID'] as String,
    contactID: data['contactID'] as String,
    jobID: data['jobID'] as String,
    price: double.parse('${data['price']}'),
    notes: data['notes'] as String,
    createdAt: DateTime.parse(data['createdAt'] as String),
  );
}

extension PaymentEntityFirebaseExtension on PaymentEntity {
  Map<String, Object> toJson() {
    return <String, Object>{
      'id': id,
      'userID': userID,
      'contactID': contactID,
      'jobID': jobID,
      'price': price,
      'notes': notes,
      'createdAt': createdAt.toUtc().toString(),
    };
  }
}
