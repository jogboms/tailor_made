import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/routing.dart';
import 'package:tailor_made/presentation/theme.dart';
import 'package:tailor_made/presentation/utils.dart';
import 'package:tailor_made/presentation/widgets.dart';

class PaymentListItem extends StatelessWidget {
  const PaymentListItem({super.key, required this.payment});

  final PaymentEntity payment;

  @override
  Widget build(BuildContext context) {
    final DateTime date = payment.createdAt;
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final L10n l10n = context.l10n;

    return Material(
      child: InkWell(
        onTap: () => context.router.toPayment(payment),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Dots(color: colorScheme.secondary, size: 12),
                    const SizedBox(width: 8.0),
                    Text(
                      AppMoney(payment.price).formatted,
                      style: theme.textTheme.pageTitle.copyWith(letterSpacing: 1.5),
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: date.day.toString(),
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: colorScheme.secondary, fontWeight: AppFontWeight.semibold),
                    ),
                    const TextSpan(text: '\n'),
                    TextSpan(
                      text: '${l10n.monthsShortNames[date.month - 1].toUpperCase()}, ${date.year}',
                      style: theme.textTheme.bodySmallMedium,
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
