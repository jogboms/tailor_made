abstract class ActionType<T> {
  final T payload;

  ActionType({this.payload});

  @override
  String toString() {
    return '$runtimeType(${payload?.toString()})';
  }
}

class VoidAction extends ActionType<void> {}

class OnLogoutEvent extends ActionType<void> {}

class InitDataEvents extends ActionType<void> {}

class DisposeDataEvents extends ActionType<void> {}
