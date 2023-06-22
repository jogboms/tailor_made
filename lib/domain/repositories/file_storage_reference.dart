// TODO: destroy this
abstract class FileStorageReference {
  Future<void> delete();

  Future<String> getDownloadURL();

  String get path;
}
