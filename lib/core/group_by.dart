Map<K, List<T>> groupBy<K, T extends Object>(List<T> list, K Function(T) fn) {
  return list.fold(<K, List<T>>{}, (Map<K, List<T>> rv, T x) {
    final K key = fn(x);
    (rv[key] = rv[key] ?? <T>[]).add(x);
    return rv;
  });
}
