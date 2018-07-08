import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tailor_made/pages/payments/models/payment.model.dart';
import 'package:tailor_made/pages/payments/payment.dart';
import 'package:tailor_made/utils/tm_months.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class PaymentListItem extends StatelessWidget {
  final PaymentModel payment;
  final nairaFormat = new NumberFormat.compactSimpleCurrency(name: "NGN", decimalDigits: 1);

  PaymentListItem({
    Key key,
    this.payment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _date = payment.createdAt;
    final _price = nairaFormat.format(payment.price ?? 0);
    final textColor = Colors.black54;

    return Container(
      // color: Colors.grey.shade300,
      margin: EdgeInsets.only(bottom: 2.0),
      child: new InkResponse(
        onTap: () => TMNavigate(context, PaymentPage(payment: payment), fullscreenDialog: true),
        radius: 300.0,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Stack(
            children: [
              new Align(
                alignment: Alignment.topRight,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: _date.day.toString(),
                        style: ralewayMedium(16.0, accentColor),
                      ),
                      TextSpan(text: "\n"),
                      TextSpan(
                        text: "${MONTHS_SHORT[_date.month-1].toUpperCase()}, ${_date.year}",
                        style: ralewayMedium(10.0, textColor),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 4.0,
                        height: 4.0,
                        decoration: BoxDecoration(
                          color: accentColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        _price,
                        style: ralewayMedium(18.0, Colors.black87).copyWith(
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
