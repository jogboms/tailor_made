import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_version/get_version.dart';
import 'package:tailor_made/pages/homepage/homepage.dart';
import 'package:tailor_made/services/auth.dart';
import 'package:tailor_made/services/cloud_db.dart';
import 'package:tailor_made/services/settings.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_images.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_snackbar.dart';
import 'package:tailor_made/utils/tm_strings.dart';
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
  bool isRestartable = false;
  String projectVersion;

  @override
  void initState() {
    super.initState();
    isLoading = widget.isColdStart;

    _getVersionName();

    if (widget.isColdStart == true) {
      _trySilent();
    }

    Auth.onAuthStateChanged.firstWhere((user) => user != null).then(
      (user) {
        Auth.setUser(user);
        Navigator.pushReplacement(context, TMNavigate.fadeIn(new HomePage()));
      },
    );
  }

  _getVersionName() async {
    try {
      projectVersion = await GetVersion.projectVersion;
      print(projectVersion);
    } catch (e) {}
  }

  _trySilent() async {
    // Give the navigation animations, etc, some time to finish
    await new Future.delayed(new Duration(seconds: 1)).then((_) => _onLogin());
  }

  _onLogin() async => await Auth.signInWithGoogle().catchError((e) async {
        showInSnackBar(e.message, const Duration(milliseconds: 3500));
        await Auth.signOutWithGoogle();
        if (!mounted) return;
        setState(() {
          isLoading = false;
          isRestartable = true;
        });
      });

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
          Positioned.fill(
            top: null,
            bottom: 32.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  TMStrings.appName,
                  style: ralewayMedium(22.0, kTextBaseColor.withOpacity(.6)),
                  textAlign: TextAlign.center,
                ),
                projectVersion != null
                    ? Text(
                        "v" + projectVersion,
                        style: ralewayMedium(12.0, kTextBaseColor.withOpacity(.4)).copyWith(height: 1.5),
                        textAlign: TextAlign.center,
                      )
                    : SizedBox(),
              ],
            ),
          ),
          isLoading && (widget.isColdStart || isRestartable)
              ? SizedBox()
              : Center(
                  child: Image(
                    image: TMImages.logo,
                    width: 148.0,
                    color: Colors.white.withOpacity(.35),
                    colorBlendMode: BlendMode.saturation,
                  ),
                ),
          Positioned(
            height: 96.0,
            bottom: 72.0,
            left: 0.0,
            right: 0.0,
            child: StreamBuilder(
              stream: CloudDb.settings.snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: loadingSpinner(),
                  );
                }

                Settings.setData(snapshot.data.data);

                return isLoading ? loadingSpinner() : Center(child: _googleBtn());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _googleBtn() {
    return RaisedButton.icon(
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
      icon: Image(image: TMImages.google_logo, width: 24.0),
      label: Text("Continue with Google", style: TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}
