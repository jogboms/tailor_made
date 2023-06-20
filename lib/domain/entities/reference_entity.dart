import 'package:equatable/equatable.dart';

class ReferenceEntity with EquatableMixin {
  const ReferenceEntity({required this.id, required this.path});

  final String id;
  final String path;

  @override
  List<Object> get props => <Object>[id, path];

  @override
  bool? get stringify => true;
}
