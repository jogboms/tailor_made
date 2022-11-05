import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

@freezed
class PaymentModel with _$PaymentModel {
  const factory PaymentModel({
    required String id,
    required String userID,
    required String contactID,
    required String jobID,
    required double price,
    required String notes,
    required DateTime createdAt,
  }) = _PaymentModel;

  factory PaymentModel.fromJson(Map<String, Object?> json) => _$PaymentModelFromJson(json);
}
