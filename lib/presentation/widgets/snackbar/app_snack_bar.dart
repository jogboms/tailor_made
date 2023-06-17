import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme.dart';
import '../../utils.dart';
import '../loading_spinner.dart';
import 'snack_bar_provider.dart';

class AppSnackBar {
  AppSnackBar.of(BuildContext context)
      : _theme = context.theme,
        _l10n = context.l10n,
        _state = SnackBarProvider.of(context);

  static const Key successKey = Key('snackBarSuccessKey');
  static const Key infoKey = Key('snackBarInfoKey');
  static const Key errorKey = Key('snackBarErrorKey');
  static const Key loadingKey = Key('snackBarLoadingKey');

  final SnackBarProviderState? _state;
  final ThemeData _theme;
  final L10n _l10n;

  FutureOr<void> success(String value, {Duration? duration, Alignment? alignment}) => _showForType(
        value,
        key: successKey,
        icon: Icons.check,
        type: SnackBarType.success,
        alignment: alignment,
        duration: duration,
      );

  FutureOr<void> info(String value, {Duration? duration, Alignment? alignment}) => _showForType(
        value,
        key: infoKey,
        icon: Icons.alarm,
        type: SnackBarType.info,
        alignment: alignment,
        duration: duration,
      );

  FutureOr<void> error(String value, {Duration? duration, Alignment? alignment}) => _showForType(
        value,
        key: errorKey,
        icon: Icons.warning,
        type: SnackBarType.error,
        alignment: alignment,
        duration: duration,
      );

  FutureOr<void> loading({
    String? value,
    Color? backgroundColor,
    Color? color,
    Alignment? alignment,
    bool dismissible = false,
  }) =>
      _show(
        value ?? _l10n.loadingMessage,
        key: loadingKey,
        color: color ?? Colors.black,
        alignment: alignment,
        dismissible: dismissible,
        backgroundColor: backgroundColor ?? Colors.white,
        duration: const Duration(days: 1),
        leading: LoadingSpinner(size: 24, color: color),
      );

  FutureOr<void> _showForType(
    String value, {
    required Key key,
    required SnackBarType type,
    required IconData icon,
    Duration? duration,
    Alignment? alignment,
  }) {
    final Color foregroundColor = type.toForegroundColor(_theme);
    return _show(
      value,
      key: key,
      leading: Icon(icon, color: foregroundColor, size: 24),
      alignment: alignment,
      duration: duration,
      color: foregroundColor,
      backgroundColor: type.toBackgroundColor(_theme),
    );
  }

  FutureOr<void> _show(
    String? value, {
    required Key key,
    required Color backgroundColor,
    required Color color,
    Widget? leading,
    Duration? duration,
    bool dismissible = true,
    Alignment? alignment,
  }) =>
      _state?.showSnackBar(
        _RowBar(
          key: Key(value ?? ''),
          backgroundColor: backgroundColor,
          children: <Widget>[
            if (leading != null) ...<Widget>[
              leading,
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Text(
                value ?? '',
                style: TextStyle(fontSize: 14, color: color, fontWeight: AppFontWeight.semibold),
              ),
            ),
          ],
        ),
        key: key,
        duration: duration,
        alignment: alignment,
        dismissible: dismissible,
      );

  void hide() => _state?.hideCurrentSnackBar();
}

class _RowBar extends StatelessWidget {
  const _RowBar({super.key, required this.children, this.backgroundColor});

  final List<Widget> children;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = context.theme;
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.secondary,
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1)),
        ],
        borderRadius: AppBorderRadius.c8,
      ),
      constraints: const BoxConstraints(minHeight: 54),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DefaultTextStyle(
        style: theme.textTheme.bodyMedium!,
        child: Row(children: children),
      ),
    );
  }
}

enum SnackBarType {
  info,
  success,
  error;

  Color toForegroundColor(ThemeData theme) => switch (this) {
        SnackBarType.info => theme.colorScheme.onSurface,
        SnackBarType.success => theme.appTheme.color.onSuccess,
        SnackBarType.error => theme.appTheme.color.onDanger,
      };

  Color toBackgroundColor(ThemeData theme) => switch (this) {
        SnackBarType.info => theme.colorScheme.surface,
        SnackBarType.success => theme.appTheme.color.success,
        SnackBarType.error => theme.appTheme.color.danger,
      };
}

extension AppSnackBarBuildContextExtensions on BuildContext {
  AppSnackBar get snackBar => AppSnackBar.of(this);
}
