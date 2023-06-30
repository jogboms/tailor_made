import 'package:equatable/equatable.dart';

class SettingEntity with EquatableMixin {
  const SettingEntity({
    required this.premiumNotice,
    required this.versionName,
  });

  final String premiumNotice;
  final String versionName;

  @override
  List<Object> get props => <Object>[premiumNotice, versionName];
}
