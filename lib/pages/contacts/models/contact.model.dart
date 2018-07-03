import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tailor_made/models/main.dart';
import 'package:tailor_made/utils/tm_uuid.dart';

class ContactModel extends Model {
  String id;
  String fullname;
  String phone;
  String location;
  String imageUrl;
  DateTime createdAt;
  int totalJobs;
  int hasPending;

  ContactModel({
    id,
    this.fullname,
    this.phone,
    this.location,
    this.imageUrl,
    createdAt,
    this.totalJobs = 0,
    this.hasPending = 0,
  })  : id = id ?? uuid(),
        createdAt = createdAt ?? DateTime.now();

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    return new ContactModel(
      id: json['id'],
      fullname: json['fullname'],
      phone: json['phone'],
      location: json['location'],
      imageUrl: json['imageUrl'],
      totalJobs: int.tryParse(json['totalJobs'].toString()),
      hasPending: int.tryParse(json['hasPending'].toString()),
      createdAt: DateTime.tryParse(json['createdAt'].toString()),
    );
  }

  factory ContactModel.fromDoc(DocumentSnapshot doc) {
    return ContactModel.fromJson(doc.data)
      ..reference = doc.reference
      ..documentID = doc.documentID;
  }

  toMap() {
    return {
      "id": id,
      "fullname": fullname,
      "phone": phone,
      "location": location,
      "imageUrl": imageUrl,
      "createdAt": createdAt.toString(),
      "totalJobs": totalJobs.toString(),
      "hasPending": hasPending.toString(),
    };
  }
}
