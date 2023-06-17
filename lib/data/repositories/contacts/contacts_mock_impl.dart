import 'dart:io';

import 'package:tailor_made/domain.dart';

class ContactsMockImpl extends Contacts {
  @override
  Stream<List<ContactModel>> fetchAll(String? userId) async* {
    yield <ContactModel>[
      ContactModel(
        userID: '1',
        id: '',
        phone: '',
        location: '',
        imageUrl: '',
        createdAt: DateTime.now(),
      ),
    ];
  }

  @override
  Storage? createFile(File file, String userId) {
    return null;
  }

  @override
  Future<Reference?> fetch(ContactModel contact, String userId) async {
    return null;
  }

  @override
  Stream<ContactModel> update(ContactModel contact, String userId) async* {}
}
