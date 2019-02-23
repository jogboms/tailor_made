import 'package:tailor_made/models/main.dart';

class SettingsModel extends Model {
  SettingsModel({
    this.premiumNotice,
    this.versionName,
  });

  SettingsModel.fromJson(Map<String, dynamic> json)
      : assert(json != null),
        premiumNotice = json['premiumNotice'],
        versionName = json['versionName'];

  final String premiumNotice;
  final String versionName;

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'premiumNotice': premiumNotice,
      'versionName': versionName,
    };
  }
}
