import 'dart:io';

import 'package:tailor_made/constants/mk_strings.dart';

class NoInternetException extends MkResponseException {
  NoInternetException() : super(HttpStatus.serviceUnavailable, MkStrings.networkError);
}

class UnAuthorisedException extends MkResponseException {
  UnAuthorisedException([String message]) : super(HttpStatus.unauthorized, message);
}

class MkResponseException implements MkException {
  MkResponseException(this.statusCode, [this.message]);

  final int statusCode;

  @override
  final String message;

  @override
  String toString() => '$runtimeType($statusCode, $message)';
}

class MkException implements Exception {
  MkException([this.message]);

  final String message;

  @override
  String toString() => message == null ? "$runtimeType" : "$runtimeType($message)";
}
