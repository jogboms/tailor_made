import 'package:flutter/material.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/widgets/_views/empty_result_view.dart';
import 'package:tailor_made/widgets/screens/payments/payments_list.dart';

class PaymentsListWidget extends StatelessWidget {
  const PaymentsListWidget({
    Key key,
    @required this.contact,
    @required this.jobs,
  }) : super(key: key);

  final ContactModel contact;
  final List<JobModel> jobs;

  @override
  Widget build(BuildContext context) {
    final List<PaymentModel> payments = [];

    jobs.forEach(
      (item) => payments.addAll(item.payments),
    );

    if (payments.isEmpty) {
      return SliverFillRemaining(
        child: const EmptyResultView(message: "No payments available"),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      sliver: PaymentList(payments: payments.toList()),
    );
  }
}
