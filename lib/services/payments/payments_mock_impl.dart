import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/repository/mock/main.dart';
import 'package:tailor_made/services/payments/payments.dart';

class PaymentsMockImpl extends Payments<MockRepository> {
  @override
  Stream<List<PaymentModel>> fetchAll() async* {
    // TODO
    yield null;
  }
}
