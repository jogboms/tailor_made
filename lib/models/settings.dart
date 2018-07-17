class SettingsModel {
  String premiumNotice;

  SettingsModel({
    this.premiumNotice,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    return new SettingsModel(
      premiumNotice: json['premiumNotice'],
    );
  }
}
