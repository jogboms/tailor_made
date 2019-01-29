import 'dart:math' show max;

import 'package:flutter/material.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/widgets/_views/empty_result_view.dart';
import 'package:tailor_made/widgets/screens/payments/payment_list_item.dart';

class PaymentList extends StatelessWidget {
  const PaymentList({this.payments});

  final List<PaymentModel> payments;

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) {
      return SliverFillRemaining(
        child: const EmptyResultView(message: "No payments available"),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final int itemIndex = index ~/ 2;
          return (index == 0 || index.isEven)
              ? PaymentListItem(payment: payments[itemIndex])
              : const Divider();
        },
        childCount: max(0, payments.length * 2 - 1),
      ),
    );
  }
}
