import 'dart:io';

import 'package:tailor_made/domain.dart';

import '../../network/firebase.dart';
import '../derive_map_from_data.dart';

class ContactsImpl extends Contacts {
  ContactsImpl(this.repository);

  final FirebaseRepository repository;

  @override
  Stream<List<ContactModel>> fetchAll(String? userId) {
    return repository.db.contacts(userId).snapshots().map(
          (MapQuerySnapshot snapshot) => snapshot.docs
              .where((MapQueryDocumentSnapshot doc) => doc.data().containsKey('fullname'))
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
    final MapQuerySnapshot future = await repository.db.contacts(userId).get();
    return FireReference(future.docs.first.reference);
  }

  @override
  Stream<ContactModel> update(ContactModel contact, String userId) {
    final MapDocumentReference ref = repository.db.contacts(userId).firestore.doc(contact.id);
    ref.set(contact.toJson()).then((_) {});
    return ref.snapshots().map(_deriveContactModel);
  }
}

ContactModel _deriveContactModel(MapDocumentSnapshot snapshot) {
  final DynamicMap data = snapshot.data()!;
  return ContactModel(
    reference: FireReference(snapshot.reference),
    id: data['id'] as String,
    userID: data['userID'] as String,
    fullname: data['fullname'] as String,
    phone: data['phone'] as String?,
    location: data['location'] as String?,
    imageUrl: data['imageUrl'] as String?,
    createdAt: DateTime.parse(data['createdAt'] as String),
    measurements: deriveMapFromMap(data['measurements'], (dynamic value) => value as double? ?? 0.0),
    totalJobs: data['totalJobs'] as int,
    pendingJobs: data['pendingJobs'] as int,
  );
}
