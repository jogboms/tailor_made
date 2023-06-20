import '../entities/setting_entity.dart';

abstract class Settings {
  const Settings();

  Stream<SettingEntity> fetch();
}
