import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/utils/mk_dates.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key key,
    @required this.account,
  }) : super(key: key);

  final AccountModel account;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 40.0),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: MkBorderSide(),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            "Hello",
            style: TextStyle(
              color: kTextBaseColor,
              fontSize: 32.0,
              fontWeight: FontWeight.w200,
              letterSpacing: 2.5,
            ),
          ),
          Text(
            account.storeName.split(" ").first,
            style: TextStyle(
              color: kTextBaseColor,
              fontSize: 52.0,
              fontWeight: FontWeight.w300,
              height: 1.15,
            ),
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
          Text(
            MkDates(DateTime.now(), day: "EEEE", month: "MMMM").format,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w300,
              height: 1.75,
            ),
          ),
        ],
      ),
    );
  }
}
