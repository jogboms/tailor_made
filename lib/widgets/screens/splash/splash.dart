import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_version/get_version.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/constants/mk_images.dart';
import 'package:tailor_made/constants/mk_strings.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/rebloc/actions/settings.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/rebloc/view_models/settings.dart';
import 'package:tailor_made/services/auth.dart';
import 'package:tailor_made/services/settings.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/utils/mk_snackbar_provider.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/screens/homepage/homepage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    Key key,
    @required this.isColdStart,
  }) : super(key: key);

  final bool isColdStart;

  @override
  State createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with MkSnackBarProvider {
  bool isLoading;
  bool isRestartable = false;
  String projectVersion;

  @override
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    isLoading = widget.isColdStart;

    _getVersionName();

    Auth.onAuthStateChanged.listen((_) {
      //
      print(_);
    });

    Auth.onAuthStateChanged.firstWhere((user) => user != null).then(
      (user) {
        Auth.setUser(user);
        Navigator.pushReplacement<String, dynamic>(
          context,
          MkNavigate.fadeIn<String>(HomePage()),
        );
      },
    );
  }

  Future<void> _getVersionName() async {
    try {
      final _projectVersion = await GetVersion.projectVersion;
      Settings.setVersion(_projectVersion);
      if (!mounted) {
        return;
      }
      setState(() => projectVersion = _projectVersion);
    } catch (e) {
      //
    }
  }

  Future<void> _tryLoginSilent() async {
    // Give the navigation animations, etc, some time to finish
    await Future<dynamic>.delayed(Duration(seconds: 1))
        .then((dynamic _) => _onLogin());
  }

  Future<void> _onLogin() async {
    return await Auth.signInWithGoogle().catchError((dynamic e) async {
      // TODO disabled
      String message = "";

      switch (e?.code) {
        case "exception":
        case "sign_in_failed":
          if (e?.message?.contains("administrator") ?? false) {
            message =
                "It seems this account has been disabled. Contact an Admin.";
            break;
          }
          if (e?.message?.contains("NETWORK_ERROR") ?? false) {
            message = "Please check if you have your internet switched on.";
            break;
          }
          if (e?.message?.contains("network") ?? false) {
            message = "A stable internet connection is required.";
            break;
          }
          continue fallthrough;

        fallthrough:
        case "sign_in_failed":
          message = "Sorry, We could not connect. Try again.";
          break;

        case "canceled":
        default:
      }
      if (message.isNotEmpty) {
        showInSnackBar(message, const Duration(milliseconds: 3500));
      }
      await Auth.signOutWithGoogle();
      if (!mounted) {
        return;
      }
      setState(() {
        isLoading = false;
        isRestartable = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: FirstBuildDispatcher<AppState>(
        action: const InitSettingsEvents(),
        child: ViewModelSubscriber<AppState, SettingsViewModel>(
          converter: (store) => SettingsViewModel(store),
          builder: (
            BuildContext context,
            DispatchFunction dispatcher,
            SettingsViewModel vm,
          ) {
            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Opacity(
                  opacity: .5,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MkImages.pattern,
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
                        MkStrings.appName,
                        style:
                            mkFontMedium(22.0, kTextBaseColor.withOpacity(.6)),
                        textAlign: TextAlign.center,
                      ),
                      projectVersion != null
                          ? Text(
                              "v" + projectVersion,
                              style: mkFontMedium(
                                      12.0, kTextBaseColor.withOpacity(.4))
                                  .copyWith(height: 1.5),
                              textAlign: TextAlign.center,
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
                _isImageVisible(vm)
                    ? SizedBox()
                    : Center(
                        child: Image(
                          image: MkImages.logo,
                          width: 148.0,
                          color: Colors.white.withOpacity(.35),
                          colorBlendMode: BlendMode.saturation,
                        ),
                      ),
                Positioned(
                  height: 124.0,
                  bottom: 72.0,
                  left: 0.0,
                  right: 0.0,
                  child: _buildContent(
                    vm,
                    () => dispatcher(const InitSettingsEvents()),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  bool _isImageVisible(SettingsViewModel vm) {
    return isLoading && (widget.isColdStart || isRestartable) && !vm.hasError;
  }

  Widget _buildContent(SettingsViewModel vm, VoidCallback onRetry) {
    if (vm.isLoading && widget.isColdStart) {
      return Center(
        child: const MkLoadingSpinner(),
      );
    }

    if (vm.hasError) {
      return _buildFailure(vm, onRetry);
    }

    if (widget.isColdStart && !isRestartable) {
      _tryLoginSilent();
    }

    return isLoading ? const MkLoadingSpinner() : Center(child: _googleBtn());
  }

  Widget _buildFailure(SettingsViewModel vm, VoidCallback onRetry) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(48.0, 16.0, 48.0, 16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "You need a stable internet connection to proceed.",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.0),
            RaisedButton(
              color: Colors.white,
              onPressed: onRetry,
              child: Text("RETRY"),
            ),
          ],
        ),
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
      icon: Image(image: MkImages.google_logo, width: 24.0),
      label: Text(
        "Continue with Google",
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}
