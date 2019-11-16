import 'package:injector/injector.dart';
import 'package:tailor_made/models/stats/stats.dart';
import 'package:tailor_made/repository/main.dart';

abstract class Stats<T extends Repository> {
  Stats() : repository = Injector.appInstance.getDependency<Repository>();

  final T repository;

  Stream<StatsModel> fetch();
}
