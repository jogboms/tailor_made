import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:registry/registry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';

import 'account_provider.dart';
import 'registry_provider.dart';
import 'state_notifier_mixin.dart';

part 'auth_state_notifier_provider.g.dart';

@Riverpod(dependencies: <Object>[registry, account])
class AuthStateNotifier extends _$AuthStateNotifier with StateNotifierMixin {
  @override
  AuthState build() => AuthState.idle;

  void signIn() async {
    final RegistryFactory di = ref.read(registryProvider).get;

    setState(AuthState.loading);

    try {
      await di<SignInUseCase>()();

      setState(AuthState.complete);
    } on AuthException catch (error, stackTrace) {
      switch (error) {
        case AuthExceptionCanceled():
          setState(AuthState.idle);
        case AuthExceptionUserNotFound():
          // TODO(jogboms): account creation happens on the backend. get rid of this
          _waitForAccountSetup();
        case AuthExceptionNetworkUnavailable():
          setState(AuthState.reason(AuthErrorStateReason.networkUnavailable));
        case AuthExceptionPopupBlockedByBrowser():
          setState(AuthState.reason(AuthErrorStateReason.popupBlockedByBrowser));
        case AuthExceptionTooManyRequests():
          setState(AuthState.reason(AuthErrorStateReason.tooManyRequests));
        case AuthExceptionUserDisabled():
          setState(AuthState.reason(AuthErrorStateReason.userDisabled));
        case AuthExceptionFailed():
          setState(AuthState.reason(AuthErrorStateReason.failed));
        case AuthExceptionInvalidEmail():
        case AuthExceptionUnknown():
          _handleError(error, stackTrace);
      }
    } catch (error, stackTrace) {
      await di<SignOutUseCase>()();
      _handleError(error, stackTrace);
    }
  }

  void signOut() async {
    setState(AuthState.loading);

    try {
      await ref.read(registryProvider).get<SignOutUseCase>()();
      ref.invalidate(accountProvider);
      setState(AuthState.complete);
    } catch (error, stackTrace) {
      _handleError(error, stackTrace);
    }
  }

  // TODO(Jogboms): need to get rid of this
  void _waitForAccountSetup() async {
    setState(AuthState.loading);

    try {
      await ref.read(registryProvider).get<FetchAccountUseCase>()();
      setState(AuthState.complete);
    } on AuthExceptionUserNotFound {
      _waitForAccountSetup();
    }
  }

  void _handleError(Object error, StackTrace stackTrace) {
    final String message = error.toString();
    AppLog.e(error, stackTrace);
    setState(AuthState.error(message));
  }
}

@visibleForTesting
enum AuthStateType { idle, loading, error, complete }

base class AuthState with EquatableMixin {
  const AuthState(this.type);

  factory AuthState.error(String error, [AuthErrorStateReason reason]) = AuthErrorState;

  factory AuthState.reason(AuthErrorStateReason reason) => AuthState.error('', reason);

  static const AuthState idle = AuthState(AuthStateType.idle);
  static const AuthState loading = AuthState(AuthStateType.loading);
  static const AuthState complete = AuthState(AuthStateType.complete);

  @visibleForTesting
  final AuthStateType type;

  @override
  List<Object> get props => <Object>[type];
}

enum AuthErrorStateReason {
  message,
  failed,
  networkUnavailable,
  popupBlockedByBrowser,
  tooManyRequests,
  userDisabled,
}

final class AuthErrorState extends AuthState {
  const AuthErrorState(this.error, [this.reason = AuthErrorStateReason.message]) : super(AuthStateType.error);

  final String error;
  final AuthErrorStateReason reason;

  @override
  List<Object> get props => <Object>[...super.props, error, reason];
}
