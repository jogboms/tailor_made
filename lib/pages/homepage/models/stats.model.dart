class DetailStatsModel {
  int total;
  int pending;
  int completed;

  DetailStatsModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    total = json["total"];
    pending = json["pending"];
    completed = json["completed"];
  }
}

class StatsModel {
  DetailStatsModel jobs;
  DetailStatsModel contacts;
  DetailStatsModel gallery;
  DetailStatsModel payments;

  StatsModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    jobs = DetailStatsModel.fromJson(json['jobs']);
    contacts = DetailStatsModel.fromJson(json['contacts']);
    gallery = DetailStatsModel.fromJson(json['gallery']);
    payments = DetailStatsModel.fromJson(json['payments']);
  }
}
