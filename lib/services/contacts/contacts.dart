import 'dart:io';

import 'package:injector/injector.dart';
import 'package:tailor_made/firebase/models.dart';
import 'package:tailor_made/models/contact.dart';

abstract class Contacts {
  static Contacts di() => Injector.appInstance.getDependency<Contacts>();

  Stream<List<ContactModel>> fetchAll();

  Storage createFile(File file);

  Reference fetch(ContactModel contact);

  Stream<ContactModel> update(ContactModel contact);
}
