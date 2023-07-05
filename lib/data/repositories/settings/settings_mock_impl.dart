import 'package:tailor_made/domain.dart';

class SettingsMockImpl extends Settings {
  @override
  Stream<SettingEntity> fetch() async* {
    yield const SettingEntity(
      premiumNotice: 'Hey Premium',
      versionName: '1.0',
    );
  }
}
