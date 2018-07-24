import 'package:redux/redux.dart';
import 'package:tailor_made/models/settings.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/states/settings.dart';
import 'package:tailor_made/redux/view_models/main.dart';

class SettingsViewModel extends ViewModel {
  SettingsViewModel(Store<ReduxState> store) : super(store);

  SettingsState get _state => store.state.settings;

  SettingsModel get settings => _state.settings;

  bool get isLoading => _state.status == SettingsStatus.loading;

  bool get isSuccess => _state.status == SettingsStatus.success;

  bool get isFailure => _state.status == SettingsStatus.failure;
}
