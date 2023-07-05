import '../entities.dart';

abstract class Stats {
  Stream<StatsEntity> fetch(String userId);
}
