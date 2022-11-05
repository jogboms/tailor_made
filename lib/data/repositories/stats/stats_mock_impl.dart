import 'package:tailor_made/domain.dart';

class StatsMockImpl extends Stats {
  @override
  Stream<StatsModel> fetch(String? userId) async* {
    yield const StatsModel(
      contacts: StatsItemModel(),
      gallery: StatsItemModel(),
      jobs: StatsItemModel(),
      payments: StatsItemModel(),
    );
  }
}
