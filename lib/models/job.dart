import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/models/main.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/models/serializers.dart';
import 'package:tailor_made/repository/models.dart';
import 'package:uuid/uuid.dart';

part 'job.g.dart';

abstract class JobModel with ModelInterface implements Built<JobModel, JobModelBuilder> {
  factory JobModel([void Function(JobModelBuilder b) updates]) = _$JobModel;

  JobModel._();

  factory JobModel.fromSnapshot(Snapshot snapshot) =>
      JobModel.fromJson(snapshot.data!)!..reference = snapshot.reference;

  static void _initializeBuilder(JobModelBuilder b) => b
    ..id = const Uuid().v1()
    ..name = ''
    ..createdAt = DateTime.now()
    ..completedPayment = 0.0
    ..pendingPayment = 0.0
    ..payments = BuiltList<PaymentModel>(<PaymentModel>[]).toBuilder()
    ..isComplete = false
    ..dueAt = DateTime.now().add(const Duration(days: 7))
    ..measurements = BuiltMap<String, double>(<String, double>{}).toBuilder();

  String? get id;

  String get userID;

  String? get contactID;

  String? get name;

  double? get price;

  double? get completedPayment;

  double? get pendingPayment;

  String? get notes;

  BuiltList<ImageModel>? get images;

  BuiltMap<String, double>? get measurements;

  BuiltList<PaymentModel>? get payments;

  bool? get isComplete;

  DateTime? get createdAt;

  DateTime? get dueAt;

  @override
  Map<String, dynamic> toMap() => serializers.serializeWith(JobModel.serializer, this)! as Map<String, dynamic>;

  static JobModel? fromJson(Map<String, dynamic> map) {
    // TODO(Jogboms): investigate this
    Map<String, double?> newMeasurements = map['measurements'] as Map<String, double?>? ?? <String, double>{};
    if (newMeasurements.isNotEmpty) {
      newMeasurements = newMeasurements..removeWhere((String key, double? value) => value == null);
    }
    map['measurements'] = newMeasurements;
    return serializers.deserializeWith(JobModel.serializer, map);
  }

  static Serializer<JobModel> get serializer => _$jobModelSerializer;
}
