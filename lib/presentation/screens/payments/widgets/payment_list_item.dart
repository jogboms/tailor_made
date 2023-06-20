import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/constants.dart';
import 'package:tailor_made/presentation/theme.dart';
import 'package:tailor_made/presentation/utils.dart';
import 'package:tailor_made/presentation/widgets.dart';

import '../payment.dart';

class PaymentListItem extends StatelessWidget {
  const PaymentListItem({super.key, required this.payment});

  final PaymentModel payment;

  @override
  Widget build(BuildContext context) {
    final DateTime date = payment.createdAt;
    final ThemeProvider theme = ThemeProvider.of(context)!;

    return Material(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push<void>(
            RouteTransitions.slideIn(
              PaymentPage(payment: payment),
              fullscreenDialog: true,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    const Dots(color: kAccentColor, size: 12),
                    const SizedBox(width: 8.0),
                    Text(
                      AppMoney(payment.price).formatted,
                      style: theme.title.copyWith(letterSpacing: 1.5),
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: date.day.toString(), style: theme.subhead3Semi.copyWith(color: kAccentColor)),
                    const TextSpan(text: '\n'),
                    TextSpan(
                      text: '${AppStrings.monthsShort[date.month - 1].toUpperCase()}, ${date.year}',
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
