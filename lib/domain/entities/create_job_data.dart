import 'package:equatable/equatable.dart';
import 'package:tailor_made/domain.dart';

class CreateJobData with EquatableMixin {
  const CreateJobData({
    required this.id,
    required this.userID,
    required this.contactID,
    required this.price,
    this.name = '',
    this.completedPayment = 0.0,
    this.pendingPayment = 0.0,
    this.notes = '',
    this.images = const <ImageEntity>[],
    this.measurements = const <String, double>{},
    this.payments = const <PaymentEntity>[],
    this.isComplete = false,
    required this.createdAt,
    required this.dueAt,
  });

  final String id;
  final String userID;
  final String? contactID;
  final double price;
  final String name;
  final double completedPayment;
  final double pendingPayment;
  final String notes;
  final List<ImageEntity> images;
  final Map<String, double> measurements;
  final List<PaymentEntity> payments;
  final bool isComplete;
  final DateTime createdAt;
  final DateTime dueAt;

  @override
  List<Object?> get props => <Object?>[
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

  CreateJobData copyWith({
    String? userID,
    String? contactID,
    double? price,
    String? name,
    double? completedPayment,
    double? pendingPayment,
    String? notes,
    List<ImageEntity>? images,
    Map<String, double>? measurements,
    List<PaymentEntity>? payments,
    bool? isComplete,
    DateTime? createdAt,
    DateTime? dueAt,
  }) {
    return CreateJobData(
      id: id,
      userID: userID ?? this.userID,
      contactID: contactID ?? this.contactID,
      price: price ?? this.price,
      name: name ?? this.name,
      completedPayment: completedPayment ?? this.completedPayment,
      pendingPayment: pendingPayment ?? this.pendingPayment,
      notes: notes ?? this.notes,
      images: images ?? this.images,
      measurements: measurements ?? this.measurements,
      payments: payments ?? this.payments,
      isComplete: isComplete ?? this.isComplete,
      createdAt: createdAt ?? this.createdAt,
      dueAt: dueAt ?? this.dueAt,
    );
  }
}
