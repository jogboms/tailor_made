import 'dart:io';

import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/repository/firebase/main.dart';
import 'package:tailor_made/repository/firebase/models.dart';
import 'package:tailor_made/services/contacts/contacts.dart';
import 'package:tailor_made/services/session.dart';

class ContactsImpl extends Contacts<FirebaseRepository> {
  @override
  Stream<List<ContactModel>> fetchAll() {
    return repository.db.contacts(Session.di().getUserId()).snapshots().map((snapshot) => snapshot.documents
        .where((doc) => doc.data.containsKey('fullname'))
        .map((item) => ContactModel.fromSnapshot(FireSnapshot(item)))
        .toList());
  }

  @override
  FireStorage createFile(File file) {
    return FireStorage(repository.storage.createContactImage(Session.di().getUserId())..putFile(file));
  }

  @override
  FireReference fetch(ContactModel contact) {
    return FireReference(repository.db.contacts(Session.di().getUserId()).reference().document(contact.id));
  }

  @override
  Stream<ContactModel> update(ContactModel contact) {
    final ref = repository.db.contacts(Session.di().getUserId()).reference().document(contact.id);
    ref.setData(contact.toMap()).then((r) {});
    return ref.snapshots().map((doc) => ContactModel.fromSnapshot(FireSnapshot(doc)));
  }
}
