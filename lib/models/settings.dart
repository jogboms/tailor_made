class SettingsModel {
  final String premiumNotice;
  final String versionName;

  SettingsModel({
    this.premiumNotice,
    this.versionName,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    return new SettingsModel(
      premiumNotice: json['premiumNotice'],
      versionName: json['versionName'],
    );
  }
}
