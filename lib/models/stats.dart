import 'package:tailor_made/models/main.dart';

class IntStatsModel extends Model {
  int total;
  int pending;
  int completed;

  IntStatsModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    total = int.tryParse(json["total"].toString());
    pending = int.tryParse(json["pending"].toString());
    completed = int.tryParse(json["completed"].toString());
  }

  @override
  toMap() {
    return {
      "total": total,
      "pending": pending,
      "completed": completed,
    };
  }
}

class DoubleStatsModel extends Model {
  double total;
  double pending;
  double completed;

  DoubleStatsModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    total = double.tryParse(json["total"].toString());
    pending = double.tryParse(json["pending"].toString());
    completed = double.tryParse(json["completed"].toString());
  }

  @override
  toMap() {
    return {
      "total": total,
      "pending": pending,
      "completed": completed,
    };
  }
}

// KEEP
// {
//   "contacts": {
//     "total": 0
//   },
//   "gallery": {
//     "total": 0
//   },
//   "jobs": {
//     "total": 0,
//     "pending": 0,
//     "completed": 0,
//   },
//   "payments": {
//     "total": 0,
//     "pending": 0,
//     "completed": 0,
//   },
// }

class StatsModel extends Model {
  IntStatsModel jobs;
  IntStatsModel contacts;
  IntStatsModel gallery;
  DoubleStatsModel payments;

  StatsModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    jobs = IntStatsModel.fromJson(json['jobs'].cast<String, dynamic>());
    contacts = IntStatsModel.fromJson(json['contacts'].cast<String, dynamic>());
    gallery = IntStatsModel.fromJson(json['gallery'].cast<String, dynamic>());
    payments = DoubleStatsModel.fromJson(json['payments'].cast<String, dynamic>());
  }

  @override
  toMap() {
    return {
      "jobs": jobs.toMap(),
      "contacts": contacts.toMap(),
      "gallery": gallery.toMap(),
      "payments": payments.toMap(),
    };
  }
}
