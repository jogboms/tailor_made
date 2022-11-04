import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_strings.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/utils/mk_money.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

const double _kGridWidth = 120.0;

class PaymentGridItem extends StatelessWidget {
  PaymentGridItem({super.key, this.payment, double? size}) : size = Size.square(size ?? _kGridWidth);

  final PaymentModel? payment;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final DateTime date = payment!.createdAt;
    final String price = MkMoney(payment!.price).formatted;
    final ThemeProvider theme = ThemeProvider.of(context)!;

    return Container(
      width: size.width,
      margin: const EdgeInsets.only(right: 8.0),
      child: Material(
        elevation: 1.0,
        borderRadius: BorderRadius.circular(5.0),
        color: kPrimaryColor,
        child: InkWell(
          onTap: () => Dependencies.di().paymentsCoordinator.toPayment(payment),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: date.day.toString(),
                          style: theme.subhead3.copyWith(fontWeight: MkStyle.medium, color: Colors.white),
                        ),
                        const TextSpan(text: '\n'),
                        TextSpan(
                          text: '${MkStrings.monthsShort[date.month - 1].toUpperCase()}, ${date.year}',
                          style: theme.xxsmall.copyWith(fontWeight: MkStyle.medium, color: Colors.white),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                Text(price, style: theme.title.copyWith(color: Colors.white))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
