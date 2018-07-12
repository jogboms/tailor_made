import 'package:flutter/material.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/services/cloudstore.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_format_date.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    return new StreamBuilder(
      stream: Cloudstore.account.snapshots(),
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: loadingSpinner(),
          );
        }

        final account = AccountModel.fromDoc(snapshot.data);

        return Container(
          padding: EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 40.0),
          width: double.infinity,
          decoration: new BoxDecoration(
            border: new Border(
              bottom: TMBorderSide(),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Text(
                "Hello",
                style: new TextStyle(
                  color: theme.textColor,
                  fontSize: 32.0,
                  fontWeight: FontWeight.w200,
                  letterSpacing: 2.5,
                ),
              ),
              new Text(
                account.displayName.split(" ").first,
                style: new TextStyle(
                  color: theme.textColor,
                  fontSize: 52.0,
                  fontWeight: FontWeight.w300,
                  height: 1.15,
                ),
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
              new Text(
                formatDate(DateTime.now(), day: "EEEE", month: "MMMM"),
                style: new TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w300,
                  height: 1.75,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
