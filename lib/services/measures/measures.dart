import 'package:injector/injector.dart';
import 'package:meta/meta.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/repository/main.dart';

abstract class Measures<T extends Repository> {
  Measures() : repository = Injector.appInstance.getDependency<Repository>();

  final T repository;

  Stream<List<MeasureModel>> fetchAll();

  Future<void> create(List<MeasureModel> measures, {@required String groupName, @required String unitValue});

  Future<void> delete(List<MeasureModel> measures);

  Future<void> update(List<MeasureModel> measures);
}
