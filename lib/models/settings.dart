class SettingsModel {
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
}
