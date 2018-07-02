import 'package:tailor_made/utils/tm_uuid.dart';

class ContactModel {
  String id;
  String fullname;
  String phone;
  String location;
  String imageUrl;
  int totalJobs;
  int hasPending;

  ContactModel({
    id,
    this.fullname,
    this.phone,
    this.location,
    this.imageUrl,
    this.totalJobs = 0,
    this.hasPending = 0,
  }) : id = id ?? uuid();

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
    );
  }

  toMap() {
    return {
      "id": id,
      "fullname": fullname,
      "phone": phone,
      "location": location,
      "imageUrl": imageUrl,
      "totalJobs": totalJobs.toString(),
      "hasPending": hasPending.toString(),
    };
  }
}
