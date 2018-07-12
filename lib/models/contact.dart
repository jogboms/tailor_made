import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tailor_made/models/main.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/services/auth.dart';
import 'package:tailor_made/utils/tm_uuid.dart';

class ContactModel extends Model {
  String id;
  String userID;
  String fullname;
  String phone;
  String location;
  String imageUrl;
  DateTime createdAt;
  List<MeasureModel> measurements;
  int totalJobs;
  int pendingJobs;

  ContactModel({
    String id,
    String userID,
    this.fullname,
    this.phone,
    this.location,
    this.imageUrl,
    DateTime createdAt,
    List<MeasureModel> measurements,
    this.totalJobs = 0,
    this.pendingJobs = 0,
  })  : id = id ?? uuid(),
        createdAt = createdAt ?? DateTime.now(),
        userID = userID ?? Auth.getUser.uid,
        measurements = measurements != null && measurements.isNotEmpty ? measurements : createDefaultMeasures();

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    List<MeasureModel> measurements = [];
    if (json['measurements'] != null) {
      json['measurements'].forEach(
        (measure) => measurements.add(MeasureModel.fromJson(measure.cast<String, dynamic>())),
      );
    }
    return new ContactModel(
      id: json['id'],
      userID: json['userID'],
      fullname: json['fullname'],
      phone: json['phone'],
      location: json['location'],
      imageUrl: json['imageUrl'],
      measurements: measurements,
      totalJobs: int.tryParse(json['totalJobs'].toString()),
      pendingJobs: int.tryParse(json['pendingJobs'].toString()),
      createdAt: DateTime.tryParse(json['createdAt'].toString()),
    );
  }

  factory ContactModel.fromDoc(DocumentSnapshot doc) {
    return ContactModel.fromJson(doc.data)..reference = doc.reference;
  }

  toMap() {
    return {
      "id": id,
      "userID": userID,
      "fullname": fullname,
      "phone": phone,
      "location": location,
      "imageUrl": imageUrl,
      "createdAt": createdAt.toString(),
      "measurements": measurements.map((measure) => measure.toMap()).toList(),
      "totalJobs": totalJobs,
      "pendingJobs": pendingJobs,
    };
  }
}
