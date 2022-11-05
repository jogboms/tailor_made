import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tailor_made/domain.dart';

import '../../network/firebase.dart';

class StatsImpl extends Stats {
  StatsImpl(this.repository);

  final FirebaseRepository repository;

  @override
  Stream<StatsModel?> fetch(String? userId) {
    return repository.db
        .stats(userId)
        .snapshots()
        .map((DocumentSnapshot<Map<String, dynamic>> snapshot) => StatsModel.fromJson(snapshot.data()!));
  }
}
