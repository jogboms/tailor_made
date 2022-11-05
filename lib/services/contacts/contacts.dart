import 'dart:io';

import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/repository/models.dart';

abstract class Contacts {
  Stream<List<ContactModel>> fetchAll(String? userId);

  Storage? createFile(File file, String userId);

  Future<Reference?> fetch(ContactModel contact, String userId);

  Stream<ContactModel> update(ContactModel contact, String userId);
}
