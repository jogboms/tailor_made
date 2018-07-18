import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class AccessDeniedPage extends StatelessWidget {
  final VoidCallback onSendMail;

  const AccessDeniedPage({
    Key key,
    @required this.onSendMail,
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
            "ACCESS DENIED",
            style: textTheme.copyWith(color: Colors.black87, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64.0),
            child: Text(
              "Do not be alarmed. \n We just need your attention. \n\n It is possible you have violated one or a couple of our usage policy?\n or you are running an outdated version of the app.\n If none of this is the case, please contact an Administrator.",
              style: textTheme.copyWith(color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 32.0),
          RaisedButton.icon(
            color: kAccentColor,
            shape: StadiumBorder(),
            colorBrightness: Brightness.dark,
            onPressed: onSendMail,
            icon: Icon(Icons.mail),
            label: Text("Send a mail"),
          ),
        ],
      ),
    );
  }
}
