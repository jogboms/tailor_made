import 'package:tailor_made/domain.dart';

sealed class PaymentOperation {}

class CreatePaymentOperation implements PaymentOperation {
  const CreatePaymentOperation({required this.data});

  final CreatePaymentData data;
}

class ModifyPaymentOperation implements PaymentOperation {
  const ModifyPaymentOperation({required this.data});

  final PaymentEntity data;
}
