import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tailor_made/domain.dart';

import '../../network/firebase.dart';

class PaymentsImpl extends Payments {
  PaymentsImpl(this.repository);

  final FirebaseRepository repository;

  @override
  Stream<List<PaymentModel>> fetchAll(String userId) {
    return repository.db.payments(userId).snapshots().map(
          (QuerySnapshot<Map<String, dynamic>> snap) => snap.docs
              .map((QueryDocumentSnapshot<Map<String, dynamic>> item) => PaymentModel.fromJson(item.data()))
              .toList(),
        );
  }
}
