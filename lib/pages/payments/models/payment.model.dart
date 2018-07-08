import 'package:tailor_made/models/main.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/utils/tm_uuid.dart';

class PaymentModel extends Model {
  String id;
  ContactModel contact;
  double price;
  String notes;
  DateTime createdAt;

  PaymentModel({
    id,
    this.contact,
    this.price,
    this.notes,
    createdAt,
  })  : id = id ?? uuid(),
        createdAt = createdAt ?? DateTime.now();

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    return new PaymentModel(
      id: json['id'],
      contact: ContactModel.fromJson(json['contact'].cast<String, dynamic>()),
      price: double.tryParse(json['price'].toString()),
      notes: json['notes'],
      createdAt: DateTime.tryParse(json['createdAt'].toString()),
    );
  }

  @override
  toMap() {
    return {
      "id": id,
      "contact": contact.toMap(),
      "price": price,
      "notes": notes,
      "documentID": documentID,
      "createdAt": createdAt.toString(),
    };
  }
}
