import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';
import 'package:uuid/uuid.dart';

import 'payment_grid_item.dart';

class PaymentGrids extends StatefulWidget {
  PaymentGrids({super.key, double? gridSize, required this.job, required this.userId})
      : gridSize = Size.square(gridSize ?? _kGridWidth);

  final Size gridSize;
  final JobEntity job;
  final String userId;

  @override
  State<PaymentGrids> createState() => _PaymentGridsState();
}

class _PaymentGridsState extends State<PaymentGrids> {
  List<_FirePayment> _firePayments = <_FirePayment>[];

  @override
  void initState() {
    super.initState();
    _firePayments = widget.job.payments.map((PaymentEntity payment) => _FirePayment()..payment = payment).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider theme = ThemeProvider.of(context);
    final List<Widget> paymentsList = List<Widget>.generate(
      _firePayments.length,
      (int index) {
        final _FirePayment fireImage = _firePayments[index];
        final PaymentEntity? payment = fireImage.payment;

        if (payment == null) {
          return const Center(widthFactor: 2.5, child: LoadingSpinner());
        }

        return PaymentGridItem(payment: payment);
      },
    ).reversed.toList();

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
              onPressed: () {
                context.registry.get<PaymentsCoordinator>().toPayments(widget.userId, widget.job.payments.toList());
              },
            ),
            const SizedBox(width: 16.0),
          ],
        ),
        Container(
          height: _kGridWidth + 8,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              _NewGrid(gridSize: widget.gridSize, onPressed: _onCreateNew),
              ...paymentsList,
            ],
          ),
        ),
      ],
    );
  }

  void _onCreateNew() async {
    final Registry registry = context.registry;
    final Map<String, dynamic>? result =
        await registry.get<PaymentsCoordinator>().toCreatePayment(widget.job.pendingPayment);
    if (result != null) {
      setState(() {
        _firePayments.add(_FirePayment());
      });

      try {
        setState(() {
          final String id = const Uuid().v4();
          _firePayments.last.payment = PaymentEntity(
            reference: ReferenceEntity(
              id: id,
              path: id, // TODO
            ),
            id: id,
            userID: widget.userId,
            contactID: widget.job.contactID,
            jobID: widget.job.id,
            price: result['price'] as double? ?? 0.0,
            notes: result['notes'] as String? ?? '',
            createdAt: DateTime.now(),
          );
        });

        await registry.get<Jobs>().update(
              widget.job.userID,
              reference: widget.job.reference,
              payments: _firePayments
                  .map((_FirePayment payment) => payment.payment)
                  .whereType<PaymentEntity>()
                  .toList(growable: false),
            );

        setState(() {
          _firePayments.last
            ..isLoading = false
            ..isSucess = true;
        });
      } catch (e) {
        setState(() {
          _firePayments.last.isLoading = false;
        });
      }
    }
  }
}

class _NewGrid extends StatelessWidget {
  const _NewGrid({
    required this.gridSize,
    required this.onPressed,
  });

  final Size gridSize;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _kGridWidth,
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

const double _kGridWidth = 120.0;

class _FirePayment {
  PaymentEntity? payment;
  bool isLoading = true;
  bool isSucess = false;
}
