import 'package:flutter/material.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/pages/jobs/models/job.model.dart';
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
    final List<dynamic> payments = [];

    // jobs.forEach(
    //   (item) => payments.addAll(
    //         item.payments.map(
    //           (src) => GalleryImageModel(src: src),
    //         ),
    //       ),
    // );

    if (payments.isEmpty) {
      return SliverFillRemaining(
        child: TMEmptyResult(message: "No payments available"),
      );
    }

    return PaymentList(payments: payments.toList());
  }
}
