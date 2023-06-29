import 'package:equatable/equatable.dart';
import 'package:tailor_made/domain.dart';

sealed class PaymentGridsFormValue {}

class PaymentGridsCreateFormValue with EquatableMixin implements PaymentGridsFormValue {
  PaymentGridsCreateFormValue(this.data);

  final CreatePaymentData data;

  @override
  List<Object> get props => <Object>[data];
}

class PaymentGridsModifyFormValue with EquatableMixin implements PaymentGridsFormValue {
  PaymentGridsModifyFormValue(this.data);

  final PaymentEntity data;

  @override
  List<Object> get props => <Object>[data];
}
