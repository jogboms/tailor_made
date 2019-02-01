import 'package:flutter/material.dart';
import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/widgets/app.dart';

void main() async {
  final BootstrapModel bs = await App.bootstrap();

  return runApp(App(
    env: Environment.PRODUCTION,
    isFirstTime: bs.isFirstTime,
  ));
}
