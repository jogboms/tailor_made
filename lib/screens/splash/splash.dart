import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/constants/mk_images.dart';
import 'package:tailor_made/constants/mk_strings.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/providers/snack_bar_provider.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/auth/actions.dart';
import 'package:tailor_made/rebloc/settings/actions.dart';
import 'package:tailor_made/rebloc/settings/view_model.dart';
import 'package:tailor_made/screens/homepage/homepage.dart';
import 'package:tailor_made/services/accounts/accounts.dart';
import 'package:tailor_made/services/session.dart';
import 'package:tailor_made/utils/ui/app_version_builder.dart';
import 'package:tailor_made/utils/ui/mk_status_bar.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/_partials/mk_raised_button.dart';
import 'package:tailor_made/widgets/theme_provider.dart';
import 'package:tailor_made/wrappers/mk_navigate.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key key, @required this.isColdStart}) : super(key: key);

  final bool isColdStart;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);

    return MkStatusBar(
      brightness: Brightness.dark,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            const Opacity(
              opacity: .5,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(image: MkImages.pattern, fit: BoxFit.cover),
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
                    style: theme.display2Semi.copyWith(color: kTextBaseColor.withOpacity(.6)),
                    textAlign: TextAlign.center,
                  ),
                  AppVersionBuilder(
                    valueBuilder: () => AppVersion.retrieve(Session.di().isMock),
                    builder: (_, version, __) => Text(
                      "v$version",
                      style: theme.small.copyWith(color: kTextBaseColor.withOpacity(.4), height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            _Content(isColdStart: isColdStart),
          ],
        ),
      ),
    );
  }
}

class _Content extends StatefulWidget {
  const _Content({Key key, @required this.isColdStart}) : super(key: key);

  final bool isColdStart;

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  bool isLoading;
  bool canRestartSignin = false;

  @override
  void initState() {
    super.initState();
    isLoading = widget.isColdStart;

    Accounts.di().onAuthStateChanged.then((user) => WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            StoreProvider.of<AppState>(context).dispatch(OnLoginAction(user));
            await Navigator.of(context).pushAndRemoveUntil<void>(
              MkNavigate.fadeIn<void>(const HomePage()),
              (Route<void> route) => false,
            );
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelSubscriber<AppState, SettingsViewModel>(
      converter: (store) => SettingsViewModel(store),
      builder: (BuildContext context, DispatchFunction dispatch, SettingsViewModel vm) {
        return Stack(
          children: [
            if (!(isLoading && (widget.isColdStart || canRestartSignin) && !vm.hasError))
              const Center(
                child: Image(
                  image: MkImages.logo,
                  width: 148.0,
                  color: Colors.white30,
                  colorBlendMode: BlendMode.saturation,
                ),
              ),
            Positioned.fill(
              top: null,
              bottom: 124.0,
              child: Builder(builder: (_) {
                if (vm.isLoading && widget.isColdStart) {
                  return const MkLoadingSpinner();
                }

                if (vm.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 16.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          const Text(
                            "You need a stable internet connection to proceed.",
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8.0),
                          MkRaisedButton(
                            backgroundColor: Colors.white,
                            color: kTextBaseColor,
                            onPressed: () => dispatch(const InitSettingsAction()),
                            child: const Text("RETRY"),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (widget.isColdStart && !canRestartSignin) {
                  WidgetsBinding.instance.addPostFrameCallback((_) async => _onLogin());
                }

                if (isLoading) {
                  return const MkLoadingSpinner();
                }

                return Center(
                  child: RaisedButton.icon(
                    color: Colors.white,
                    icon: const Image(image: MkImages.google_logo, width: 24.0),
                    label: Text("Continue with Google", style: ThemeProvider.of(context).bodyBold),
                    onPressed: _onLogin,
                  ),
                );
              }),
            )
          ],
        );
      },
    );
  }

  Future<void> _onLogin() async {
    setState(() => isLoading = true);
    try {
      await Accounts.di().signInWithGoogle();
    } catch (e) {
      // TODO disabled
      String message = "";

      switch (e?.code) {
        case "exception":
        case "sign_in_failed":
          if (e?.message?.contains("administrator") ?? false) {
            message = "It seems this account has been disabled. Contact an Admin.";
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

        // ignore: no_duplicate_case_values
        fallthrough:
        case "sign_in_failed":
          message = "Sorry, We could not connect. Try again.";
          break;

        case "canceled":
        default:
      }

      if (message.isNotEmpty) {
        SnackBarProvider.of(context).show(
          message,
          duration: const Duration(milliseconds: 3500),
        );
      }

      await Accounts.di().signout();

      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
        canRestartSignin = true;
      });

      SnackBarProvider.of(context).show(e.toString());
    }
  }
}
