import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tailor_made/models/main.dart';
import 'package:tailor_made/models/serializers.dart';
import 'package:tailor_made/repository/models.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:uuid/uuid.dart';

part 'contact.g.dart';

abstract class ContactModel with ModelInterface implements Built<ContactModel, ContactModelBuilder> {
  factory ContactModel([void updates(ContactModelBuilder b)]) = _$ContactModel;

  ContactModel._();

  factory ContactModel.fromSnapshot(Snapshot snapshot) =>
      ContactModel.fromJson(snapshot.data)..reference = snapshot.reference;

  static void _initializeBuilder(ContactModelBuilder b) => b
    ..id = Uuid().v1()
    ..userID = Dependencies.di().session.getUserId()
    ..fullname = ""
    ..createdAt = DateTime.now()
    ..totalJobs = 0
    ..pendingJobs = 0
    ..measurements = BuiltMap<String, double>(<String, double>{}).toBuilder();

  @nullable
  String get id;

  @nullable
  String get userID;

  @nullable
  String get fullname;

  @nullable
  String get phone;

  @nullable
  String get location;

  @nullable
  String get imageUrl;

  @nullable
  DateTime get createdAt;

  @nullable
  BuiltMap<String, double> get measurements;

  @nullable
  int get totalJobs;

  @nullable
  int get pendingJobs;

  @override
  Map<String, dynamic> toMap() => serializers.serializeWith(ContactModel.serializer, this);

  static ContactModel fromJson(Map<String, dynamic> map) {
    // TODO: investigate this
    Map<String, double> newMeasurements =
        map["measurements"] != null ? map["measurements"].cast<String, double>() : <String, double>{};
    if (newMeasurements.isNotEmpty) {
      newMeasurements = newMeasurements..removeWhere((key, value) => value == null);
    }
    map["measurements"] = newMeasurements;
    return serializers.deserializeWith(ContactModel.serializer, map);
  }

  static Serializer<ContactModel> get serializer => _$contactModelSerializer;
}
