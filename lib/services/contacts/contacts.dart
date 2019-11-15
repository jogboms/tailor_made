import 'dart:io';

import 'package:injector/injector.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/repository/main.dart';
import 'package:tailor_made/repository/models.dart';

abstract class Contacts<T extends Repository> {
  Contacts() : repository = Injector.appInstance.getDependency<Repository>();

  final T repository;

  static Contacts di() => Injector.appInstance.getDependency<Contacts>();

  Stream<List<ContactModel>> fetchAll();

  Storage createFile(File file);

  Reference fetch(ContactModel contact);

  Stream<ContactModel> update(ContactModel contact);
}
