import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/services/payments.dart';

class PaymentsMockImpl extends Payments {
  @override
  Stream<List<PaymentModel>> fetchAll() async* {
    // TODO
    yield null;
  }
}
