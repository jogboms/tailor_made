import 'package:tailor_made/domain.dart';

import '../../network/firebase.dart';

class PaymentsImpl extends Payments {
  PaymentsImpl(this.repository);

  final FirebaseRepository repository;

  @override
  Stream<List<PaymentModel>> fetchAll(String userId) {
    return repository.db.payments(userId).snapshots().map(
          (MapQuerySnapshot snap) =>
              snap.docs.map((MapQueryDocumentSnapshot item) => PaymentModel.fromJson(item.data())).toList(),
        );
  }
}
