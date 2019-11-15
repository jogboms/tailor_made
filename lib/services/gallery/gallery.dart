import 'dart:io';

import 'package:injector/injector.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/repository/main.dart';
import 'package:tailor_made/repository/models.dart';

abstract class Gallery<T extends Repository> {
  Gallery() : repository = Injector.appInstance.getDependency<Repository>();

  final T repository;

  static Gallery di() => Injector.appInstance.getDependency<Gallery>();

  Stream<List<ImageModel>> fetchAll();

  Storage createFile(File file);
}
