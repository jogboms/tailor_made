import 'package:flutter/material.dart';
import 'package:tailor_made/coordinator/coordinator_base.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/screens/payments/payment.dart';
import 'package:tailor_made/screens/payments/payments.dart';
import 'package:tailor_made/screens/payments/payments_create.dart';
import 'package:tailor_made/wrappers/mk_navigate.dart';

@immutable
class PaymentsCoordinator extends CoordinatorBase {
  const PaymentsCoordinator(super.navigatorKey);

  void toPayment(PaymentModel? payment) {
    navigator?.push<void>(MkNavigate.slideIn(PaymentPage(payment: payment), fullscreenDialog: true));
  }

  void toPayments(String userId, [List<PaymentModel>? payments]) {
    navigator?.push<void>(
      payments == null
          ? MkNavigate.slideIn(PaymentsPage(payments: payments, userId: userId))
          : MkNavigate.slideIn(PaymentsPage(payments: payments, userId: userId), fullscreenDialog: true),
    );
  }

  Future<Map<String, dynamic>?>? toCreatePayment(double? payment) {
    return navigator?.push<Map<String, dynamic>>(MkNavigate.fadeIn(PaymentsCreatePage(limit: payment)));
  }
}
