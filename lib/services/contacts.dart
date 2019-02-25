import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/firebase/cloud_db.dart';

class Contacts {
  static Stream<List<ContactModel>> fetchAll() {
    return CloudDb.contacts.snapshots().map(
          (snapshot) => snapshot.documents
              .where((doc) => doc.data.containsKey('fullname'))
              .map((item) => ContactModel.fromDoc(item))
              .toList(),
        );
  }
}
