import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tailor_made/models/stats/stats.dart';
import 'package:tailor_made/repository/firebase/main.dart';
import 'package:tailor_made/services/stats/stats.dart';

class StatsImpl extends Stats {
  StatsImpl(this.repository);

  final FirebaseRepository repository;

  @override
  Stream<StatsModel?> fetch(String? userId) {
    return repository.db
        .stats(userId)
        .snapshots()
        .map((DocumentSnapshot<Object> snapshot) => StatsModel.fromJson(snapshot.data() as Map<String, dynamic>?));
  }
}
