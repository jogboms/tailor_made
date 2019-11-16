import 'package:tailor_made/models/payment.dart';

abstract class Payments {
  Stream<List<PaymentModel>> fetchAll(String userId);
}
