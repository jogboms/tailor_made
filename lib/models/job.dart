import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/models/main.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/services/auth.dart';
import 'package:tailor_made/utils/mk_uuid.dart';

class JobModel extends Model {
  JobModel({
    String id,
    String userID,
    @required this.contactID,
    this.name,
    this.price,
    this.notes,
    this.images,
    this.completedPayment = 0.0,
    this.pendingPayment = 0.0,
    this.measurements = const {},
    this.payments = const [],
    this.isComplete = false,
    DateTime createdAt,
    DateTime dueAt,
  })  : id = id ?? uuid(),
        userID = userID ?? Auth.getUser.uid,
        createdAt = createdAt ?? DateTime.now(),
        dueAt = dueAt ?? DateTime.now().add(Duration(days: 7));

  factory JobModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    Map<String, double> measurements;
    if (json['measurements'] != null) {
      measurements = json['measurements'].cast<String, double>();
    }
    final List<PaymentModel> payments = [];
    if (json['payments'] != null) {
      json['payments'].forEach(
        (dynamic payment) => payments
            .add(PaymentModel.fromJson(payment.cast<String, dynamic>())),
      );
    }
    final List<ImageModel> images = [];
    if (json['images'] != null) {
      json['images'].forEach(
        (dynamic image) =>
            images.add(ImageModel.fromJson(image.cast<String, dynamic>())),
      );
    }
    return JobModel(
      id: json['id'],
      userID: json['userID'],
      contactID: json['contactID'],
      name: json['name'],
      price: double.tryParse(json['price'].toString()),
      pendingPayment: double.tryParse(json['pendingPayment'].toString()),
      completedPayment: double.tryParse(json['completedPayment'].toString()),
      notes: json['notes'],
      images: images,
      createdAt: DateTime.tryParse(json['createdAt'].toString()),
      dueAt: DateTime.tryParse(json['dueAt'].toString()),
      measurements: measurements,
      payments: payments,
      isComplete: json['isComplete'],
    );
  }

  factory JobModel.fromDoc(DocumentSnapshot doc) {
    return JobModel.fromJson(doc.data)..reference = doc.reference;
  }

  String id;
  String userID;
  String contactID;
  String name;
  double price;
  double completedPayment;
  double pendingPayment;
  String notes;
  List<ImageModel> images;
  Map<String, double> measurements;
  List<PaymentModel> payments;
  bool isComplete;
  DateTime createdAt;
  DateTime dueAt;

  // TODO implement others
  JobModel copyWith({
    String contactID,
    Map<String, double> measurements,
    DateTime dueAt,
  }) {
    return JobModel(
      id: this.id,
      userID: this.userID,
      contactID: contactID ?? this.contactID,
      measurements: measurements ?? this.measurements,
      createdAt: this.createdAt,
      dueAt: dueAt ?? this.dueAt,
    )..reference = this.reference;
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userID': userID,
      'contactID': contactID,
      'name': name,
      'price': price,
      'completedPayment': completedPayment,
      'pendingPayment': pendingPayment,
      'notes': notes,
      'images': images.map((image) => image.toMap()).toList(),
      'createdAt': createdAt.toString(),
      'dueAt': dueAt.toString(),
      'measurements': measurements,
      'payments': payments.map((payment) => payment.toMap()).toList(),
      'isComplete': isComplete,
    };
  }
}
