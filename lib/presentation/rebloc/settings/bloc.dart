import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

part 'actions.dart';
part 'bloc.freezed.dart';
part 'state.dart';

class SettingsBloc extends SimpleBloc<AppState> {
  SettingsBloc(this.settings);

  final Settings settings;

  @override
  Stream<WareContext<AppState>> applyMiddleware(Stream<WareContext<AppState>> input) {
    input
        .whereAction<_InitSettingsAction>()
        .switchMap(
          (WareContext<AppState> context) => settings
              .fetch()
              .handleError((dynamic _) => context.dispatcher(const SettingsAction.error()))
              .map(OnDataAction<SettingEntity>.new)
              .map((OnDataAction<SettingEntity> action) => context.copyWith(action)),
        )
        .untilAction<OnDisposeAction>()
        .listen((WareContext<AppState> context) => context.dispatcher(context.action));

    return input;
  }

  @override
  AppState reducer(AppState state, Action action) {
    return state;
  }
}
