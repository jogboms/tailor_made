import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tailor_made/firebase/auth.dart';

class CloudDb {
  static final Firestore _instance = Firestore.instance;

  static String get _authUserId => Auth.getUser?.uid ?? "0";

  static DocumentReference get account => _instance.document('accounts/$_authUserId');

  static DocumentReference get stats => _instance.document('stats/$_authUserId');

  static DocumentReference get settings => _instance.document('settings/common');

  static CollectionReference get measurements => _instance.collection('measurements/$_authUserId/common');

  static CollectionReference get premium => _instance.collection('premium');

  static Query get gallery => _instance.collection('gallery').where('userID', isEqualTo: _authUserId);

  static CollectionReference get galleryRef => gallery.reference();

  static Query get payments => _instance.collection('payments').where('userID', isEqualTo: _authUserId);

  static CollectionReference get paymentsRef => payments.reference();

  static Query get contacts => _instance.collection('contacts').where('userID', isEqualTo: _authUserId);

  static CollectionReference get contactsRef => contacts.reference();

  static Query get jobs => _instance.collection('jobs').where('userID', isEqualTo: _authUserId);

  static CollectionReference get jobsRef => jobs.reference();

  static Future<void> batchAction(void Function(WriteBatch batch) action) {
    final WriteBatch batch = _instance.batch();

    action(batch);

    return batch.commit();
  }
}
