import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/pages/payments/models/payment.model.dart';
import 'package:tailor_made/pages/payments/payments_list.dart';
import 'package:tailor_made/services/cloudstore.dart';
import 'package:tailor_made/ui/back_button.dart';
import 'package:tailor_made/ui/tm_empty_result.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class PaymentsPage extends StatefulWidget {
  final List<PaymentModel> payments;

  PaymentsPage({
    Key key,
    this.payments,
  }) : super(key: key);

  @override
  PaymentsPageState createState() {
    return new PaymentsPageState();
  }
}

class PaymentsPageState extends State<PaymentsPage> {
  List<PaymentModel> payments;

  @override
  void initState() {
    payments = widget.payments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    return new Scaffold(
      backgroundColor: theme.scaffoldColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Payments", style: theme.appBarStyle),
                payments != null
                    ? Text(
                        "${payments.length} Tickets",
                        style: TextStyle(
                          fontSize: 11.0,
                          color: textBaseColor,
                        ),
                      )
                    : SizedBox(),
              ],
            ),
            backgroundColor: theme.appBarBackgroundColor,
            automaticallyImplyLeading: false,
            leading: backButton(context),
            forceElevated: true,
            brightness: Brightness.light,
            elevation: 1.0,
            centerTitle: false,
            floating: true,
          ),
          getBody()
        ],
      ),
    );
  }

  getContent() {
    return payments.isEmpty
        ? SliverFillRemaining(
            child: TMEmptyResult(message: "No payments available"),
          )
        : SliverPadding(
            padding: EdgeInsets.only(top: 3.0, left: 16.0, right: 16.0, bottom: 16.0),
            sliver: PaymentList(payments: payments),
          );
  }

  getBody() {
    if (payments == null) {
      return new StreamBuilder(
        stream: Cloudstore.payments.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return SliverFillRemaining(
              child: loadingSpinner(),
            );
          }
          payments = snapshot.data.documents
              .map(
                (item) => PaymentModel.fromJson(item.data),
              )
              .toList();
          return getContent();
        },
      );
    }
    return getContent();
  }
}
