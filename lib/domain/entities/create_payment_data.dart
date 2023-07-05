import 'package:equatable/equatable.dart';

class CreatePaymentData with EquatableMixin {
  const CreatePaymentData({
    required this.userID,
    required this.contactID,
    required this.jobID,
    required this.price,
    required this.notes,
  });

  final String userID;
  final String contactID;
  final String jobID;
  final double price;
  final String notes;

  @override
  List<Object> get props => <Object>[userID, contactID, jobID, price, notes];
}
