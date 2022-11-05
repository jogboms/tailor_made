import 'package:firebase_core/firebase_core.dart';

typedef AppFirebaseException = FirebaseException;

class AppFirebaseAuthException implements Exception {
  const AppFirebaseAuthException(this.type, {required this.email});

  final AppFirebaseAuthExceptionType type;
  final String? email;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppFirebaseAuthException &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          email == other.email;

  @override
  int get hashCode => type.hashCode ^ email.hashCode;

  @override
  String toString() => 'AppFirebaseAuthException{type: $type, email: $email}';
}

enum AppFirebaseAuthExceptionType {
  canceled,
  failed,
  networkUnavailable,
  popupBlockedByBrowser,
  invalidEmail,
  userDisabled,
  userNotFound,
  tooManyRequests,
}
