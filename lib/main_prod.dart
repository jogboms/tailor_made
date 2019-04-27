import 'package:flutter/material.dart';
import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/widgets/app.dart';
import 'package:tailor_made/widgets/bootstrap.dart';

void main() async {
  // NOTE: so flutter has enough time to calculate sizes
  await Future<dynamic>.delayed(const Duration(seconds: 1));

  final BootstrapModel bs = await bootstrap(Environment.PRODUCTION);

  return runApp(
    App(bootstrap: bs),
  );
}
