class AppException implements Exception {
  const AppException([this.message]);

  final String? message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AppException && runtimeType == other.runtimeType && message == other.message;

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() => 'AppException{message: $message}';
}

class NoInternetException extends AppException {
  const NoInternetException();
}
