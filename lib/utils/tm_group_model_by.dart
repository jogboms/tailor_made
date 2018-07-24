// Group List by group name
import 'package:tailor_made/models/main.dart';

Map<String, List<T>> groupModelBy<T extends Model>(List<T> list, dynamic key) {
  return list.fold(
    <String, List<T>>{},
    (rv, T x) {
      (rv[x[key]] = rv[x[key]] ?? <T>[]).add(x);
      return rv;
    },
  );
}
