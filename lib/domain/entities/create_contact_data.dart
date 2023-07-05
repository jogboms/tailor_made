import 'package:equatable/equatable.dart';

import 'reference_entity.dart';

class CreateContactData with EquatableMixin {
  const CreateContactData({
    required this.fullname,
    required this.phone,
    required this.location,
    required this.imageUrl,
    this.measurements = const <String, double>{},
  });

  final String fullname;
  final String phone;
  final String location;
  final String? imageUrl;
  final Map<String, double> measurements;

  @override
  List<Object?> get props => <Object?>[fullname, phone, location, imageUrl, measurements];

  CreateContactData copyWith({
    ReferenceEntity? reference,
    String? fullname,
    String? phone,
    String? location,
    String? imageUrl,
    Map<String, double>? measurements,
  }) {
    return CreateContactData(
      fullname: fullname ?? this.fullname,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      measurements: measurements ?? this.measurements,
    );
  }
}
