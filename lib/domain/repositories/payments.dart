import '../models/payment.dart';

abstract class Payments {
  Stream<List<PaymentModel>> fetchAll(String userId);
}
