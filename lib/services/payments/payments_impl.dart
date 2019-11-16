import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/repository/firebase/main.dart';
import 'package:tailor_made/services/payments/payments.dart';

class PaymentsImpl extends Payments {
  PaymentsImpl(this.repository);

  final FirebaseRepository repository;

  @override
  Stream<List<PaymentModel>> fetchAll(String userId) {
    return repository.db
        .payments(userId)
        .snapshots()
        .map((snap) => snap.documents.map((item) => PaymentModel.fromJson(item.data)).toList());
  }
}
