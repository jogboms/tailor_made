import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injector/injector.dart';
import 'package:tailor_made/models/contact.dart';

abstract class Contacts {
  static Contacts di() => Injector.appInstance.getDependency<Contacts>();

  Stream<List<ContactModel>> fetchAll();

  StorageReference createFile(File file);

  DocumentReference fetch(ContactModel contact);

  Stream<ContactModel> update(ContactModel contact);
}
