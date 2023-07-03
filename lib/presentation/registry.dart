import 'package:flutter/widgets.dart';
import 'package:registry/registry.dart';

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
