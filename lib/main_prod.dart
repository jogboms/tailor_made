import 'package:flutter/material.dart';
import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/widgets/app.dart';

void main() {
  return runApp(App(
    env: Environment.PRODUCTION,
  ));
}
