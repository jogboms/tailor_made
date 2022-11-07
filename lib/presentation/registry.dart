import 'package:flutter/widgets.dart';

typedef RegistryFactory = U Function<U>();

class Registry {
  final Expando<Object> _instances = Expando<Object>('Registry');

  void set<T>(T instance) => _instances.set<T>(instance);

  T get<T>() {
    final Object instance = _instances.get<T>();
    if (instance is T Function()) {
      return instance.call();
    }
    return instance as T;
  }

  void factory<T>(T Function(RegistryFactory) fn) => _instances.set<T>(() => fn(<U>() => get<U>()));

  @visibleForTesting
  void replace<T>(T instance) => _instances.set<T>(instance, true);
}

extension on Expando<Object> {
  void set<T>(Object? instance, [bool replace = false]) {
    assert(!(this[T] != null && !replace), 'Instance of type $T is already added to the Registry');
    this[T] = instance;
  }

  Object get<T>() {
    final Object? instance = this[T];
    if (instance == null) {
      throw ArgumentError('Instance of type $T was not added to the Registry');
    }
    return instance;
  }
}

class RegistryProvider extends InheritedWidget {
  const RegistryProvider({
    super.key,
    required this.registry,
    required super.child,
  });

  final Registry registry;

  static Registry of(BuildContext context) {
    final InheritedElement? result = context.getElementForInheritedWidgetOfExactType<RegistryProvider>();
    assert(result != null, 'No RegistryProvider found in context');
    return (result?.widget as RegistryProvider?)!.registry;
  }

  @override
  bool updateShouldNotify(RegistryProvider oldWidget) => false;
}

extension BuildContextRegistryExtension on BuildContext {
  Registry get registry => RegistryProvider.of(this);
}
