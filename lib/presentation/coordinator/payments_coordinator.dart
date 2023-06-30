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

  void toPayment(PaymentEntity payment) {
    navigator?.push<void>(RouteTransitions.slideIn(PaymentPage(payment: payment), fullscreenDialog: true));
  }

  void toPayments(String userId, [List<PaymentEntity>? payments]) {
    navigator?.push<void>(
      payments == null
          ? RouteTransitions.slideIn(PaymentsPage(userId: userId))
          : RouteTransitions.slideIn(PaymentsPage(payments: payments, userId: userId), fullscreenDialog: true),
    );
  }

  Future<({double price, String notes})?>? toCreatePayment(double payment) {
    return navigator?.push<({double price, String notes})>(RouteTransitions.fadeIn(PaymentsCreatePage(limit: payment)));
  }
}
