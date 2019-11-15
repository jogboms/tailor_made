abstract class Snapshot<T> {
  Map<String, dynamic> get data;
  Reference get reference;
}

abstract class User {
  String get uid;
}

abstract class Storage {
  Future<void> delete();

  Future getDownloadURL();

  String get path;
}

abstract class Reference<T> {
  T get source;

  Future<void> delete();

  Future<void> setData(Map<String, dynamic> data, {bool merge = false});

  Future<void> updateData(Map<String, dynamic> data);
}
