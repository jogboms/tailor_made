import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/utils.dart';
import 'package:tailor_made/presentation/widgets.dart';

import 'payment_list_item.dart';

class PaymentList extends StatelessWidget {
  const PaymentList({super.key, required this.payments});

  final List<PaymentEntity> payments;

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) {
      return SliverFillRemaining(
        child: EmptyResultView(message: context.l10n.noPaymentsAvailableMessage),
      );
    }

    return SliverList(
      delegate: AppSliverSeparatorBuilderDelegate(
        childCount: payments.length,
        builder: (_, int index) => PaymentListItem(payment: payments[index]),
        separatorBuilder: (_, __) => const Divider(height: 0),
      ),
    );
  }
}
