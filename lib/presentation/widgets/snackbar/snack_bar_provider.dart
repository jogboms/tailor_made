import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SnackBarProvider extends StatefulWidget with DiagnosticableTreeMixin {
  const SnackBarProvider({super.key, required this.child, required this.navigatorKey});

  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  static SnackBarProviderState? of(BuildContext context) {
    final SnackBarProviderState? result = context.findAncestorStateOfType<SnackBarProviderState>();
    if (result != null) {
      return result;
    }

    if (kReleaseMode) {
      return null;
    }
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary('SnackBarProvider.of() called with a context that does not contain a SnackBarProvider.'),
      ErrorDescription(
        'No App ancestor could be found starting from the context that was passed to SnackBarProvider.of(). '
        'This usually happens when the context provided is from the same StatefulWidget as that '
        'whose build function actually creates the App widget being sought.',
      ),
      context.describeElement('The context used was')
    ]);
  }

  @override
  SnackBarProviderState createState() => SnackBarProviderState();
}

class SnackBarProviderState extends State<SnackBarProvider> {
  final List<Snack> _snacks = <Snack>[];
  static const Duration _duration = Duration(seconds: 5);

  @override
  void dispose() {
    hideCurrentSnackBar();
    super.dispose();
  }

  OverlayState? get _overlayState => widget.navigatorKey.currentState?.overlay;

  FutureOr<String> showSnackBar(
    Widget child, {
    Key? key,
    Duration? duration,
    bool dismissible = true,
    Alignment? alignment,
  }) async {
    hideCurrentSnackBar();

    final OverlayEntry barrier = OverlayEntry(
      builder: (_) => GestureDetector(
        key: key,
        onTapUp: dismissible ? (_) => hideCurrentSnackBar() : null,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: Material(
            color: Colors.black26,
            child: IgnorePointer(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: Align(alignment: alignment ?? Alignment.bottomCenter, child: child),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final Completer<String> completer = Completer<String>();
    final String id = shortHash(Object());
    _snacks.add(
      Snack(
        id: id,
        barrier: barrier,
        completer: completer,
        timer: Timer(duration ?? _duration, () {
          completer.complete(id);
          barrier.remove();
        }),
      ),
    );

    _overlayState?.insert(barrier);

    return completer.future;
  }

  void hideCurrentSnackBar() {
    if (_snacks.isEmpty) {
      return;
    }

    final Snack lastSnack = _snacks.last;
    if (lastSnack.timer.isActive && !lastSnack.completer.isCompleted) {
      lastSnack.remove();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<Snack>('snacks', _snacks));
    properties.add(DiagnosticsProperty<Duration>('duration', _duration));
  }
}

class Snack {
  const Snack({required this.id, required this.barrier, required this.timer, required this.completer});

  final String id;
  final OverlayEntry barrier;
  final Timer timer;
  final Completer<String> completer;

  void remove() {
    completer.complete(id);
    barrier.remove();
    timer.cancel();
  }
}
