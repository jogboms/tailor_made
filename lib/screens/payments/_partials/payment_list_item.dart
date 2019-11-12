import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_strings.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/screens/payments/payment.dart';
import 'package:tailor_made/utils/mk_money.dart';
import 'package:tailor_made/widgets/_partials/mk_dots.dart';
import 'package:tailor_made/widgets/theme_provider.dart';
import 'package:tailor_made/wrappers/mk_navigate.dart';

class PaymentListItem extends StatelessWidget {
  const PaymentListItem({
    Key key,
    this.payment,
  }) : super(key: key);

  final PaymentModel payment;

  @override
  Widget build(BuildContext context) {
    final _date = payment.createdAt;
    final theme = ThemeProvider.of(context);

    return Material(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push<void>(MkNavigate.slideIn(
            PaymentPage(payment: payment),
            fullscreenDialog: true,
          ));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: <Widget>[
                    const MkDots(
                      color: kAccentColor,
                      size: 12,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      MkMoney(payment.price).formatted,
                      style: theme.title.copyWith(letterSpacing: 1.5),
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: _date.day.toString(),
                      style: theme.subhead3Semi.copyWith(color: kAccentColor),
                    ),
                    const TextSpan(text: "\n"),
                    TextSpan(
                      text: "${MkStrings.monthsShort[_date.month - 1].toUpperCase()}, ${_date.year}",
                      style: theme.smallMedium.copyWith(color: Colors.black54),
                    ),
                  ],
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
