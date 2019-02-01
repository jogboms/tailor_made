import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:tailor_made/utils/mk_snackbar.dart';
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/_partials/mk_raised_button.dart';
import 'package:tailor_made/widgets/screens/homepage/homepage.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({
    Key key,
    @required this.isColdStart,
  }) : super(key: key);

  final bool isColdStart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const Opacity(
            opacity: .5,
            child: const DecoratedBox(
              decoration: const BoxDecoration(
                image: const DecorationImage(
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
                      // TODO
                      mkFontMedium(22.0, kTextBaseColor.withOpacity(.6)),
                  textAlign: TextAlign.center,
                ),
                Settings.getVersion() != null
                    ? Text(
                        "v" + Settings.getVersion(),
                        // TODO
                        style:
                            mkFontMedium(12.0, kTextBaseColor.withOpacity(.4))
                                .copyWith(height: 1.5),
                        textAlign: TextAlign.center,
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          Positioned(
            height: 124.0,
            bottom: 72.0,
            left: 0.0,
            right: 0.0,
            child: _Content(isColdStart: isColdStart),
          ),
        ],
      ),
    );
  }
}

class _Content extends StatefulWidget {
  const _Content({
    Key key,
    @required this.isColdStart,
  }) : super(key: key);

  final bool isColdStart;

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  bool isLoading;
  bool isRestartable = false;

  @override
  void initState() {
    super.initState();
    isLoading = widget.isColdStart;

    Auth.onAuthStateChanged.firstWhere((user) => user != null).then(
      (user) {
        Auth.setUser(user);
        Navigator.pushReplacement<String, dynamic>(
          context,
          MkNavigate.fadeIn<String>(const HomePage()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelSubscriber<AppState, SettingsViewModel>(
      converter: (store) => SettingsViewModel(store),
      builder: (
        BuildContext context,
        DispatchFunction dispatcher,
        SettingsViewModel vm,
      ) {
        return Stack(
          children: [
            _isImageVisible(vm)
                ? const SizedBox()
                : const Center(
                    child: const Image(
                      image: MkImages.logo,
                      width: 148.0,
                      color: Colors.white30,
                      colorBlendMode: BlendMode.saturation,
                    ),
                  ),
            Builder(
              builder: (_) {
                if (vm.isLoading && widget.isColdStart) {
                  return Center(
                    child: const MkLoadingSpinner(),
                  );
                }

                if (vm.hasError) {
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
                          const SizedBox(height: 8.0),
                          MkRaisedButton(
                            backgroundColor: Colors.white,
                            color: kTextBaseColor,
                            onPressed: () =>
                                dispatcher(const InitSettingsEvents()),
                            child: const Text("RETRY"),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (widget.isColdStart && !isRestartable) {
                  _tryLoginSilent();
                }

                if (isLoading) {
                  const MkLoadingSpinner();
                }

                return Center(
                  child: RaisedButton.icon(
                    color: Colors.white,
                    onPressed: () {
                      setState(() => isLoading = true);
                      try {
                        _onLogin();
                      } catch (e) {
                        setState(() => isLoading = false);
                        MkSnackBar.of(context).show(e.toString());
                      }
                    },
                    icon: const Image(
                      image: MkImages.google_logo,
                      width: 24.0,
                    ),
                    label: Text(
                      "Continue with Google",
                      style: MkTheme.of(context).bodyBold,
                    ),
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }

  Future<void> _tryLoginSilent() async {
    // Give the navigation animations, etc, some time to finish
    await Future<dynamic>.delayed(Duration(seconds: 1)).then(
      (dynamic _) => _onLogin(),
    );
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
        MkSnackBar.of(context).show(
          message,
          duration: const Duration(milliseconds: 3500),
        );
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

  bool _isImageVisible(SettingsViewModel vm) {
    return isLoading && (widget.isColdStart || isRestartable) && !vm.hasError;
  }
}
