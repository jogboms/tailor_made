class NoInternetException extends AppException {
  const NoInternetException();
}

class AppException implements Exception {
  const AppException([this.message]);

  final String? message;

  @override
  String toString() => message == null ? '$runtimeType' : '$runtimeType($message)';
}
