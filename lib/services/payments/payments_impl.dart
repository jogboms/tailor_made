import 'package:tailor_made/firebase/cloud_db.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/services/payments/payments.dart';

class PaymentsImpl extends Payments {
  @override
  Stream<List<PaymentModel>> fetchAll() {
    return CloudDb.payments
        .snapshots()
        .map((snap) => snap.documents.map((item) => PaymentModel.fromJson(item.data)).toList());
  }
}
