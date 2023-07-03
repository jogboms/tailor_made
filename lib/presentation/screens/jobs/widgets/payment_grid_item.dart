import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';
import 'package:tailor_made/presentation/routing.dart';

import 'payment_grids_form_value.dart';

class PaymentGridItem extends StatelessWidget {
  const PaymentGridItem({super.key, required this.value});

  final PaymentGridsFormValue value;

  static const double kGridWidth = 120.0;

  @override
  Widget build(BuildContext context) {
    final PaymentGridsFormValue value = this.value;
    final PaymentEntity? payment = switch (value) {
      PaymentGridsCreateFormValue() => null,
      PaymentGridsModifyFormValue() => value.data,
    };
    final ({DateTime createdAt, double price}) record = switch (value) {
      PaymentGridsCreateFormValue() => (createdAt: clock.now(), price: value.data.price),
      PaymentGridsModifyFormValue() => (createdAt: value.data.createdAt, price: value.data.price),
    };

    final DateTime date = record.createdAt;
    final String price = AppMoney(record.price).formatted;
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final Color backgroundColor = payment != null ? colorScheme.primary : theme.hintColor;
    final Color foregroundColor = colorScheme.onPrimary;

    return Container(
      width: kGridWidth,
      margin: const EdgeInsets.only(right: 8.0),
      child: Material(
        elevation: 1.0,
        borderRadius: BorderRadius.circular(5.0),
        color: backgroundColor,
        child: InkWell(
          onTap: payment != null ? () => context.router.toPayment(payment) : null,
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
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: AppFontWeight.medium, color: foregroundColor),
                        ),
                        const TextSpan(text: '\n'),
                        TextSpan(
                          text: '${AppStrings.monthsShort[date.month - 1].toUpperCase()}, ${date.year}',
                          style: theme.textTheme.labelSmall
                              ?.copyWith(fontWeight: AppFontWeight.medium, color: foregroundColor),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                Text(price, style: theme.textTheme.pageTitle.copyWith(color: foregroundColor))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
