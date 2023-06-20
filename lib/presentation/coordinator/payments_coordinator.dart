import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/utils/route_transitions.dart';

import '../screens/payments/payment.dart';
import '../screens/payments/payments.dart';
import '../screens/payments/payments_create.dart';
import 'coordinator_base.dart';

@immutable
class PaymentsCoordinator extends CoordinatorBase {
  const PaymentsCoordinator(super.navigatorKey);

  void toPayment(PaymentModel payment) {
    navigator?.push<void>(RouteTransitions.slideIn(PaymentPage(payment: payment), fullscreenDialog: true));
  }

  void toPayments(String userId, [List<PaymentModel>? payments]) {
    navigator?.push<void>(
      payments == null
          ? RouteTransitions.slideIn(PaymentsPage(payments: payments, userId: userId))
          : RouteTransitions.slideIn(PaymentsPage(payments: payments, userId: userId), fullscreenDialog: true),
    );
  }

  Future<Map<String, dynamic>?>? toCreatePayment(double? payment) {
    return navigator?.push<Map<String, dynamic>>(RouteTransitions.fadeIn(PaymentsCreatePage(limit: payment)));
  }
}
