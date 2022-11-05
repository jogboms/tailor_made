import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/repository/firebase/main.dart';
import 'package:tailor_made/repository/firebase/models.dart';
import 'package:tailor_made/services/contacts/contacts.dart';

class ContactsImpl extends Contacts {
  ContactsImpl(this.repository);

  final FirebaseRepository repository;

  @override
  Stream<List<ContactModel>> fetchAll(String? userId) {
    return repository.db.contacts(userId).snapshots().map(
          (QuerySnapshot<Map<String, dynamic>> snapshot) => snapshot.docs
              .where((QueryDocumentSnapshot<Map<String, dynamic>> doc) => doc.data().containsKey('fullname'))
              .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) => ContactModel.fromSnapshot(FireSnapshot(doc)))
              .toList(),
        );
  }

  @override
  FireStorage createFile(File file, String userId) {
    return FireStorage(repository.storage.createContactImage(userId)..putFile(file));
  }

  @override
  Future<FireReference> fetch(ContactModel contact, String userId) async {
    final QuerySnapshot<Map<String, dynamic>> future = await repository.db.contacts(userId).get();
    return FireReference(future.docs.first.reference);
  }

  @override
  Stream<ContactModel> update(ContactModel contact, String userId) {
    final DocumentReference<Map<String, dynamic>> ref = repository.db.contacts(userId).firestore.doc(contact.id!);
    ref.set(contact.toMap()).then((_) {});
    return ref
        .snapshots()
        .map((DocumentSnapshot<Map<String, dynamic>> doc) => ContactModel.fromSnapshot(FireSnapshot(doc)));
  }
}
