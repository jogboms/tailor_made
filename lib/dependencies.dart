import 'package:flutter/widgets.dart';
import 'package:injector/injector.dart';

class Dependencies {
  const Dependencies();

  void initialize() => Injector.appInstance.registerSingleton<Dependencies>(() => this);

  void set<T>(T instance) => Injector.appInstance.registerSingleton<T>(() => instance);

  T get<T>() => Injector.appInstance.get<T>();

  @visibleForTesting
  void dispose() {
    Injector.appInstance.clearAll();
  }

  static Dependencies di() => Injector.appInstance.get<Dependencies>();
}
