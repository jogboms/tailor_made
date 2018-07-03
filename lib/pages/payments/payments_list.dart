import 'package:flutter/material.dart';
import 'package:tailor_made/pages/payments/models/payment.model.dart';

class PaymentList extends StatelessWidget {
  final List<PaymentModel> payments;

  PaymentList({this.payments});

  @override
  Widget build(BuildContext context) {
    SliverChildListDelegate delegate = new SliverChildListDelegate(
      payments.map((payment) => PaymentListItem(payment: payment)).toList(),
    );

    return SliverList(delegate: delegate);
  }
}

class PaymentListItem extends StatelessWidget {
  final PaymentModel payment;

  PaymentListItem({this.payment});

  @override
  Widget build(BuildContext context) {
    onTapPayment() {
      print("onTapList");
    }

    return Container(
      // padding: EdgeInsets.zero,
      // padding: EdgeInsets.all(20.0),
      color: Colors.grey[100],
      margin: EdgeInsets.only(bottom: 2.0),
      height: 100.0,
      child: new InkResponse(
        onTap: onTapPayment,
        radius: 300.0,
        child: Text(""),
      ),
    );
  }
}