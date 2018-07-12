import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/pages/homepage/homepage.dart';
import 'package:tailor_made/services/auth.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_images.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_snackbar.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class SplashPage extends StatefulWidget {
  final bool isColdStart;

  SplashPage({
    Key key,
    @required this.isColdStart,
  }) : super(key: key);

  @override
  State createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SnackBarProvider {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = widget.isColdStart;

    if (widget.isColdStart == true) {
      _trySilent();
    }

    Auth.onAuthStateChanged.firstWhere((user) => user != null).then(
      (user) {
        Navigator.pushReplacement(context, TMNavigate.fadeIn(new HomePage()));
      },
    );
  }

  _trySilent() async {
    // Give the navigation animations, etc, some time to finish
    await new Future.delayed(new Duration(seconds: 1)).then((_) => _onLogin());
  }

  _onLogin() async => await Auth.signInWithGoogle();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Opacity(
            opacity: .5,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: TMImages.pattern,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Text("TailorMade", style: ralewayMedium(24.0)),
            ),
          ),
          isLoading && widget.isColdStart
              ? SizedBox()
              : Center(
                  child: Image(
                    image: TMImages.logo,
                    width: 148.0,
                    color: Colors.white.withOpacity(.35),
                    colorBlendMode: BlendMode.saturation,
                  ),
                ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 96.0),
              child: isLoading
                  ? loadingSpinner()
                  : RaisedButton(
                      color: Colors.white,
                      onPressed: () {
                        setState(() => isLoading = true);
                        try {
                          _onLogin();
                        } catch (e) {
                          setState(() => isLoading = false);
                          showInSnackBar(e.toString());
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image(
                            image: TMImages.google_logo,
                            width: 24.0,
                          ),
                          const SizedBox(width: 8.0),
                          Text("Continue with Google"),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
