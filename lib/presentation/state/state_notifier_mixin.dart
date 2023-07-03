import 'package:meta/meta.dart';
import 'package:riverpod/riverpod.dart';

@optionalTypeArgs
mixin StateNotifierMixin<T> on AutoDisposeNotifier<T> {
  T get currentState => state;

  // ignore: use_setters_to_change_properties
  void setState(T value) => state = value;
}
