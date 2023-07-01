import 'package:flutter/widgets.dart';

class ErrorView extends StatelessWidget {
  const ErrorView(this.error, this.stackTrace, {super.key});

  static const Key errorViewKey = Key('errorViewKey');

  final Object error;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) => Center(
        key: errorViewKey,
        child: Text(error.toString()),
      );
}
