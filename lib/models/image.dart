import 'package:flutter/foundation.dart';
import 'package:tailor_made/models/main.dart';
import 'package:tailor_made/services/accounts/accounts.dart';
import 'package:uuid/uuid.dart';

class ImageModel extends Model {
  ImageModel({
    String id,
    String userID,
    @required this.contactID,
    @required this.jobID,
    @required this.path,
    @required this.src,
    DateTime createdAt,
  })  : id = id ?? Uuid().v1(),
        userID = userID ?? Accounts.di().getUser.uid,
        createdAt = createdAt ?? DateTime.now();

  ImageModel.fromJson(Map<String, dynamic> json)
      : assert(json != null),
        id = json['id'],
        userID = json['userID'],
        contactID = json['contactID'],
        jobID = json['jobID'],
        path = json['path'],
        src = json['src'],
        createdAt = DateTime.tryParse(json['createdAt'].toString());

  String id;
  String userID;
  String contactID;
  String jobID;
  String path;
  String src;
  DateTime createdAt;

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userID': userID,
      'contactID': contactID,
      'jobID': jobID,
      'path': path,
      'src': src,
      'createdAt': createdAt.toString(),
    };
  }
}
