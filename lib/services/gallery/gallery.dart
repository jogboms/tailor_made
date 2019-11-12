import 'dart:io';

import 'package:injector/injector.dart';
import 'package:tailor_made/firebase/models.dart';
import 'package:tailor_made/models/image.dart';

abstract class Gallery {
  static Gallery di() => Injector.appInstance.getDependency<Gallery>();

  Stream<List<ImageModel>> fetchAll();

  Storage createFile(File file);
}
