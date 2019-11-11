import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/screens/jobs/_partials/payment_grid_item.dart';
import 'package:tailor_made/screens/payments/payments.dart';
import 'package:tailor_made/screens/payments/payments_create.dart';
import 'package:tailor_made/widgets/_partials/mk_clear_button.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/theme_provider.dart';
import 'package:tailor_made/wrappers/mk_navigate.dart';

const _kGridWidth = 120.0;

class FirePayment {
  PaymentModel payment;
  bool isLoading = true;
  bool isSucess = false;
}

class PaymentGrids extends StatefulWidget {
  PaymentGrids({
    Key key,
    double gridSize,
    @required this.job,
  })  : gridSize = Size.square(gridSize ?? _kGridWidth),
        super(key: key);

  final Size gridSize;
  final JobModel job;

  @override
  _PaymentGridsState createState() => _PaymentGridsState();
}

class _PaymentGridsState extends State<PaymentGrids> {
  List<FirePayment> firePayments = [];

  @override
  void initState() {
    super.initState();
    firePayments = widget.job.payments.map((payment) => FirePayment()..payment = payment).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);
    final List<Widget> paymentsList = List<Widget>.generate(
      firePayments.length,
      (int index) {
        final fireImage = firePayments[index];
        final payment = fireImage.payment;

        if (payment == null) {
          return const Center(
            widthFactor: 2.5,
            child: MkLoadingSpinner(),
          );
        }

        return PaymentGridItem(payment: payment);
      },
    ).toList();

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(width: 16.0),
            Expanded(
              child: Text(
                "PAYMENTS",
                style: theme.small.copyWith(
                  color: Colors.black87,
                ),
              ),
            ),
            MkClearButton(
              child: Text("SHOW ALL", style: theme.smallBtn),
              onPressed: () {
                Navigator.of(context).push<void>(MkNavigate.slideIn(
                  PaymentsPage(payments: widget.job.payments),
                  fullscreenDialog: true,
                ));
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
            children: [
              _NewGrid(
                gridSize: widget.gridSize,
                onPressed: _onCreateNew,
              )
            ]..addAll(paymentsList.reversed.toList()),
          ),
        ),
      ],
    );
  }

  void _onCreateNew() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MkNavigate.fadeIn<Map<String, dynamic>>(
        PaymentsCreatePage(
          limit: widget.job.pendingPayment,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        firePayments.add(FirePayment());
      });

      try {
        setState(() {
          firePayments.last.payment = PaymentModel(
            contactID: widget.job.contactID,
            jobID: widget.job.id,
            price: result["price"],
            notes: result["notes"],
          );
        });

        await widget.job.reference.updateData(<String, List<Map<String, dynamic>>>{
          "payments": firePayments.map((payment) => payment.payment.toMap()).toList(),
        });

        setState(() {
          firePayments.last
            ..isLoading = false
            ..isSucess = true;
        });
      } catch (e) {
        setState(() {
          firePayments.last.isLoading = false;
        });
      }
    }
  }
}

class _NewGrid extends StatelessWidget {
  const _NewGrid({
    Key key,
    @required this.gridSize,
    @required this.onPressed,
  }) : super(key: key);

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
