import 'dart:io';

import '../entities.dart';
import 'file_storage_reference.dart';

abstract class Contacts {
  Stream<List<ContactEntity>> fetchAll(String? userId);

  FileStorageReference? createFile(File file, String userId);

  Future<ContactEntity> create(String userId, CreateContactData data);

  Future<bool> update(
    String userId, {
    required ReferenceEntity reference,
    String? fullname,
    String? phone,
    String? location,
    String? imageUrl,
    Map<String, double>? measurements,
  });
}
