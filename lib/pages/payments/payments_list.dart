import 'package:flutter/material.dart';
import 'package:tailor_made/pages/payments/models/payment.model.dart';
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
      delegate: new SliverChildListDelegate(
        payments.map((payment) => PaymentListItem(payment: payment)).toList(),
      ),
    );
  }
}
