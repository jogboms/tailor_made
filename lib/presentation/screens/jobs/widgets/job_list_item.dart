import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';
import 'package:tailor_made/presentation/routing.dart';

class JobListItem extends StatelessWidget {
  const JobListItem({super.key, required this.job});

  final JobEntity job;

  @override
  Widget build(BuildContext context) {
    final DateTime date = job.createdAt;
    final String price = AppMoney(job.price).formatted;
    final String paid = AppMoney(job.completedPayment).formatted;
    final String owed = AppMoney(job.pendingPayment).formatted;
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Material(
      child: InkWell(
        onTap: () => context.router.toJob(job),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: '${date.day}\n', style: theme.textTheme.titleLarge),
                      TextSpan(
                        text: AppStrings.monthsShort[date.month - 1].toUpperCase(),
                        style: theme.textTheme.bodySmall?.copyWith(letterSpacing: 2.0),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(job.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: AppFontWeight.semibold)),
                    const SizedBox(height: 2.0),
                    Text(price, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 2.0),
                    if (job.pendingPayment > 0)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.arrow_drop_up, color: Colors.green.shade600, size: 12.0),
                          const SizedBox(width: 2.0),
                          Text(paid, style: const TextStyle(fontSize: 11.0)),
                          const SizedBox(width: 4.0),
                          Icon(Icons.arrow_drop_down, color: Colors.red.shade600, size: 12.0),
                          const SizedBox(width: 2.0),
                          Text(owed, style: const TextStyle(fontSize: 11.0)),
                        ],
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Icon(Icons.attach_money, size: 12.0),
                      ),
                  ],
                ),
              ),
              Icon(Icons.check, color: job.isComplete ? colorScheme.primary : null),
            ],
          ),
        ),
      ),
    );
  }
}
