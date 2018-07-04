import 'package:flutter/material.dart';
import 'package:tailor_made/pages/payments/models/payment.model.dart';
import 'package:tailor_made/ui/blank.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

const _kGridWidth = 120.0;

class PaymentGridItem extends StatelessWidget {
  final PaymentModel payment;

  PaymentGridItem({
    Key key,
    this.payment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(payment);
    return new Container(
      width: _kGridWidth,
      margin: EdgeInsets.only(right: 8.0),
      child: new Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(5.0),
        color: accentColor.withOpacity(.8),
        child: new InkWell(
          onTap: () => TMNavigate(context, BlankPage(), fullscreenDialog: true),
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
                        TextSpan(text: "15", style: ralewayLight(24.0, Colors.white)),
                        TextSpan(text: "\n"),
                        TextSpan(text: "MAY, 2018", style: ralewayMedium(10.0, Colors.white)),
                      ],
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                Text(
                  "₦15,000",
                  style: ralewayBold(24.0, Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
