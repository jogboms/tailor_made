import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tailor_made/models/main.dart';
import 'package:tailor_made/models/serializers.dart';
import 'package:uuid/uuid.dart';

part 'payment.g.dart';

abstract class PaymentModel with ModelInterface implements Built<PaymentModel, PaymentModelBuilder> {
  factory PaymentModel([void Function(PaymentModelBuilder b) updates]) = _$PaymentModel;

  PaymentModel._();

  static void _initializeBuilder(PaymentModelBuilder b) => b
    ..id = const Uuid().v1()
    ..createdAt = DateTime.now();

  String get id;

  String get userID;

  String get contactID;

  String get jobID;

  double get price;

  String get notes;

  DateTime get createdAt;

  @override
  Map<String, dynamic> toMap() => serializers.serializeWith(PaymentModel.serializer, this)! as Map<String, dynamic>;

  static PaymentModel fromJson(Map<String, dynamic> map) => serializers.deserializeWith(PaymentModel.serializer, map)!;

  static Serializer<PaymentModel> get serializer => _$paymentModelSerializer;
}
