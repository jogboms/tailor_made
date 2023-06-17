import 'package:freezed_annotation/freezed_annotation.dart';

import '../entities.dart';

part 'account.freezed.dart';

part 'account.g.dart';

@freezed
class AccountModel with _$AccountModel {
  const factory AccountModel({
    @JsonKey(
      includeFromJson: false,
      includeToJson: false,
    )
    @Default(NoopReference())
    Reference? reference,
    required String uid,
    required String storeName,
    required String email,
    required String displayName,
    required int? phoneNumber,
    required String photoURL,
    required AccountModelStatus status,
    required bool hasPremiumEnabled,
    required bool hasSendRating,
    required int rating,
    required String notice,
    required bool hasReadNotice,
  }) = _AccountModel;

  factory AccountModel.fromJson(Map<String, Object?> json) => _$AccountModelFromJson(json);
}

enum AccountModelStatus { enabled, disabled, warning, pending }
