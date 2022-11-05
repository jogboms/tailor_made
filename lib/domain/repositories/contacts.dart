import 'dart:io';

import '../entities.dart';
import '../models/contact.dart';

abstract class Contacts {
  Stream<List<ContactModel>> fetchAll(String? userId);

  Storage? createFile(File file, String userId);

  Future<Reference?> fetch(ContactModel contact, String userId);

  Stream<ContactModel> update(ContactModel contact, String userId);
}
