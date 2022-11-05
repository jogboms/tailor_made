import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tailor_made/domain.dart';

import '../../network/firebase.dart';

class ContactsImpl extends Contacts {
  ContactsImpl(this.repository);

  final FirebaseRepository repository;

  @override
  Stream<List<ContactModel>> fetchAll(String? userId) {
    return repository.db.contacts(userId).snapshots().map(
          (QuerySnapshot<Map<String, dynamic>> snapshot) => snapshot.docs
              .where((QueryDocumentSnapshot<Map<String, dynamic>> doc) => doc.data().containsKey('fullname'))
              .map(_deriveContactModel)
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
    final DocumentReference<Map<String, dynamic>> ref = repository.db.contacts(userId).firestore.doc(contact.id);
    ref.set(contact.toJson()).then((_) {});
    return ref.snapshots().map(_deriveContactModel);
  }
}

ContactModel _deriveContactModel(DocumentSnapshot<Map<String, dynamic>> snapshot) {
  final Map<String, dynamic> data = snapshot.data()!;
  return ContactModel(
    reference: FireReference(snapshot.reference),
    id: data['id'] as String,
    userID: data['userID'] as String,
    fullname: data['fullname'] as String,
    phone: data['phone'] as String?,
    location: data['location'] as String?,
    imageUrl: data['imageUrl'] as String?,
    createdAt: data['createdAt'] as DateTime,
    measurements: data['measurements'] as Map<String, double>? ?? <String, double>{},
    totalJobs: data['totalJobs'] as int,
    pendingJobs: data['pendingJobs'] as int,
  );
}
