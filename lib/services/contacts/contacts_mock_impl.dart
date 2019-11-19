import 'dart:io';

import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/repository/models.dart';
import 'package:tailor_made/services/contacts/contacts.dart';

class ContactsMockImpl extends Contacts {
  @override
  Stream<List<ContactModel>> fetchAll(String userId) async* {
    yield [ContactModel((b) => b..userID = "1")];
  }

  @override
  Storage createFile(File file, String userId) {
    // TODO
    return null;
  }

  @override
  Reference fetch(ContactModel contact, String userId) {
    // TODO
    return null;
  }

  @override
  Stream<ContactModel> update(ContactModel contact, String userId) async* {
    // TODO
    yield null;
  }
}
