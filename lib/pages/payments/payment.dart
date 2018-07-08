import 'package:flutter/material.dart';
import 'package:tailor_made/pages/payments/models/payment.model.dart';
import 'package:tailor_made/utils/tm_format_date.dart';
import 'package:tailor_made/utils/tm_format_naira.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class PaymentPage extends StatelessWidget {
  final PaymentModel payment;

  PaymentPage({
    Key key,
    @required this.payment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _price = formatNaira(payment.price ?? 0);

    final date = formatDate(payment.createdAt, day: "EEEE", month: "MMMM");

    return new Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 180.0,
            width: double.infinity,
            child: Center(
              child: Text(
                _price,
                style: ralewayLight(50.0, Colors.black87),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              date,
              style: ralewayLight(14.0, Colors.black54),
              textAlign: TextAlign.justify,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              payment.notes,
              style: ralewayLight(14.0, Colors.black54),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
