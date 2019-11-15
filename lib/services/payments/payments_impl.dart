import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/repository/firebase/main.dart';
import 'package:tailor_made/services/payments/payments.dart';
import 'package:tailor_made/services/session.dart';

class PaymentsImpl extends Payments<FirebaseRepository> {
  @override
  Stream<List<PaymentModel>> fetchAll() {
    return repository.db
        .payments(Session.di().getUserId())
        .snapshots()
        .map((snap) => snap.documents.map((item) => PaymentModel.fromJson(item.data)).toList());
  }
}
