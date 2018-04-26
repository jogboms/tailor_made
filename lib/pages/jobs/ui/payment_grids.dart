import 'package:flutter/material.dart';
import 'package:tailor_made/utils/tm_theme.dart';
import 'package:tailor_made/ui/blank.dart';
import 'package:tailor_made/utils/tm_navigate.dart';

class PaymentGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 100.0,
      margin: EdgeInsets.only(right: 8.0),
      child: new Material(
        borderRadius: BorderRadius.circular(5.0),
        color: accentColor.withOpacity(.8),
        child: new InkWell(
          onTap: () => TMNavigate(context, BlankPage(), fullscreenDialog: true),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "15", style: ralewayLight(25.0, Colors.white)),
                      TextSpan(text: "\n"),
                      TextSpan(text: "MAY, 2018", style: ralewayMedium(10.0, Colors.white)),
                    ],
                  ),
                ),
                Text(
                  "\$15,000",
                  style: ralewayBold(20.0, Colors.white).copyWith(
                    height: 1.25,
                  ),
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
  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);
    List<Widget> paymentList = List
        .generate(
          10,
          (int index) => PaymentGrid(),
        )
        .toList();

    return new Column(
      children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Payments", style: theme.titleStyle),
            ),
            FlatButton(
              padding: const EdgeInsets.all(8.0),
              child: Text("SHOW ALL"),
              onPressed: () => TMNavigate(context, BlankPage(), fullscreenDialog: true),
            ),
          ],
        ),
        new Container(
          padding: const EdgeInsets.all(8.0),
          height: 120.0,
          child: new ListView(
            scrollDirection: Axis.horizontal,
            children: [PaymentGrids.newGrid()]..addAll(paymentList),
          ),
        ),
      ],
    );
  }

  static Widget newGrid() {
    return new Container(
      width: 100.0,
      margin: EdgeInsets.only(right: 8.0),
      child: new Material(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.grey[100],
        child: new InkWell(
          onTap: () {},
          child: Icon(
            Icons.add_circle_outline,
            size: 30.0,
            color: textBaseColor.withOpacity(.35),
          ),
        ),
      ),
    );
  }
}
