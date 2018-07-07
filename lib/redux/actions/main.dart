abstract class ActionType {
  String get type;
  final dynamic payload = "";

  String toString() {
    return '$runtimeType(${payload.toString()})';
  }
}

class VoidAction {}

class ReduxActions {
  static const String initContacts = "__initContacts__";
  static const String addContact = "__addContact__";
  static const String removeContact = "__removeContact__";
  static const String onDataEventContact = "__onDataEventContact__";
  static const String initDataEventContact = "__initDataEventContact__";
  static const String disposeDataEventContact = "__disposeDataEventContact__";

  static const String initJobs = "__initJobs__";
  static const String addJob = "__addJob__";
  static const String removeJob = "__removeJob__";
  static const String onDataEventJob = "__onDataEventJob__";
  static const String initDataEventJob = "__initDataEventJob__";
  static const String disposeDataEventJob = "__disposeDataEventJob__";
}
