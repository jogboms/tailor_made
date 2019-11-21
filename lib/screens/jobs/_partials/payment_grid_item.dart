import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_strings.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/utils/mk_money.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

class PaymentGridItem extends StatelessWidget {
  PaymentGridItem({Key key, this.payment})
      : size = Size.square(_kGridWidth),
        super(key: key);

  final PaymentModel payment;
  final Size size;

  @override
  Widget build(BuildContext context) {
    if (payment == null) {
      return const Center(widthFactor: 2.5, child: MkLoadingSpinner());
    }

    final _date = payment.createdAt;
    final _price = MkMoney(payment.price).formatted;
    final theme = ThemeProvider.of(context);

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
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: _date.day.toString(),
                          style: theme.subhead3.copyWith(fontWeight: MkStyle.medium, color: Colors.white),
                        ),
                        const TextSpan(text: "\n"),
                        TextSpan(
                          text: "${MkStrings.monthsShort[_date.month - 1].toUpperCase()}, ${_date.year}",
                          style: theme.xxsmall.copyWith(fontWeight: MkStyle.medium, color: Colors.white),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                Text(_price, style: theme.title.copyWith(color: Colors.white))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const _kGridWidth = 120.0;
