import 'package:flutter/foundation.dart';
import 'package:tailor_made/models/main.dart';
import 'package:tailor_made/services/auth.dart';
import 'package:tailor_made/utils/mk_uuid.dart';

class PaymentModel extends Model {
  PaymentModel({
    String id,
    String userID,
    @required this.contactID,
    @required this.jobID,
    @required this.price,
    @required this.notes,
    DateTime createdAt,
  })  : id = id ?? uuid(),
        userID = userID ?? Auth.getUser.uid,
        createdAt = createdAt ?? DateTime.now();

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    return PaymentModel(
      id: json['id'],
      userID: json['userID'],
      contactID: json['contactID'],
      jobID: json['jobID'],
      price: double.tryParse(json['price'].toString()),
      notes: json['notes'],
      createdAt: DateTime.tryParse(json['createdAt'].toString()),
    );
  }

  String id;
  String userID;
  String contactID;
  String jobID;
  double price;
  String notes;
  DateTime createdAt;

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userID': userID,
      'contactID': contactID,
      'jobID': jobID,
      'price': price,
      'notes': notes,
      'createdAt': createdAt.toString(),
    };
  }
}
