import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tailor_made/services/auth.dart';

class CloudDb {
  CloudDb._();

  static Firestore instance = Firestore.instance;

  static String get authUserId => Auth.getUser?.uid ?? "0";

  static DocumentReference get account =>
      instance.document('accounts/$authUserId');
  static DocumentReference get stats => instance.document('stats/$authUserId');
  static DocumentReference get settings => instance.document('settings/common');

  static CollectionReference get measurements =>
      instance.collection('measurements/$authUserId/common');

  static CollectionReference get premium => instance.collection('premium');

  static Query get gallery =>
      instance.collection('gallery').where('userID', isEqualTo: authUserId);
  static CollectionReference get galleryRef => gallery.reference();

  static Query get payments =>
      instance.collection('payments').where('userID', isEqualTo: authUserId);
  static CollectionReference get paymentsRef => payments.reference();

  static Query get contacts =>
      instance.collection('contacts').where('userID', isEqualTo: authUserId);
  static CollectionReference get contactsRef => contacts.reference();

  static Query get jobs =>
      instance.collection('jobs').where('userID', isEqualTo: authUserId);
  static CollectionReference get jobsRef => jobs.reference();
}
