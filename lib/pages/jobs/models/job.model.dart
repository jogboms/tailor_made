import 'package:tailor_made/models/main.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/pages/jobs/models/measure.model.dart';
import 'package:tailor_made/utils/tm_uuid.dart';

class JobModel extends Model {
  String id;
  ContactModel contact;
  String name;
  double price;
  String notes;
  List<String> images;
  DateTime createdAt;
  List<MeasureModel> measurements;

  JobModel({
    id,
    this.contact,
    this.name,
    this.price,
    this.notes,
    this.images,
    createdAt,
    this.measurements,
  })  : id = id ?? uuid(),
        createdAt = createdAt ?? DateTime.now();

  factory JobModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    List<MeasureModel> measurements = [];
    if (json['measurements'] != null) {
      json['measurements'].forEach(
        (measure) => measurements.add(MeasureModel.fromJson(measure.cast<String, dynamic>())),
      );
    }
    return new JobModel(
      id: json['id'],
      contact: ContactModel.fromJson(json['contact'].cast<String, dynamic>()),
      name: json['name'],
      price: double.tryParse(json['price'].toString()),
      notes: json['notes'],
      images: json['images'].cast<String>(),
      createdAt: DateTime.tryParse(json['createdAt'].toString()),
      measurements: measurements,
    );
  }

  @override
  toMap() {
    return {
      "id": id,
      "contact": contact.toMap(),
      "name": name,
      "price": price,
      "notes": notes,
      "images": images,
      "createdAt": createdAt.toString(),
      "measurements": measurements.map((measure) => measure.toMap()).toList(),
    };
  }
}
