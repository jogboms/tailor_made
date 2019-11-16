import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/models/main.dart';
import 'package:tailor_made/models/serializers.dart';
import 'package:uuid/uuid.dart';

part 'image.g.dart';

abstract class ImageModel with ModelInterface implements Built<ImageModel, ImageModelBuilder> {
  factory ImageModel([void updates(ImageModelBuilder b)]) = _$ImageModel;

  ImageModel._();

  static void _initializeBuilder(ImageModelBuilder b) => b
    ..id = Uuid().v1()
    ..userID = Dependencies.di().session.getUserId()
    ..createdAt = DateTime.now();

  String get id;

  String get userID;

  String get contactID;

  String get jobID;

  String get path;

  String get src;

  DateTime get createdAt;

  @override
  Map<String, dynamic> toMap() => serializers.serializeWith(ImageModel.serializer, this);

  static ImageModel fromJson(Map<String, dynamic> map) => serializers.deserializeWith(ImageModel.serializer, map);

  static Serializer<ImageModel> get serializer => _$imageModelSerializer;
}
