import '../data/network/firebase/models.dart';

export 'entities/account_entity.dart';
export 'entities/contact_entity.dart';
export 'entities/create_contact_data.dart';
export 'entities/create_job_data.dart';
export 'entities/image_entity.dart';
export 'entities/job_entity.dart';
export 'entities/measure_entity.dart';
export 'entities/measure_group.dart';
export 'entities/payment_entity.dart';
export 'entities/reference_entity.dart';
export 'entities/setting_entity.dart';

abstract class Snapshot {
  Map<String, dynamic>? get data;
  Reference get reference;
}

abstract class User {
  String get uid;
}

abstract class Storage {
  Future<void> delete();

  Future<String> getDownloadURL();

  String get path;
}

abstract class Reference {
  MapDocumentReference get source;

  @Deprecated('refactor!')
  Future<void> delete();

  @Deprecated('refactor!')
  Future<void> updateData(Map<String, dynamic> data);
}
