import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:injector/injector.dart';
import 'package:tailor_made/models/image.dart';

abstract class Gallery {
  static Gallery di() {
    return Injector.appInstance.getDependency<Gallery>();
  }

  Stream<List<ImageModel>> fetchAll();

  StorageReference createFile(File file);
}
