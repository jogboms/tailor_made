import 'package:injector/injector.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/repository/main.dart';

abstract class Payments<T extends Repository> {
  Payments() : repository = Injector.appInstance.getDependency<Repository>();

  final T repository;

  static Payments di() => Injector.appInstance.getDependency<Payments>();

  Stream<List<PaymentModel>> fetchAll();
}
