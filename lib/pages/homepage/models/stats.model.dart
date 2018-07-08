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

class PaymentStatsModel {
  double total;
  double pending;
  double completed;

  PaymentStatsModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    total = double.tryParse(json["total"].toString());
    pending = double.tryParse(json["pending"].toString());
    completed = double.tryParse(json["completed"].toString());
  }
}

class StatsModel {
  DetailStatsModel jobs;
  DetailStatsModel contacts;
  DetailStatsModel gallery;
  PaymentStatsModel payments;

  StatsModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    jobs = DetailStatsModel.fromJson(json['jobs'].cast<String, dynamic>());
    contacts = DetailStatsModel.fromJson(json['contacts'].cast<String, dynamic>());
    gallery = DetailStatsModel.fromJson(json['gallery'].cast<String, dynamic>());
    payments = PaymentStatsModel.fromJson(json['payments'].cast<String, dynamic>());
  }
}
