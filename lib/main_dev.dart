import 'package:flutter/material.dart';
import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/widgets/app.dart';

void main() async {
  // NOTE: only for demo purposes
  await Future<dynamic>.delayed(const Duration(seconds: 2));

  final BootstrapModel bs = await App.bootstrap();

  return runApp(App(
    env: Environment.DEVELOPMENT,
    isFirstTime: bs.isFirstTime,
  ));
}
