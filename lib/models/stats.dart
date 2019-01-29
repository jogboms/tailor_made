import 'package:tailor_made/models/main.dart';

class IntStatsModel extends Model {
  IntStatsModel({
    this.total,
    this.pending,
    this.completed,
  });

  factory IntStatsModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    return IntStatsModel(
      total: int.tryParse(json['total'].toString()),
      pending: int.tryParse(json['pending'].toString()),
      completed: int.tryParse(json['completed'].toString()),
    );
  }

  final int total;
  final int pending;
  final int completed;

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'total': total,
      'pending': pending,
      'completed': completed,
    };
  }
}

class DoubleStatsModel extends Model {
  DoubleStatsModel({
    this.total,
    this.pending,
    this.completed,
  });

  factory DoubleStatsModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    return DoubleStatsModel(
      total: double.tryParse(json['total'].toString()),
      pending: double.tryParse(json['pending'].toString()),
      completed: double.tryParse(json['completed'].toString()),
    );
  }

  final double total;
  final double pending;
  final double completed;

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'total': total,
      'pending': pending,
      'completed': completed,
    };
  }
}

// KEEP
// {
//   'contacts': {
//     'total': 0
//   },
//   'gallery': {
//     'total': 0
//   },
//   'jobs': {
//     'total': 0,
//     'pending': 0,
//     'completed': 0,
//   },
//   'payments': {
//     'total': 0,
//     'pending': 0,
//     'completed': 0,
//   },
// }

class StatsModel extends Model {
  StatsModel({
    this.jobs,
    this.contacts,
    this.gallery,
    this.payments,
  });

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    return StatsModel(
      jobs: IntStatsModel.fromJson(json['jobs'].cast<String, dynamic>()),
      contacts:
          IntStatsModel.fromJson(json['contacts'].cast<String, dynamic>()),
      gallery: IntStatsModel.fromJson(json['gallery'].cast<String, dynamic>()),
      payments:
          DoubleStatsModel.fromJson(json['payments'].cast<String, dynamic>()),
    );
  }

  final IntStatsModel jobs;
  final IntStatsModel contacts;
  final IntStatsModel gallery;
  final DoubleStatsModel payments;

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'jobs': jobs.toMap(),
      'contacts': contacts.toMap(),
      'gallery': gallery.toMap(),
      'payments': payments.toMap(),
    };
  }
}
