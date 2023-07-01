enum ContactsSortType {
  recent,
  jobs,
  completed,
  pending,
  names,
  reset;

  static ContactsSortType valueOf(String name) => values.byName(name);
}
