import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/services/contacts/contacts.dart';

class ContactsMockImpl extends Contacts {
  @override
  Stream<List<ContactModel>> fetchAll() async* {
    // TODO
    yield null;
  }

  @override
  StorageReference createFile(File file) {
    // TODO
    return null;
  }

  @override
  DocumentReference fetch(ContactModel contact) {
    // TODO
    return null;
  }

  @override
  Stream<ContactModel> update(ContactModel contact) async* {
    // TODO
    yield null;
  }
}
