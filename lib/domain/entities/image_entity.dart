import 'package:equatable/equatable.dart';

import 'reference_entity.dart';

class ImageEntity with EquatableMixin {
  const ImageEntity({
    required this.reference,
    required this.id,
    required this.userID,
    required this.contactID,
    required this.jobID,
    required this.path,
    required this.src,
    required this.createdAt,
  });

  final ReferenceEntity reference;
  final String id;
  final String userID;
  final String contactID;
  final String jobID;
  final String path;
  final String src;
  final DateTime createdAt;

  @override
  List<Object> get props => <Object>[reference, id, userID, contactID, jobID, path, src, createdAt];
}
