import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/services/payments/payments.dart';

class PaymentsMockImpl extends Payments {
  @override
  Stream<List<PaymentModel>> fetchAll(String userId) async* {
    // TODO
    yield null;
  }
}
