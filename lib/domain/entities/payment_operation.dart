import 'create_payment_data.dart';
import 'payment_entity.dart';

sealed class PaymentOperation {}

class CreatePaymentOperation implements PaymentOperation {
  const CreatePaymentOperation({required this.data});

  final CreatePaymentData data;
}

class ModifyPaymentOperation implements PaymentOperation {
  const ModifyPaymentOperation({required this.data});

  final PaymentEntity data;
}
