import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:tailor_made/models/main.dart';

enum AccountModelStatus { enabled, disabled, warning }

class AccountModel extends Model {
  String uid;
  String storeName;
  String email;
  String displayName;
  int phoneNumber;
  String photoURL;
  AccountModelStatus status;

  AccountModel({
    @required this.uid,
    @required this.storeName,
    @required this.email,
    @required this.displayName,
    @required this.phoneNumber,
    @required this.photoURL,
    @required this.status,
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
    );
  }

  factory AccountModel.fromDoc(DocumentSnapshot doc) {
    return AccountModel.fromJson(doc.data)..reference = doc.reference;
  }

  toMap() {
    return {
      "uid": uid,
      "storeName": storeName,
      "email": email,
      "displayName": displayName,
      "phoneNumber": phoneNumber,
      "photoURL": photoURL,
      "status": status.toString(),
    };
  }
}
