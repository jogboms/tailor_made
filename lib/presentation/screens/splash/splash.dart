import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_made/core.dart';

import '../../constants.dart';
import '../../coordinator.dart';
import '../../registry.dart';
import '../../state.dart';
import '../../theme.dart';
import '../../utils.dart';
import '../../widgets.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, required this.isColdStart});

  final bool isColdStart;

  @override
  State<SplashPage> createState() => SplashPageState();
}

@visibleForTesting
class SplashPageState extends State<SplashPage> {
  static const Key dataViewKey = Key('dataViewKey');

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
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
            bottom: MediaQuery.paddingOf(context).bottom + 16.0,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: _DataView(
                    key: dataViewKey,
                    isColdStart: widget.isColdStart,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  context.l10n.appName,
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: AppFontWeight.semibold),
                  textAlign: TextAlign.center,
                ),
                AppVersionBuilder(
                  valueBuilder: () => AppVersion.retrieve(environment.isMock),
                  builder: (_, String? version, __) => Text(
                    'v$version',
                    style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DataView extends ConsumerStatefulWidget {
  const _DataView({super.key, required this.isColdStart});

  final bool isColdStart;

  @override
  ConsumerState<_DataView> createState() => OnboardingDataViewState();
}

@visibleForTesting
class OnboardingDataViewState extends ConsumerState<_DataView> {
  static const Key signInButtonKey = Key('signInButtonKey');
  late final AuthStateNotifier auth = ref.read(authStateNotifierProvider.notifier);

  @override
  void initState() {
    super.initState();

    if (widget.isColdStart) {
      Future<void>.microtask(auth.signIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authStateNotifierProvider, _authStateListener);

    return AnimatedSwitcher(
      duration: kThemeAnimationDuration,
      child: ref.watch(authStateNotifierProvider) == AuthState.loading
          ? const Center(child: LoadingSpinner())
          : Stack(
              children: <Widget>[
                const Center(
                  child: Image(
                    image: AppImages.logo,
                    width: 148.0,
                    color: Colors.white30,
                    colorBlendMode: BlendMode.saturation,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton.icon(
                    key: signInButtonKey,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    icon: const Image(image: AppImages.googleLogo, width: 24.0),
                    label: Text(
                      context.l10n.continueWithGoogle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: AppFontWeight.bold),
                    ),
                    onPressed: auth.signIn,
                  ),
                ),
              ],
            ),
    );
  }

  void _authStateListener(AuthState? _, AuthState state) {
    if (state is AuthErrorState) {
      final AppSnackBar snackBar = context.snackBar;
      final String message = state.toPrettyMessage(context.l10n, environment.isProduction);
      if (state.reason != AuthErrorStateReason.popupBlockedByBrowser) {
        snackBar.error(message);
      }
    } else if (state == AuthState.complete) {
      context.registry.get<SharedCoordinator>().toHome();
    }
  }
}

extension on AuthErrorState {
  String toPrettyMessage(L10n l10n, bool isProduction) {
    switch (reason) {
      case AuthErrorStateReason.message:
        return isProduction ? l10n.genericErrorMessage : error;
      case AuthErrorStateReason.tooManyRequests:
        return l10n.tryAgainMessage;
      case AuthErrorStateReason.userDisabled:
        return l10n.bannedUserMessage;
      case AuthErrorStateReason.failed:
        return l10n.failedSignInMessage;
      case AuthErrorStateReason.networkUnavailable:
        return l10n.tryAgainMessage;
      case AuthErrorStateReason.popupBlockedByBrowser:
        return l10n.popupBlockedByBrowserMessage;
    }
  }
}
