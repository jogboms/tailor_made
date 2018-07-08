import 'package:tailor_made/models/main.dart';
import 'package:tailor_made/utils/tm_uuid.dart';

class PaymentModel extends Model {
  String id;
  String contactID;
  double price;
  String notes;
  DateTime createdAt;

  PaymentModel({
    id,
    this.contactID,
    this.price,
    this.notes,
    createdAt,
  })  : id = id ?? uuid(),
        createdAt = createdAt ?? DateTime.now();

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    return new PaymentModel(
      id: json['id'],
      contactID: json['contactID'],
      price: double.tryParse(json['price'].toString()),
      notes: json['notes'],
      createdAt: DateTime.tryParse(json['createdAt'].toString()),
    );
  }

  @override
  toMap() {
    return {
      "id": id,
      "contactID": contactID,
      "price": price,
      "notes": notes,
      "createdAt": createdAt.toString(),
    };
  }
}
