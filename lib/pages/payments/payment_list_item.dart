import 'package:flutter/material.dart';
import 'package:tailor_made/pages/payments/models/payment.model.dart';

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
