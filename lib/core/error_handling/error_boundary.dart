import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class ErrorBoundary extends StatefulWidget {
  ErrorBoundary({
    super.key,
    @visibleForTesting PlatformDispatcher? platformDispatcher,
    required this.child,
    required this.errorViewBuilder,
    required this.onException,
    required this.onCrash,
    this.isReleaseMode = kReleaseMode,
  }) : platformDispatcher = platformDispatcher ?? PlatformDispatcher.instance;

  final PlatformDispatcher platformDispatcher;
  final Widget child;
  final Widget Function(FlutterErrorDetails details) errorViewBuilder;
  final void Function(Object error, StackTrace stackTrace) onException;
  final void Function(FlutterErrorDetails details) onCrash;
  final bool isReleaseMode;

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  final FlutterExceptionHandler? oldFlutterErrorHandler = FlutterError.onError;
  final ErrorWidgetBuilder oldErrorWidgetBuilder = ErrorWidget.builder;

  @override
  void initState() {
    super.initState();

    if (widget.isReleaseMode) {
      ErrorWidget.builder = widget.errorViewBuilder;
    }

    FlutterError.onError = (FlutterErrorDetails details) {
      if (widget.isReleaseMode) {
        widget.onCrash(details);
      } else {
        oldFlutterErrorHandler?.call(details);
      }
    };

// coverage:ignore-start, this still can't be covered in tests.
    widget.platformDispatcher.onError = (Object error, StackTrace stack) {
      widget.onException(error, stack);
      return true;
    };
// coverage:ignore-end
  }

  @override
  void dispose() {
    FlutterError.onError = oldFlutterErrorHandler;
    ErrorWidget.builder = oldErrorWidgetBuilder;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
