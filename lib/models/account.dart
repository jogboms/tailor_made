import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:tailor_made/models/main.dart';

enum AccountModelStatus { enabled, disabled, warning, pending }

class AccountModel extends Model {
  AccountModel({
    @required this.uid,
    @required this.storeName,
    @required this.email,
    @required this.displayName,
    @required this.phoneNumber,
    @required this.photoURL,
    @required this.status,
    @required this.hasPremiumEnabled,
    @required this.hasSendRating,
    @required this.rating,
    @required this.notice,
    @required this.hasReadNotice,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    return AccountModel(
      uid: json['uid'],
      storeName: json['storeName'],
      email: json['email'],
      displayName: json['displayName'],
      phoneNumber: int.tryParse(json['phoneNumber'].toString()),
      photoURL: json['photoURL'],
      status:
          AccountModelStatus.values[int.tryParse(json['status'].toString())],
      hasPremiumEnabled: json['hasPremiumEnabled'],
      hasSendRating: json['hasSendRating'] ?? false,
      rating: json['rating'],
      notice: json['notice'],
      hasReadNotice: json['hasReadNotice'],
    );
  }

  factory AccountModel.fromDoc(DocumentSnapshot doc) {
    return AccountModel.fromJson(doc.data)..reference = doc.reference;
  }

  String uid;
  String storeName;
  String email;
  String displayName;
  int phoneNumber;
  String photoURL;
  AccountModelStatus status;
  bool hasPremiumEnabled;
  bool hasSendRating;
  int rating;
  String notice;
  bool hasReadNotice;

  AccountModel copyWith({
    String storeName,
    String displayName,
    int phoneNumber,
    String photoURL,
    AccountModelStatus status,
    bool hasPremiumEnabled,
    bool hasSendRating,
    int rating,
    String notice,
    bool hasReadNotice,
  }) {
    return AccountModel(
      uid: this.uid,
      storeName: storeName ?? this.storeName,
      email: this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      status: status ?? this.status,
      hasPremiumEnabled: hasPremiumEnabled ?? this.hasPremiumEnabled,
      hasSendRating: hasSendRating ?? this.hasSendRating,
      rating: rating ?? this.rating,
      notice: notice ?? this.notice,
      hasReadNotice: hasReadNotice ?? this.hasReadNotice,
    )..reference = this.reference;
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'storeName': storeName,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'status': status.index,
      'hasPremiumEnabled': hasPremiumEnabled,
      'hasSendRating': hasSendRating,
      'rating': rating,
      'notice': notice,
      'hasReadNotice': hasReadNotice,
    };
  }
}
