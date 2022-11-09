import 'package:tailor_made/domain.dart';

import '../../network/firebase.dart';

class PaymentsImpl extends Payments {
  PaymentsImpl({
    required this.firebase,
    required this.isDev,
  });

  final Firebase firebase;
  final bool isDev;

  @override
  Stream<List<PaymentModel>> fetchAll(String userId) {
    return firebase.db.payments(userId).snapshots().map(
          (MapQuerySnapshot snap) =>
              snap.docs.map((MapQueryDocumentSnapshot item) => PaymentModel.fromJson(item.data())).toList(),
        );
  }
}
