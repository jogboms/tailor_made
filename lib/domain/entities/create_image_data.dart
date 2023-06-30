import 'package:equatable/equatable.dart';

class CreateImageData with EquatableMixin {
  const CreateImageData({
    required this.userID,
    required this.contactID,
    required this.jobID,
    required this.path,
    required this.src,
  });

  final String userID;
  final String contactID;
  final String jobID;
  final String path;
  final String src;

  @override
  List<Object> get props => <Object>[userID, contactID, jobID, path, src];
}
