import 'package:equatable/equatable.dart';
import 'package:tailor_made/domain.dart';

class JobEntity with EquatableMixin {
  const JobEntity({
    required this.reference,
    required this.id,
    required this.userID,
    required this.contactID,
    required this.price,
    this.name = '',
    this.completedPayment = 0.0,
    this.pendingPayment = 0.0,
    this.notes = '',
    this.images = const <ImageModel>[],
    this.measurements = const <String, double>{},
    this.payments = const <PaymentEntity>[],
    this.isComplete = false,
    required this.createdAt,
    required this.dueAt,
  });

  final ReferenceEntity reference;
  final String id;
  final String userID;
  final String? contactID;
  final double price;
  final String name;
  final double completedPayment;
  final double pendingPayment;
  final String notes;
  final List<ImageModel> images;
  final Map<String, double> measurements;
  final List<PaymentEntity> payments;
  final bool isComplete;
  final DateTime createdAt;
  final DateTime dueAt;

  @override
  List<Object?> get props => <Object?>[
        reference,
        id,
        userID,
        contactID,
        price,
        name,
        completedPayment,
        pendingPayment,
        notes,
        images,
        measurements,
        payments,
        isComplete,
        createdAt,
        dueAt,
      ];
}
