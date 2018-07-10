import 'package:flutter/foundation.dart';
import 'package:tailor_made/models/main.dart';
import 'package:tailor_made/utils/tm_uuid.dart';

class ImageModel extends Model {
  String id;
  String contactID;
  String jobID;
  String path;
  String src;
  DateTime createdAt;

  ImageModel({
    id,
    @required this.contactID,
    @required this.jobID,
    @required this.path,
    @required this.src,
    createdAt,
  })  : id = id ?? uuid(),
        createdAt = createdAt ?? DateTime.now();

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    return new ImageModel(
      id: json['id'],
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
      "contactID": contactID,
      "jobID": jobID,
      "path": path,
      "src": src,
      "createdAt": createdAt.toString(),
    };
  }
}
