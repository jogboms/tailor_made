Map<String, List<T>> groupBy<T extends Object>(List<T> list, String Function(T) fn) {
  return list.fold(<String, List<T>>{}, (Map<String, List<T>> rv, T x) {
    final String key = fn(x);
    (rv[key] = rv[key] ?? <T>[]).add(x);
    return rv;
  });
}
