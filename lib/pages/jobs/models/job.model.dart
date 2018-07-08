import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tailor_made/models/main.dart';
import 'package:tailor_made/pages/gallery/models/image.model.dart';
import 'package:tailor_made/pages/jobs/models/measure.model.dart';
import 'package:tailor_made/pages/payments/models/payment.model.dart';
import 'package:tailor_made/utils/tm_uuid.dart';

class JobModel extends Model {
  String id;
  String contactID;
  String name;
  double price;
  double completedPayment;
  double pendingPayment;
  String notes;
  List<ImageModel> images;
  DateTime createdAt;
  List<MeasureModel> measurements;
  List<PaymentModel> payments;
  bool isComplete;

  JobModel({
    id,
    this.contactID,
    this.name,
    this.price,
    this.notes,
    this.images,
    this.completedPayment = 0.0,
    this.pendingPayment = 0.0,
    createdAt,
    this.measurements = const [],
    this.payments = const [],
    this.isComplete = false,
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
    List<PaymentModel> payments = [];
    if (json['payments'] != null) {
      json['payments'].forEach(
        (payment) => payments.add(PaymentModel.fromJson(payment.cast<String, dynamic>())),
      );
    }
    List<ImageModel> images = [];
    if (json['images'] != null) {
      json['images'].forEach(
        (image) => images.add(ImageModel.fromJson(image.cast<String, dynamic>())),
      );
    }
    return new JobModel(
      id: json['id'],
      contactID: json['contactID'],
      name: json['name'],
      price: double.tryParse(json['price'].toString()),
      pendingPayment: double.tryParse(json['pendingPayment'].toString()),
      completedPayment: double.tryParse(json['completedPayment'].toString()),
      notes: json['notes'],
      images: images,
      createdAt: DateTime.tryParse(json['createdAt'].toString()),
      measurements: measurements,
      payments: payments,
      isComplete: json['isComplete'],
    );
  }

  factory JobModel.fromDoc(DocumentSnapshot doc) {
    return JobModel.fromJson(doc.data)
      ..reference = doc.reference
      ..documentID = doc.documentID;
  }

  @override
  toMap() {
    return {
      "id": id,
      "contactID": contactID,
      "name": name,
      "price": price,
      "completedPayment": completedPayment,
      "pendingPayment": pendingPayment,
      "notes": notes,
      "documentID": documentID,
      "images": images.map((image) => image.toMap()).toList(),
      "createdAt": createdAt.toString(),
      "measurements": measurements.map((measure) => measure.toMap()).toList(),
      "payments": payments.map((payment) => payment.toMap()).toList(),
      "isComplete": isComplete,
    };
  }
}
