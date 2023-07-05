import 'package:tailor_made/domain.dart';

class StatsMockImpl extends Stats {
  @override
  Stream<StatsEntity> fetch(String userId) async* {
    yield const StatsEntity(
      contacts: StatsItemEntity(),
      gallery: StatsItemEntity(),
      jobs: StatsItemEntity(),
      payments: StatsItemEntity(),
    );
  }
}
