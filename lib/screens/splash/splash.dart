import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/constants/mk_images.dart';
import 'package:tailor_made/constants/mk_strings.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/providers/snack_bar_provider.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/auth/actions.dart';
import 'package:tailor_made/rebloc/settings/actions.dart';
import 'package:tailor_made/rebloc/settings/view_model.dart';
import 'package:tailor_made/repository/models.dart';
import 'package:tailor_made/utils/ui/mk_status_bar.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key key, @required this.isColdStart, @required this.version})
      : assert(version != null),
        super(key: key);

  final bool isColdStart;
  final String version;

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
                  Text(
                    "v$version",
                    style: theme.small.copyWith(color: kTextBaseColor.withOpacity(.4), height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            StreamBuilder<User>(
              // TODO: move this out of here
              stream: Dependencies.di().accounts.onAuthStateChanged,
              builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                if (snapshot.hasData && snapshot.data != null && snapshot.data?.uid != null) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) async {
                      StoreProvider.of<AppState>(context).dispatch(OnLoginAction(snapshot.data));
                      Dependencies.di().sharedCoordinator.toHome(version);
                    },
                  );

                  return const SizedBox();
                }

                return _Content(isColdStart: isColdStart);
              },
            ),
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

  @override
  void initState() {
    super.initState();
    isLoading = widget.isColdStart;
    if (widget.isColdStart) {
      _onLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelSubscriber<AppState, SettingsViewModel>(
      converter: (store) => SettingsViewModel(store),
      builder: (BuildContext context, DispatchFunction dispatch, SettingsViewModel vm) {
        return Stack(
          children: [
            if (!isLoading || !widget.isColdStart || vm.hasError)
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
                if ((vm.isLoading && widget.isColdStart) || isLoading) {
                  return const MkLoadingSpinner();
                }

                if (vm.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 16.0),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Text(vm.error.toString(), textAlign: TextAlign.center),
                          const SizedBox(height: 8.0),
                          RaisedButton(
                            color: Colors.white,
                            child: Text(
                              "RETRY",
                              style: ThemeProvider.of(context).button.copyWith(color: kTextBaseColor),
                            ),
                            onPressed: () => dispatch(const InitSettingsAction()),
                          ),
                        ],
                      ),
                    ),
                  );
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

  void _onLogin() async {
    try {
      setState(() => isLoading = true);
      // TODO: move this out of here
      await Dependencies.di().accounts.signInWithGoogle();
    } catch (e) {
      // TODO: move this out of here
      final message = MkStrings.genericError(e, Dependencies.di().session.isDev);

      if (message.isNotEmpty) {
        SnackBarProvider.of(context).show(message, duration: const Duration(milliseconds: 3500));
      }

      // TODO: move this out of here
      await Dependencies.di().accounts.signout();

      if (!mounted) {
        return;
      }

      setState(() => isLoading = false);

      SnackBarProvider.of(context).show(e.toString());
    }
  }
}
