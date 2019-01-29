import 'dart:async';

import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/rebloc/states/main.dart';

class AccountBloc extends SimpleBloc<AppState> {
  @override
  Future<Action> middleware(
    DispatchFunction dispatcher,
    AppState state,
    Action action,
  ) async {
    // if (action is AccountAsyncInitAction) {
    //   return const AccountAsyncLoadingAction();
    // }
    return action;
  }

  @override
  AppState reducer(AppState state, Action action) {
    // final _account = state.account;

    // if (action is AccountAsyncLoadingAction) {
    //   return state.copyWith(
    //     account: _account.copyWith(
    //       status: AccountStatus.loading,
    //     ),
    //   );
    // }

    // if (action is AccountAsyncFailureAction) {
    //   return state.copyWith(
    //     account: _account.copyWith(
    //       status: AccountStatus.failure,
    //       error: action.error,
    //     ),
    //   );
    // }

    // if (action is AccountAsyncSuccessAction) {
    //   return state.copyWith(
    //     account: _account.copyWith(
    //       status: AccountStatus.success,
    //     ),
    //   );
    // }

    return state;
  }

  @override
  Future<Action> afterware(
    DispatchFunction dispatcher,
    AppState state,
    Action action,
  ) async {
    // if (action is AccountAsyncLoadingAction) {
    //   try {
    //     dispatcher(
    //       AccountAsyncSuccessAction(),
    //     );
    //   } catch (error) {
    //     dispatcher(
    //       AccountAsyncFailureAction(error.toString()),
    //     );
    //   }
    // }
    return action;
  }
}
