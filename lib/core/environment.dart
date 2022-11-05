enum Environment {
  mock,
  development,
  production;

  bool get isMock => this == mock;

  bool get isDev => this == development;
}
