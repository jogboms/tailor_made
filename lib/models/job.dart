import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/models/main.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/models/serializers.dart';
import 'package:tailor_made/repository/models.dart';
import 'package:uuid/uuid.dart';

part 'job.g.dart';

abstract class JobModel with ModelInterface implements Built<JobModel, JobModelBuilder> {
  factory JobModel([void updates(JobModelBuilder b)]) = _$JobModel;

  JobModel._();

  factory JobModel.fromSnapshot(Snapshot snapshot) => JobModel.fromJson(snapshot.data)..reference = snapshot.reference;

  static void _initializeBuilder(JobModelBuilder b) => b
    ..id = Uuid().v1()
    ..userID = Dependencies.di().session.getUserId()
    ..name = ""
    ..createdAt = DateTime.now()
    ..completedPayment = 0.0
    ..pendingPayment = 0.0
    ..payments = BuiltList<PaymentModel>(<PaymentModel>[]).toBuilder()
    ..isComplete = false
    ..dueAt = DateTime.now().add(Duration(days: 7))
    ..measurements = BuiltMap<String, double>(<String, double>{}).toBuilder();

  @nullable
  String get id;

  @nullable
  String get userID;

  @nullable
  String get contactID;

  @nullable
  String get name;

  @nullable
  double get price;

  @nullable
  double get completedPayment;

  @nullable
  double get pendingPayment;

  @nullable
  String get notes;

  @nullable
  BuiltList<ImageModel> get images;

  @nullable
  BuiltMap<String, double> get measurements;

  @nullable
  BuiltList<PaymentModel> get payments;

  @nullable
  bool get isComplete;

  @nullable
  DateTime get createdAt;

  @nullable
  DateTime get dueAt;

  @override
  Map<String, dynamic> toMap() => serializers.serializeWith(JobModel.serializer, this);

  static JobModel fromJson(Map<String, dynamic> map) {
    // TODO: investigate this
    Map<String, double> newMeasurements =
        map["measurements"] != null ? map["measurements"].cast<String, double>() : <String, double>{};
    if (newMeasurements.isNotEmpty) {
      newMeasurements = newMeasurements..removeWhere((key, value) => value == null);
    }
    map["measurements"] = newMeasurements;
    return serializers.deserializeWith(JobModel.serializer, map);
  }

  static Serializer<JobModel> get serializer => _$jobModelSerializer;
}
