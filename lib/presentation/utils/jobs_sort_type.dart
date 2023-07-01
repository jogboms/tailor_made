enum JobsSortType {
  recent,
  active,
  names,
  owed,
  payments,
  price,
  reset;

  static JobsSortType valueOf(String name) => values.byName(name);
}
