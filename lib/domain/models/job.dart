import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import '../entities.dart';
import 'image.dart';
import 'payment.dart';

part 'job.freezed.dart';
part 'job.g.dart';

@freezed
class JobModel with _$JobModel {
  const factory JobModel({
    @JsonKey(ignore: true) @Default(NoopReference()) Reference? reference,
    required String id,
    required String userID,
    required String? contactID,
    required double price,
    @Default('') String name,
    @Default(0.0) double completedPayment,
    @Default(0.0) double pendingPayment,
    @Default('') String notes,
    @Default(<ImageModel>[]) List<ImageModel> images,
    @Default(<String, double>{}) Map<String, double> measurements,
    @Default(<PaymentModel>[]) List<PaymentModel> payments,
    @Default(false) bool isComplete,
    required DateTime createdAt,
    required DateTime dueAt,
  }) = _JobModel;

  factory JobModel.fromDefaults({
    required String userID,
    required String? contactID,
    required Map<String, double>? measurements,
  }) {
    return JobModel(
      id: const Uuid().v4(),
      userID: userID,
      contactID: contactID,
      price: 0.0,
      createdAt: DateTime.now(),
      payments: const <PaymentModel>[],
      dueAt: DateTime.now().add(const Duration(days: 7)),
      measurements: measurements ?? const <String, double>{},
    );
  }

  factory JobModel.fromJson(Map<String, Object?> json) => _$JobModelFromJson(json);

  // TODO(Jogboms): investigate this
// factory JobModel.fromJson(Map<String, Object?> json) {
//   Map<String, double?> newMeasurements = json['measurements'] as Map<String, double?>? ?? <String, double>{};
//   if (newMeasurements.isNotEmpty) {
//     newMeasurements = newMeasurements..removeWhere((String key, double? value) => value == null);
//   }
//   json['measurements'] = newMeasurements;
//   return _$JobModelFromJson(json);
// }
}
