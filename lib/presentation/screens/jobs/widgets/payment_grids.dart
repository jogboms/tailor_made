import 'package:flutter/material.dart';
import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

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
  late final List<PaymentGridsFormValue> _firePayments = <PaymentGridsFormValue>[
    ...widget.job.payments.map(PaymentGridsModifyFormValue.new),
  ];

  @override
  void didUpdateWidget(covariant PaymentGrids oldWidget) {
    if (widget.job.payments != oldWidget.job.payments) {
      _firePayments
        ..clear()
        ..addAll(widget.job.payments.map(PaymentGridsModifyFormValue.new));
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider theme = ThemeProvider.of(context);

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(width: 16.0),
            Expanded(
              child: Text('PAYMENTS', style: theme.small.copyWith(color: Colors.black87)),
            ),
            AppClearButton(
              child: Text('SHOW ALL', style: theme.smallBtn),
              onPressed: () => context.registry.get<PaymentsCoordinator>().toPayments(
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
              _NewGrid(onPressed: _onCreateNew),
              for (final PaymentGridsFormValue value in _firePayments.reversed) PaymentGridItem(value: value)
            ],
          ),
        ),
      ],
    );
  }

  void _onCreateNew() async {
    final Registry registry = context.registry;
    final ({double price, String notes})? result = await registry.get<PaymentsCoordinator>().toCreatePayment(
          widget.job.pendingPayment,
        );
    if (result != null) {
      try {
        setState(() {
          _firePayments.add(
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

        await registry.get<Jobs>().update(
              widget.job.userID,
              reference: widget.job.reference,
              payments: _firePayments
                  .map(
                    (PaymentGridsFormValue input) => switch (input) {
                      PaymentGridsCreateFormValue() => CreatePaymentOperation(data: input.data),
                      PaymentGridsModifyFormValue() => ModifyPaymentOperation(data: input.data),
                    },
                  )
                  .toList(growable: false),
            );
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
    return Container(
      width: PaymentGridItem.kGridWidth,
      margin: const EdgeInsets.only(right: 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.grey[100],
        child: InkWell(
          onTap: onPressed,
          child: Icon(
            Icons.note_add,
            size: 30.0,
            color: kTextBaseColor.withOpacity(.35),
          ),
        ),
      ),
    );
  }
}
