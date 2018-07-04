import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tailor_made/pages/payments/models/payment.model.dart';
import 'package:tailor_made/pages/payments/payment.dart';
import 'package:tailor_made/utils/tm_months.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

const _kGridWidth = 120.0;

class PaymentGridItem extends StatelessWidget {
  final PaymentModel payment;
  final nairaFormat = new NumberFormat.compactSimpleCurrency(name: "NGN", decimalDigits: 1);
  final Size size;

  PaymentGridItem({
    Key key,
    this.payment,
    double size,
  })  : size = Size.square(size ?? _kGridWidth),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final _date = payment.createdAt;
    final _price = nairaFormat.format(payment.price ?? 0);

    return new Container(
      width: size.width,
      margin: EdgeInsets.only(right: 8.0),
      child: new Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(5.0),
        color: accentColor.withOpacity(.8),
        child: new InkWell(
          onTap: () => TMNavigate(context, PaymentPage(payment: payment), fullscreenDialog: true),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Align(
                  alignment: Alignment.topRight,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: _date.day.toString(),
                          style: ralewayLight(24.0, Colors.white),
                        ),
                        TextSpan(text: "\n"),
                        TextSpan(
                          text: "${MONTHS_SHORT[_date.month-1].toUpperCase()}, ${_date.year}",
                          style: ralewayMedium(10.0, Colors.white),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                Text(
                  _price,
                  style: ralewayRegular(24.0, Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
