import 'package:clock/clock.dart';
import 'package:tailor_made/domain.dart';
import 'package:uuid/uuid.dart';

class ContactsMockImpl extends Contacts {
  @override
  Stream<List<ContactEntity>> fetchAll(String? userId) async* {
    yield <ContactEntity>[
      ContactEntity(
        reference: const ReferenceEntity(id: 'id', path: 'path'),
        userID: '1',
        id: '',
        fullname: '',
        phone: '',
        location: '',
        imageUrl: '',
        createdAt: clock.now(),
      ),
    ];
  }

  @override
  Future<ImageFileReference> createFile({required String path, required String userId}) async {
    return (src: '', path: '');
  }

  @override
  Future<bool> deleteFile({required ImageFileReference reference, required String userId}) async {
    return true;
  }

  @override
  Future<ContactEntity> create(String userId, CreateContactData data) async {
    final String id = const Uuid().v4();
    return ContactEntity(
      reference: ReferenceEntity(id: id, path: 'path'),
      userID: '1',
      id: id,
      fullname: '',
      phone: '',
      location: '',
      imageUrl: '',
      createdAt: clock.now(),
    );
  }

  @override
  Future<bool> update(
    String userId, {
    required ReferenceEntity reference,
    String? fullname,
    String? phone,
    String? location,
    String? imageUrl,
    Map<String, double>? measurements,
  }) async =>
      true;
}
