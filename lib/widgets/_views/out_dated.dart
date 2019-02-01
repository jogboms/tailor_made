import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/utils/mk_theme.dart';

class OutDatedPage extends StatelessWidget {
  const OutDatedPage({
    Key key,
    @required this.onUpdate,
  }) : super(key: key);

  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    final textTheme = MkTheme.of(context).subhead1;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SpinKitFadingCube(
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 48.0),
          Text(
            "OUT OF DATE",
            style: textTheme.copyWith(
              color: Colors.black87,
              fontWeight: MkStyle.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64.0),
            child: Text(
              "It appears you are running an outdated version of the app.\n If this is not the case, please contact an Administrator.",
              style: textTheme.copyWith(color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32.0),
          RaisedButton.icon(
            color: kAccentColor,
            shape: const StadiumBorder(),
            colorBrightness: Brightness.dark,
            onPressed: onUpdate,
            icon: const Icon(Icons.get_app),
            label: const Text("Get Update"),
          ),
        ],
      ),
    );
  }
}
