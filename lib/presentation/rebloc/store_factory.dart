import 'package:rebloc/rebloc.dart';
import 'package:registry/registry.dart';

import 'accounts/bloc.dart';
import 'app_state.dart';

Store<AppState> storeFactory(Registry registry) {
  return Store<AppState>(
    initialState: AppState.initialState,
    blocs: <Bloc<AppState>>[
      AccountBloc(registry.get()),
    ],
  );
}
