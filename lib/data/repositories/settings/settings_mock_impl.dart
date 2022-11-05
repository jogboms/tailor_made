import 'package:tailor_made/domain.dart';

class SettingsMockImpl extends Settings {
  @override
  Stream<SettingsModel> fetch() async* {
    yield const SettingsModel(
      premiumNotice: 'Hey Premium',
      versionName: '1.0',
    );
  }
}
