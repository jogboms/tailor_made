import 'package:equatable/equatable.dart';
import 'package:tailor_made/domain.dart';

sealed class ImageFormValue {}

class ImageCreateFormValue with EquatableMixin implements ImageFormValue {
  ImageCreateFormValue(this.data);

  final CreateImageData data;

  @override
  List<Object> get props => <Object>[data];
}

class ImageModifyFormValue with EquatableMixin implements ImageFormValue {
  ImageModifyFormValue(this.data);

  final ImageEntity data;

  @override
  List<Object> get props => <Object>[data];
}
