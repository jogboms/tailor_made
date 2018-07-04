import 'package:tailor_made/models/main.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/utils/tm_uuid.dart';

class ImageModel extends Model {
  String id;
  ContactModel contact;
  String path;
  String src;
  DateTime createdAt;

  ImageModel({
    id,
    this.contact,
    this.path,
    this.src,
    createdAt,
  })  : id = id ?? uuid(),
        createdAt = createdAt ?? DateTime.now();

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    return new ImageModel(
      id: json['id'],
      contact: ContactModel.fromJson(json['contact'].cast<String, dynamic>()),
      path: json['path'],
      src: json['src'],
      createdAt: DateTime.tryParse(json['createdAt'].toString()),
    );
  }

  @override
  toMap() {
    return {
      "id": id,
      "contact": contact.toMap(),
      "path": path,
      "src": src,
      "createdAt": createdAt.toString(),
    };
  }
}
