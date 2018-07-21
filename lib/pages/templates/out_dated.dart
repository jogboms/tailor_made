import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class OutDatedPage extends StatelessWidget {
  final VoidCallback onUpdate;

  const OutDatedPage({
    Key key,
    @required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.subhead;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SpinKitFadingCube(
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 48.0),
          Text(
            "OUTDATED NOTICE",
            style: textTheme.copyWith(
                color: Colors.black87, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64.0),
            child: Text(
              "It appears you are running an outdated version of the app.\n If this is the case, please contact an Administrator.",
              style: textTheme.copyWith(color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 32.0),
          RaisedButton.icon(
            color: kAccentColor,
            shape: StadiumBorder(),
            colorBrightness: Brightness.dark,
            onPressed: onUpdate,
            icon: Icon(Icons.get_app),
            label: Text("Get Update"),
          ),
        ],
      ),
    );
  }
}
