import 'package:equatable/equatable.dart';

import 'reference_entity.dart';

class AccountEntity with EquatableMixin {
  const AccountEntity({
    required this.reference,
    required this.uid,
    required this.storeName,
    required this.email,
    required this.displayName,
    required this.phoneNumber,
    required this.photoURL,
    required this.status,
    required this.hasPremiumEnabled,
    required this.hasSendRating,
    required this.rating,
    required this.notice,
    required this.hasReadNotice,
  });

  final ReferenceEntity reference;
  final String uid;
  final String storeName;
  final String email;
  final String displayName;
  final int? phoneNumber;
  final String? photoURL;
  final AccountStatus status;
  final bool hasPremiumEnabled;
  final bool hasSendRating;
  final int rating;
  final String notice;
  final bool hasReadNotice;

  @override
  List<Object?> get props => <Object?>[
        reference,
        uid,
        storeName,
        email,
        displayName,
        phoneNumber,
        photoURL,
        status,
        hasPremiumEnabled,
        hasSendRating,
        rating,
        notice,
        hasReadNotice,
      ];

  AccountEntity copyWith({
    ReferenceEntity? reference,
    String? uid,
    String? storeName,
    String? email,
    String? displayName,
    int? phoneNumber,
    String? photoURL,
    AccountStatus? status,
    bool? hasPremiumEnabled,
    bool? hasSendRating,
    int? rating,
    String? notice,
    bool? hasReadNotice,
  }) {
    return AccountEntity(
      reference: reference ?? this.reference,
      uid: uid ?? this.uid,
      storeName: storeName ?? this.storeName,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      status: status ?? this.status,
      hasPremiumEnabled: hasPremiumEnabled ?? this.hasPremiumEnabled,
      hasSendRating: hasSendRating ?? this.hasSendRating,
      rating: rating ?? this.rating,
      notice: notice ?? this.notice,
      hasReadNotice: hasReadNotice ?? this.hasReadNotice,
    );
  }
}

enum AccountStatus { enabled, disabled, warning, pending }
