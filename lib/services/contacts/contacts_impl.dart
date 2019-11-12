import 'dart:io';

import 'package:tailor_made/firebase/cloud_db.dart';
import 'package:tailor_made/firebase/cloud_storage.dart';
import 'package:tailor_made/firebase/models.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/services/contacts/contacts.dart';

class ContactsImpl extends Contacts {
  @override
  Stream<List<ContactModel>> fetchAll() {
    return CloudDb.contacts.snapshots().map((snapshot) => snapshot.documents
        .where((doc) => doc.data.containsKey('fullname'))
        .map((item) => ContactModel.fromSnapshot(Snapshot(item)))
        .toList());
  }

  @override
  Storage createFile(File file) {
    return Storage(CloudStorage.createContactImage()..putFile(file));
  }

  @override
  Reference fetch(ContactModel contact) {
    return Reference(CloudDb.contacts.reference().document(contact.id));
  }

  @override
  Stream<ContactModel> update(ContactModel contact) {
    final ref = CloudDb.contacts.reference().document(contact.id);
    ref.setData(contact.toMap()).then((r) {});
    return ref.snapshots().map((doc) => ContactModel.fromSnapshot(Snapshot(doc)));
  }
}
