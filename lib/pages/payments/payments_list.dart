import 'dart:math' show max;

import 'package:flutter/material.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/pages/payments/payment_list_item.dart';
import 'package:tailor_made/ui/tm_empty_result.dart';

class PaymentList extends StatelessWidget {
  final List<PaymentModel> payments;

  PaymentList({this.payments});

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) {
      return SliverFillRemaining(
        child: TMEmptyResult(message: "No payments available"),
      );
    }

    return SliverList(
      delegate: new SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final int itemIndex = index ~/ 2;
          return (index == 0 || index.isEven) ? PaymentListItem(payment: payments[itemIndex]) : new Divider();
        },
        childCount: max(0, payments.length * 2 - 1),
      ),
    );
  }
}
