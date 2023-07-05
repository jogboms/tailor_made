import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';
import 'package:tailor_made/presentation/routing.dart';

import '../providers/job_provider.dart';
import 'payment_grid_item.dart';
import 'payment_grids_form_value.dart';

class PaymentGrids extends StatefulWidget {
  const PaymentGrids({super.key, required this.job, required this.userId});

  final JobEntity job;
  final String userId;

  @override
  State<PaymentGrids> createState() => _PaymentGridsState();
}

class _PaymentGridsState extends State<PaymentGrids> {
  late final List<PaymentGridsFormValue> _payments = <PaymentGridsFormValue>[
    ...widget.job.payments.map(PaymentGridsModifyFormValue.new),
  ];

  @override
  void didUpdateWidget(covariant PaymentGrids oldWidget) {
    if (widget.job.payments != oldWidget.job.payments) {
      _payments
        ..clear()
        ..addAll(widget.job.payments.map(PaymentGridsModifyFormValue.new));
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final L10n l10n = context.l10n;

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(width: 16.0),
            Expanded(
              child: Text(l10n.paymentsPageTitle.toUpperCase(), style: theme.textTheme.bodySmall),
            ),
            AppClearButton(
              child: Text(
                l10n.showAllCaption,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: AppFontWeight.medium,
                  color: theme.colorScheme.secondary,
                ),
              ),
              onPressed: () => context.router.toPayments(
                widget.userId,
                widget.job.payments.toList(),
              ),
            ),
            const SizedBox(width: 16.0),
          ],
        ),
        Container(
          height: PaymentGridItem.kGridWidth + 8,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Consumer(
                builder: (BuildContext context, WidgetRef ref, _) => _NewGrid(
                  onPressed: () => _onCreateNew(ref.read(jobProvider)),
                ),
              ),
              for (final PaymentGridsFormValue value in _payments.reversed) PaymentGridItem(value: value)
            ],
          ),
        ),
      ],
    );
  }

  void _onCreateNew(JobProvider jobProvider) async {
    final ({double price, String notes})? result = await context.router.toCreatePayment(
      widget.job.pendingPayment,
    );
    if (result != null) {
      try {
        setState(() {
          _payments.add(
            PaymentGridsCreateFormValue(
              CreatePaymentData(
                userID: widget.userId,
                contactID: widget.job.contactID,
                jobID: widget.job.id,
                price: result.price,
                notes: result.notes,
              ),
            ),
          );
        });

        await jobProvider.modifyPayments(reference: widget.job.reference, payments: _payments);
      } catch (error, stackTrace) {
        AppLog.e(error, stackTrace);
      }
    }
  }
}

class _NewGrid extends StatelessWidget {
  const _NewGrid({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: PaymentGridItem.kGridWidth,
      margin: const EdgeInsets.only(right: 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        color: colorScheme.outlineVariant,
        child: InkWell(
          onTap: onPressed,
          child: const Icon(Icons.note_add),
        ),
      ),
    );
  }
}
