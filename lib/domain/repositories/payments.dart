import '../entities/payment_entity.dart';

abstract class Payments {
  Stream<List<PaymentEntity>> fetchAll(String userId);
}
