import 'package:tailor_made/domain.dart';

sealed class PaymentGridsFormValue {}

class PaymentGridsCreateFormValue implements PaymentGridsFormValue {
  PaymentGridsCreateFormValue(this.data);

  final CreatePaymentData data;
}

class PaymentGridsModifyFormValue implements PaymentGridsFormValue {
  PaymentGridsModifyFormValue(this.data);

  final PaymentEntity data;
}
