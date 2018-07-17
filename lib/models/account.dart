import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:tailor_made/models/main.dart';

enum AccountModelStatus { enabled, disabled, warning, pending }

class AccountModel extends Model {
  String uid;
  String storeName;
  String email;
  String displayName;
  int phoneNumber;
  String photoURL;
  AccountModelStatus status;
  bool hasPremiumEnabled;
  String notice;
  bool hasReadNotice;

  AccountModel({
    @required this.uid,
    @required this.storeName,
    @required this.email,
    @required this.displayName,
    @required this.phoneNumber,
    @required this.photoURL,
    @required this.status,
    @required this.hasPremiumEnabled,
    @required this.notice,
    @required this.hasReadNotice,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    return new AccountModel(
      uid: json['uid'],
      storeName: json['storeName'],
      email: json['email'],
      displayName: json['displayName'],
      phoneNumber: int.tryParse(json['phoneNumber'].toString()),
      photoURL: json['photoURL'],
      status: AccountModelStatus.values[int.tryParse(json['status'].toString())],
      hasPremiumEnabled: json['hasPremiumEnabled'],
      notice: json['notice'],
      hasReadNotice: json['hasReadNotice'],
    );
  }

  factory AccountModel.fromDoc(DocumentSnapshot doc) {
    return AccountModel.fromJson(doc.data)..reference = doc.reference;
  }

  AccountModel copyWith({
    String storeName,
    String displayName,
    int phoneNumber,
    String photoURL,
    AccountModelStatus status,
    bool hasPremiumEnabled,
    String notice,
    bool hasReadNotice,
  }) {
    return new AccountModel(
      uid: this.uid,
      storeName: storeName ?? this.storeName,
      email: this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      status: status ?? this.status,
      hasPremiumEnabled: hasPremiumEnabled ?? this.hasPremiumEnabled,
      notice: notice ?? this.notice,
      hasReadNotice: hasReadNotice ?? this.hasReadNotice,
    );
  }

  toMap() {
    return {
      "uid": uid,
      "storeName": storeName,
      "email": email,
      "displayName": displayName,
      "phoneNumber": phoneNumber,
      "photoURL": photoURL,
      "status": status.index,
      "hasPremiumEnabled": hasPremiumEnabled,
      "notice": notice,
      "hasReadNotice": hasReadNotice,
    };
  }
}
