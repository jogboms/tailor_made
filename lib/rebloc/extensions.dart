import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';

extension ObservableExtensions<T> on Observable<WareContext<T>> {
  Observable<WareContext<T>> whereAction<U>() => where((context) => context.action is U);
}

extension StreamExtensions<T> on Stream<WareContext<T>> {
  Stream<WareContext<T>> untilAction<U>() => takeWhile((context) => context.action is! U);
}
