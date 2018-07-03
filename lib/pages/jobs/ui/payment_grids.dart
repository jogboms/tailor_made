import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/pages/jobs/models/job.model.dart';
import 'package:tailor_made/pages/payments/models/payment.model.dart';
import 'package:tailor_made/ui/blank.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

const _kGridWidth = 120.0;

class PaymentGrid extends StatelessWidget {
  final PaymentModel payment;

  PaymentGrid({
    Key key,
    this.payment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: _kGridWidth,
      margin: EdgeInsets.only(right: 8.0),
      child: new Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(5.0),
        color: accentColor.withOpacity(.8),
        child: new InkWell(
          onTap: () => TMNavigate(context, BlankPage(), fullscreenDialog: true),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Align(
                  alignment: Alignment.topRight,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: "15", style: ralewayLight(24.0, Colors.white)),
                        TextSpan(text: "\n"),
                        TextSpan(text: "MAY, 2018", style: ralewayMedium(10.0, Colors.white)),
                      ],
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                Text(
                  "₦15,000",
                  style: ralewayBold(24.0, Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentGrids extends StatelessWidget {
  final JobModel job;

  PaymentGrids({
    Key key,
    @required this.job,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    List<Widget> paymentList = job.payments.map((payment) {
      return PaymentGrid(
        payment: payment,
      );
    }).toList();

    return new Column(
      children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text("Payments", style: theme.titleStyle),
            ),
            CupertinoButton(
              child: Text("SHOW ALL", style: ralewayRegular(11.0, textBaseColor)),
              onPressed: () => TMNavigate(context, BlankPage(), fullscreenDialog: true),
            ),
          ],
        ),
        new Container(
          height: _kGridWidth + 8,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: new ListView(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            scrollDirection: Axis.horizontal,
            children: [PaymentGrids.newGrid()]..addAll(paymentList),
          ),
        ),
      ],
    );
  }

  static Widget newGrid() {
    return new Container(
      width: _kGridWidth,
      margin: EdgeInsets.only(right: 8.0),
      child: new Material(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.grey[100],
        child: new InkWell(
          onTap: () {},
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
