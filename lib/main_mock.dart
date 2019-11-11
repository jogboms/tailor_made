import 'package:flutter/material.dart';
import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/widgets/app.dart';
import 'package:tailor_made/widgets/bootstrap.dart';

void main() async {
  // NOTE: only for demo purposes
  await Future<dynamic>.delayed(const Duration(seconds: 2));

  final BootstrapModel bs = await bootstrap(Environment.MOCK);

  return runApp(
    App(bootstrap: bs),
  );
}
