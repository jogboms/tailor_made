import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/pages/jobs/models/job.model.dart';
import 'package:tailor_made/pages/jobs/ui/payment_grid_item.dart';
import 'package:tailor_made/pages/payments/models/payment.model.dart';
import 'package:tailor_made/pages/payments/payments.dart';
import 'package:tailor_made/pages/payments/payments_create.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

const _kGridWidth = 120.0;

class FirePayment {
  StorageReference ref;
  PaymentModel payment;
  bool isLoading = true;
  bool isSucess = false;
}

class PaymentGrids extends StatefulWidget {
  final Size gridSize;
  final JobModel job;

  PaymentGrids({
    Key key,
    double gridSize,
    @required this.job,
  })  : gridSize = Size.square(gridSize ?? _kGridWidth),
        super(key: key);

  @override
  PaymentGridsState createState() {
    return new PaymentGridsState();
  }
}

class PaymentGridsState extends State<PaymentGrids> {
  List<FirePayment> firePayments = [];

  @override
  initState() {
    super.initState();
    firePayments = widget.job.payments.map((payment) => FirePayment()..payment = payment).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> paymentsList = List.generate(
      firePayments.length,
      (int index) {
        final fireImage = firePayments[index];
        final payment = fireImage.payment;

        if (payment == null) {
          return Center(widthFactor: 2.5, child: loadingSpinner());
        }

        return PaymentGridItem(payment: payment);
      },
    ).toList();

    return new Column(
      children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(width: 16.0),
            Expanded(child: Text("PAYMENTS", style: ralewayRegular(12.0, Colors.black87))),
            CupertinoButton(
              child: Text("SHOW ALL", style: ralewayRegular(11.0, textBaseColor)),
              onPressed: () => TMNavigate(context, PaymentsPage(payments: widget.job.payments), fullscreenDialog: true),
            ),
          ],
        ),
        new Container(
          height: _kGridWidth + 8,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: new ListView(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            scrollDirection: Axis.horizontal,
            // children: [newGrid(context)]..addAll(
            //     widget.job.payments.map((payment) {
            //       return PaymentGridItem(payment: payment);
            //     }).toList(),
            //   ),
            children: [newGrid(widget.gridSize)]..addAll(paymentsList.reversed.toList()),
            // children: [newGrid(widget.job.contact, widget.gridSize)]..addAll(imagesList.reversed.toList()),
          ),
        ),
      ],
    );
  }

  Widget newGrid(Size gridSize) {
    return new Container(
      width: _kGridWidth,
      margin: EdgeInsets.only(right: 8.0),
      child: new Material(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.grey[100],
        child: new InkWell(
          onTap: () async {
            final result = await Navigator.push<Map<String, dynamic>>(
              context,
              TMNavigate.fadeIn<Map<String, dynamic>>(PaymentsCreatePage()),
            );
            if (result != null) {
              setState(() {
                firePayments.add(FirePayment());
              });

              try {
                setState(() {
                  firePayments.last
                    ..isLoading = false
                    ..isSucess = true
                    ..payment = new PaymentModel(
                      contactID: widget.job.contactID,
                      price: result["price"],
                      notes: result["notes"],
                    );

                  widget.job.reference.updateData({
                    "payments": firePayments.map((payment) => payment.payment.toMap()).toList(),
                  });
                });
              } catch (e) {
                setState(() {
                  firePayments.last.isLoading = false;
                });
                print(e);
              }
            }
          },
          child: Icon(
            Icons.note_add,
            size: 30.0,
            color: textBaseColor.withOpacity(.35),
          ),
        ),
      ),
    );
  }
}
