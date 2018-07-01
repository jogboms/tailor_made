import 'package:tailor_made/models/main.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/pages/jobs/models/measure.model.dart';

class JobModel extends Model {
  ContactModel contact;
  String name;
  double price;
  String notes;
  List<String> images;
  DateTime createdAt;
  List<MeasureModel> measurements;

  JobModel({
    this.contact,
    this.name,
    this.price,
    this.notes,
    this.images,
    this.createdAt,
    this.measurements,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    List<MeasureModel> measurements = [];
    if (json['measurements'] != null) {
      json['measurements'].forEach(
        (measure) => measurements.add(MeasureModel.fromJson(measure)),
      );
    }
    return new JobModel(
      contact: ContactModel.fromJson(json['contact']),
      name: json['name'],
      price: double.tryParse(json['price'].toString()),
      notes: json['notes'],
      images: json['images'],
      createdAt: DateTime.tryParse(json['createdAt']),
      measurements: measurements,
    );
  }

  @override
  toMap() {
    return {
      "contact": contact,
      "name": name,
      "price": price,
      "notes": notes,
      "images": images.toString(),
      "createdAt": createdAt.toString(),
      "measurements": measurements.toString(),
    };
  }
}
