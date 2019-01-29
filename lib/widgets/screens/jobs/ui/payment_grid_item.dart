import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_strings.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/utils/mk_money.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/widgets/screens/payments/payment.dart';

const _kGridWidth = 120.0;

class PaymentGridItem extends StatelessWidget {
  PaymentGridItem({
    Key key,
    this.payment,
    double size,
  })  : size = Size.square(size ?? _kGridWidth),
        super(key: key);

  final PaymentModel payment;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final _date = payment.createdAt;
    final _price = MkMoney(payment.price).format;

    return Container(
      width: size.width,
      margin: EdgeInsets.only(right: 8.0),
      child: Material(
        elevation: 1.0,
        borderRadius: BorderRadius.circular(5.0),
        color: kPrimaryColor,
        child: InkWell(
          onTap: () => MkNavigate(context, PaymentPage(payment: payment),
              fullscreenDialog: true),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: _date.day.toString(),
                          style: mkFontMedium(16.0, Colors.white),
                        ),
                        TextSpan(text: "\n"),
                        TextSpan(
                          text:
                              "${MkStrings.monthsShort[_date.month - 1].toUpperCase()}, ${_date.year}",
                          style: mkFontMedium(10.0, Colors.white),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                Text(
                  _price,
                  style: mkFontMedium(24.0, Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
