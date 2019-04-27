import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tailor_made/firebase/cloud_db.dart';
import 'package:tailor_made/firebase/cloud_storage.dart';
import 'package:tailor_made/firebase/models.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/services/contacts.dart';

class ContactsImpl extends Contacts {
  @override
  Stream<List<ContactModel>> fetchAll() {
    return CloudDb.contacts.snapshots().map(
          (snapshot) => snapshot.documents
              .where((doc) => doc.data.containsKey('fullname'))
              .map((item) => ContactModel.fromDoc(Snapshot.fromFire(item)))
              .toList(),
        );
  }

  @override
  StorageReference createFile(File file) {
    return CloudStorage.createContactImage()..putFile(file);
  }

  @override
  DocumentReference fetch(ContactModel contact) {
    return CloudDb.contactsRef.document(contact.id);
  }

  @override
  Stream<ContactModel> update(ContactModel contact) {
    final ref = CloudDb.contactsRef.document(contact.id);
    ref.setData(contact.toMap()).then((r) {});
    return ref.snapshots().map<ContactModel>(
          (doc) => ContactModel.fromDoc(Snapshot.fromFire(doc)),
        );
  }
}
