import 'package:tailor_made/models/main.dart';
import 'package:tailor_made/utils/tm_uuid.dart';

class ImageModel extends Model {
  String id;
  String contactID;
  String path;
  String src;
  DateTime createdAt;

  ImageModel({
    id,
    this.contactID,
    this.path,
    this.src,
    createdAt,
  })  : id = id ?? uuid(),
        createdAt = createdAt ?? DateTime.now();

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    return new ImageModel(
      id: json['id'],
      contactID: json['contactID'],
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
      "path": path,
      "src": src,
      "createdAt": createdAt.toString(),
    };
  }
}
