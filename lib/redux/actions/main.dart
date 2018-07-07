abstract class ActionType {
  String get type;
  final dynamic payload = "";

  String toString() {
    return '$runtimeType(${payload.toString()})';
  }
}

class ReduxActions {
  static const String initContacts = "__initContacts__";
  static const String addContact = "__addContact__";
  static const String removeContact = "__removeContact__";

  static const String initJobs = "__initJobs__";
  static const String addJob = "__addJob__";
  static const String removeJob = "__removeJob__";
}
