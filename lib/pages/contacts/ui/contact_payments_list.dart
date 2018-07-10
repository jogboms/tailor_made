import 'package:flutter/material.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/pages/payments/payments_list.dart';
import 'package:tailor_made/ui/tm_empty_result.dart';

class PaymentsListWidget extends StatelessWidget {
  final ContactModel contact;
  final List<JobModel> jobs;

  PaymentsListWidget({
    Key key,
    @required this.contact,
    @required this.jobs,
  }) : super(key: key);

  @override
  build(BuildContext context) {
    final List<PaymentModel> payments = [];

    jobs.forEach(
      (item) => payments.addAll(item.payments),
    );

    if (payments.isEmpty) {
      return SliverFillRemaining(
        child: TMEmptyResult(message: "No payments available"),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      sliver: PaymentList(payments: payments.toList()),
    );
  }
}
