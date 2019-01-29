class SettingsModel {
  SettingsModel({
    this.premiumNotice,
    this.versionName,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    return SettingsModel(
      premiumNotice: json['premiumNotice'],
      versionName: json['versionName'],
    );
  }

  final String premiumNotice;
  final String versionName;
}
