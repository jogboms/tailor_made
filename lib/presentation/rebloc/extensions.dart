import 'package:rebloc/rebloc.dart';

extension ObservableExtensions<T> on Stream<WareContext<T>> {
  Stream<WareContext<T>> whereAction<U>() => where((WareContext<T> context) => context.action is U);
}
