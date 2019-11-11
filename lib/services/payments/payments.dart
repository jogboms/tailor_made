import 'package:injector/injector.dart';
import 'package:tailor_made/models/payment.dart';

abstract class Payments {
  static Payments di() => Injector.appInstance.getDependency<Payments>();

  Stream<List<PaymentModel>> fetchAll();
}
