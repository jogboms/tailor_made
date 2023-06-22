import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key, required this.isColdStart, required this.isMock});

  final bool isColdStart;
  final bool isMock;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider theme = ThemeProvider.of(context);

    return AppStatusBar(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            const Opacity(
              opacity: .5,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(image: AppImages.pattern, fit: BoxFit.cover),
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
                    context.l10n.appName,
                    style: theme.display2Semi.copyWith(color: kTextBaseColor.withOpacity(.6)),
                    textAlign: TextAlign.center,
                  ),
                  AppVersionBuilder(
                    valueBuilder: () => AppVersion.retrieve(isMock),
                    builder: (_, String? version, __) => Text(
                      'v$version',
                      style: theme.small.copyWith(color: kTextBaseColor.withOpacity(.4), height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<String?>(
              // TODO(Jogboms): move this out of here
              stream: context.registry.get<Accounts>().onAuthStateChanged,
              builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                final String? data = snapshot.data;
                if (data != null) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) async {
                      StoreProvider.of<AppState>(context).dispatch(AuthAction.login(data));
                      context.registry.get<SharedCoordinator>().toHome(isMock);
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
  const _Content({required this.isColdStart});

  final bool isColdStart;

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = widget.isColdStart;
    if (widget.isColdStart) {
      _onLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelSubscriber<AppState, SettingsViewModel>(
      converter: SettingsViewModel.new,
      builder: (BuildContext context, DispatchFunction dispatch, SettingsViewModel vm) {
        return Stack(
          children: <Widget>[
            if (!_isLoading || !widget.isColdStart || vm.hasError)
              const Center(
                child: Image(
                  image: AppImages.logo,
                  width: 148.0,
                  color: Colors.white30,
                  colorBlendMode: BlendMode.saturation,
                ),
              ),
            Positioned.fill(
              top: null,
              bottom: 124.0,
              child: Builder(
                builder: (_) {
                  if ((vm.isLoading && widget.isColdStart) || _isLoading) {
                    return const LoadingSpinner();
                  }

                  if (vm.hasError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 16.0),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Text(vm.error.toString(), textAlign: TextAlign.center),
                            const SizedBox(height: 8.0),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              child: Text(
                                'RETRY',
                                style: ThemeProvider.of(context).button.copyWith(color: kTextBaseColor),
                              ),
                              onPressed: () => dispatch(const SettingsAction.init()),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      icon: const Image(image: AppImages.googleLogo, width: 24.0),
                      label: Text('Continue with Google', style: ThemeProvider.of(context).bodyBold),
                      onPressed: _onLogin,
                    ),
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }

  void _onLogin() async {
    final Accounts accounts = context.registry.get();
    try {
      setState(() => _isLoading = true);
      // TODO(Jogboms): move this out of here
      await accounts.signInWithGoogle();
    } catch (error, stackTrace) {
      AppLog.e(error, stackTrace);
      if (!mounted) {
        return;
      }

      // TODO(Jogboms): move this out of here
      final Environment environment = context.registry.get();
      final String message = AppStrings.genericError(error, environment.isDev)!;

      if (message.isNotEmpty) {
        AppSnackBar.of(context).error(message, duration: const Duration(milliseconds: 3500));
      }

      // TODO(Jogboms): move this out of here
      await accounts.signOut();

      if (!mounted) {
        return;
      }

      setState(() => _isLoading = false);

      AppSnackBar.of(context).error(error.toString());
    }
  }
}
