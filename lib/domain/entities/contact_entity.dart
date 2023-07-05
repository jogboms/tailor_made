import 'package:equatable/equatable.dart';

import 'reference_entity.dart';

class ContactEntity with EquatableMixin {
  const ContactEntity({
    required this.reference,
    required this.id,
    required this.userID,
    required this.fullname,
    required this.phone,
    required this.location,
    required this.imageUrl,
    required this.createdAt,
    this.measurements = const <String, double>{},
    this.totalJobs = 0,
    this.pendingJobs = 0,
  });

  final ReferenceEntity reference;
  final String id;
  final String userID;
  final String fullname;
  final String phone;
  final String location;
  final String? imageUrl;
  final DateTime createdAt;
  final Map<String, double> measurements;
  final int totalJobs;
  final int pendingJobs;

  @override
  List<Object?> get props => <Object?>[
        reference,
        id,
        userID,
        fullname,
        phone,
        location,
        imageUrl,
        createdAt,
        measurements,
        totalJobs,
        pendingJobs,
      ];
}
