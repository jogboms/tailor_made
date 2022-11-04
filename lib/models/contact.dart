import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tailor_made/models/main.dart';
import 'package:tailor_made/models/serializers.dart';
import 'package:tailor_made/repository/models.dart';
import 'package:uuid/uuid.dart';

part 'contact.g.dart';

abstract class ContactModel with ModelInterface implements Built<ContactModel, ContactModelBuilder> {
  factory ContactModel([void Function(ContactModelBuilder b) updates]) = _$ContactModel;

  ContactModel._();

  factory ContactModel.fromSnapshot(Snapshot snapshot) =>
      ContactModel.fromJson(snapshot.data!)!..reference = snapshot.reference;

  static void _initializeBuilder(ContactModelBuilder b) => b
    ..id = const Uuid().v1()
    ..fullname = ''
    ..createdAt = DateTime.now()
    ..totalJobs = 0
    ..pendingJobs = 0
    ..measurements = BuiltMap<String, double>(<String, double>{}).toBuilder();

  String? get id;

  String get userID;

  String? get fullname;

  String? get phone;

  String? get location;

  String? get imageUrl;

  DateTime? get createdAt;

  BuiltMap<String, double>? get measurements;

  int? get totalJobs;

  int? get pendingJobs;

  @override
  Map<String, dynamic> toMap() => serializers.serializeWith(ContactModel.serializer, this)! as Map<String, dynamic>;

  static ContactModel? fromJson(Map<String, dynamic> map) {
    // TODO(Jogboms): investigate this.
    Map<String, double?> newMeasurements = map['measurements'] as Map<String, double?>? ?? <String, double>{};
    if (newMeasurements.isNotEmpty) {
      newMeasurements = newMeasurements..removeWhere((String key, double? value) => value == null);
    }
    map['measurements'] = newMeasurements;
    return serializers.deserializeWith(ContactModel.serializer, map);
  }

  static Serializer<ContactModel> get serializer => _$contactModelSerializer;
}
