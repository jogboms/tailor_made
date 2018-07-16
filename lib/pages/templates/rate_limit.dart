import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class RateLimitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: kBackgroundBaseColor,
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SpinKitFadingCube(
              color: Colors.grey.shade300,
            ),
            SizedBox(height: 48.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64.0),
              child: Text(
                "We noticed \n you really enjoy using our service. \n\n Would you mind \n paying a little token if you wish to extend beyond our usage policy?",
                style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 32.0),
            FlatButton(
              onPressed: () {},
              textColor: Colors.grey.shade500,
              child: Text("No, Skip now"),
            ),
            SizedBox(height: 8.0),
            RaisedButton.icon(
              color: kAccentColor,
              shape: StadiumBorder(),
              colorBrightness: Brightness.dark,
              onPressed: () {},
              icon: Icon(Icons.done),
              label: Text("Yes, Sign me up!"),
            ),
          ],
        ),
      ),
    );
  }
}
