import 'package:flutter/foundation.dart';
import 'package:tailor_made/models/main.dart';
import 'package:tailor_made/services/auth.dart';
import 'package:tailor_made/utils/tm_uuid.dart';

class ImageModel extends Model {
  String id;
  String userID;
  String contactID;
  String jobID;
  String path;
  String src;
  DateTime createdAt;

  ImageModel({
    String id,
    String userID,
    @required this.contactID,
    @required this.jobID,
    @required this.path,
    @required this.src,
    DateTime createdAt,
  })  : id = id ?? uuid(),
        userID = userID ?? Auth.getUser.uid,
        createdAt = createdAt ?? DateTime.now();

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    return new ImageModel(
      id: json['id'],
      userID: json['userID'],
      contactID: json['contactID'],
      jobID: json['jobID'],
      path: json['path'],
      src: json['src'],
      createdAt: DateTime.tryParse(json['createdAt'].toString()),
    );
  }

  @override
  toMap() {
    return {
      "id": id,
      "userID": userID,
      "contactID": contactID,
      "jobID": jobID,
      "path": path,
      "src": src,
      "createdAt": createdAt.toString(),
    };
  }
}
