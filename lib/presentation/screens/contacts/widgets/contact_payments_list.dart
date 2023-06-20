import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/widgets.dart';

import '../../payments/widgets/payments_list.dart';

class PaymentsListWidget extends StatelessWidget {
  const PaymentsListWidget({super.key, required this.jobs});

  final List<JobEntity> jobs;

  @override
  Widget build(BuildContext context) {
    final List<PaymentEntity> payments = jobs.fold<List<PaymentEntity>>(
      <PaymentEntity>[],
      (List<PaymentEntity> acc, JobEntity item) => acc..addAll(item.payments),
    );

    if (payments.isEmpty) {
      return const SliverFillRemaining(child: EmptyResultView(message: 'No payments available'));
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      sliver: PaymentList(payments: payments.toList()),
    );
  }
}
