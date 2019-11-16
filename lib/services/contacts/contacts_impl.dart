import 'dart:io';

import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/repository/firebase/main.dart';
import 'package:tailor_made/repository/firebase/models.dart';
import 'package:tailor_made/services/contacts/contacts.dart';

class ContactsImpl extends Contacts {
  ContactsImpl(this.repository);

  final FirebaseRepository repository;

  @override
  Stream<List<ContactModel>> fetchAll(String userId) {
    return repository.db.contacts(userId).snapshots().map((snapshot) => snapshot.documents
        .where((doc) => doc.data.containsKey('fullname'))
        .map((item) => ContactModel.fromSnapshot(FireSnapshot(item)))
        .toList());
  }

  @override
  FireStorage createFile(File file, String userId) {
    return FireStorage(repository.storage.createContactImage(userId)..putFile(file));
  }

  @override
  FireReference fetch(ContactModel contact, String userId) {
    return FireReference(repository.db.contacts(userId).reference().document(contact.id));
  }

  @override
  Stream<ContactModel> update(ContactModel contact, String userId) {
    final ref = repository.db.contacts(userId).reference().document(contact.id);
    ref.setData(contact.toMap()).then((r) {});
    return ref.snapshots().map((doc) => ContactModel.fromSnapshot(FireSnapshot(doc)));
  }
}
