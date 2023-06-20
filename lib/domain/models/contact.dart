import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import '../entities.dart';

part 'contact.freezed.dart';
part 'contact.g.dart';

@freezed
class ContactModel with _$ContactModel {
  const factory ContactModel({
    @JsonKey(
      includeFromJson: false,
      includeToJson: false,
    )
    Reference? reference,
    required String id,
    required String userID,
    @Default('') String fullname,
    required String phone,
    required String location,
    required String? imageUrl,
    required DateTime createdAt,
    @Default(<String, double>{}) Map<String, double> measurements,
    @Default(0) int totalJobs,
    @Default(0) int pendingJobs,
  }) = _ContactModel;

  factory ContactModel.fromDefaults({
    required String userID,
  }) {
    return ContactModel(
      id: const Uuid().v4(),
      userID: userID,
      phone: '',
      location: '',
      imageUrl: null,
      createdAt: DateTime.now(),
    );
  }

  @Deprecated('Use ContactModel.fromModifiedJson instead')
  factory ContactModel.fromJson(Map<String, Object?> json) => _$ContactModelFromJson(json);

  factory ContactModel.fromModifiedJson(Map<String, Object?> json) {
    Map<String, double?> newMeasurements = json['measurements'] as Map<String, double?>? ?? <String, double>{};
    if (newMeasurements.isNotEmpty) {
      newMeasurements = newMeasurements..removeWhere((String key, double? value) => value == null);
    }
    json['measurements'] = newMeasurements;
    return _$ContactModelFromJson(json);
  }
}
