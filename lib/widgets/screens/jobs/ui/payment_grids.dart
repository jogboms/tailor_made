import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/screens/jobs/ui/payment_grid_item.dart';
import 'package:tailor_made/widgets/screens/payments/payments.dart';
import 'package:tailor_made/widgets/screens/payments/payments_create.dart';

const _kGridWidth = 120.0;

class FirePayment {
  PaymentModel payment;
  bool isLoading = true;
  bool isSucess = false;
}

class PaymentGrids extends StatefulWidget {
  PaymentGrids({
    Key key,
    double gridSize,
    @required this.job,
  })  : gridSize = Size.square(gridSize ?? _kGridWidth),
        super(key: key);

  final Size gridSize;
  final JobModel job;

  @override
  PaymentGridsState createState() {
    return PaymentGridsState();
  }
}

class PaymentGridsState extends State<PaymentGrids> {
  List<FirePayment> firePayments = [];

  @override
  void initState() {
    super.initState();
    firePayments = widget.job.payments
        .map((payment) => FirePayment()..payment = payment)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> paymentsList = List<Widget>.generate(
      firePayments.length,
      (int index) {
        final fireImage = firePayments[index];
        final payment = fireImage.payment;

        if (payment == null) {
          return Center(widthFactor: 2.5, child: const MkLoadingSpinner());
        }

        return PaymentGridItem(payment: payment);
      },
    ).toList();

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(width: 16.0),
            Expanded(
              child: Text(
                "PAYMENTS",
                style: mkFontRegular(12.0, Colors.black87),
              ),
            ),
            CupertinoButton(
              child: Text(
                "SHOW ALL",
                style: mkFontRegular(11.0, Colors.black),
              ),
              onPressed: () => MkNavigate(
                    context,
                    PaymentsPage(payments: widget.job.payments),
                    fullscreenDialog: true,
                  ),
            ),
          ],
        ),
        Container(
          height: _kGridWidth + 8,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            scrollDirection: Axis.horizontal,
            children: [newGrid(widget.gridSize)]
              ..addAll(paymentsList.reversed.toList()),
          ),
        ),
      ],
    );
  }

  Widget newGrid(Size gridSize) {
    return Container(
      width: _kGridWidth,
      margin: EdgeInsets.only(right: 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.grey[100],
        child: InkWell(
          onTap: () async {
            final result = await Navigator.push<Map<String, dynamic>>(
              context,
              MkNavigate.fadeIn<Map<String, dynamic>>(
                PaymentsCreatePage(
                  limit: widget.job.pendingPayment,
                ),
              ),
            );
            if (result != null) {
              setState(() {
                firePayments.add(FirePayment());
              });

              try {
                setState(() {
                  firePayments.last.payment = PaymentModel(
                    contactID: widget.job.contactID,
                    jobID: widget.job.id,
                    price: result["price"],
                    notes: result["notes"],
                  );
                });

                await widget.job.reference
                    .updateData(<String, List<Map<String, dynamic>>>{
                  "payments": firePayments
                      .map((payment) => payment.payment.toMap())
                      .toList(),
                });

                setState(() {
                  firePayments.last
                    ..isLoading = false
                    ..isSucess = true;
                });
              } catch (e) {
                setState(() {
                  firePayments.last.isLoading = false;
                });
              }
            }
          },
          child: Icon(
            Icons.note_add,
            size: 30.0,
            color: kTextBaseColor.withOpacity(.35),
          ),
        ),
      ),
    );
  }
}
