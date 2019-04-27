import 'package:flutter/material.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/screens/payments/_partials/payment_list_item.dart';
import 'package:tailor_made/utils/mk_sliver_separator_builder_delegate.dart';
import 'package:tailor_made/widgets/_views/empty_result_view.dart';

class PaymentList extends StatelessWidget {
  const PaymentList({
    Key key,
    @required this.payments,
  }) : super(key: key);

  final List<PaymentModel> payments;

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) {
      return SliverFillRemaining(
        child: const EmptyResultView(message: "No payments available"),
      );
    }

    return SliverList(
      delegate: MkSliverSeparatorBuilderDelegate(
        childCount: payments.length,
        builder: (BuildContext context, int index) {
          return PaymentListItem(payment: payments[index]);
        },
        separatorBuilder: (_, __) => const Divider(height: 0),
      ),
    );
  }
}
