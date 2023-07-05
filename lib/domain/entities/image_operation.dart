import 'create_image_data.dart';
import 'image_entity.dart';

sealed class ImageOperation {}

class CreateImageOperation implements ImageOperation {
  const CreateImageOperation({required this.data});

  final CreateImageData data;
}

class ModifyImageOperation implements ImageOperation {
  const ModifyImageOperation({required this.data});

  final ImageEntity data;
}
