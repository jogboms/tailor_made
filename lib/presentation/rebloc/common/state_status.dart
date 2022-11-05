enum StateStatus {
  loading,
  success,
  failure;

  static StateStatus valueOf(String name) => values.byName(name);
}
