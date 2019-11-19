import 'package:tailor_made/constants/mk_strings.dart';

class NoInternetException extends MkException {
  NoInternetException() : super(MkStrings.networkError);
}

class MkException implements Exception {
  MkException([this.message]);

  final String message;

  @override
  String toString() => message == null ? "$runtimeType" : "$runtimeType($message)";
}
