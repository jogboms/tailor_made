import 'package:equatable/equatable.dart';

import 'reference_entity.dart';

class PaymentEntity with EquatableMixin {
  const PaymentEntity({
    required this.reference,
    required this.id,
    required this.userID,
    required this.contactID,
    required this.jobID,
    required this.price,
    required this.notes,
    required this.createdAt,
  });

  final ReferenceEntity reference;
  final String id;
  final String userID;
  final String contactID;
  final String jobID;
  final double price;
  final String notes;
  final DateTime createdAt;

  @override
  List<Object> get props => <Object>[reference, id, userID, contactID, jobID, price, notes, createdAt];
}
