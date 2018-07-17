import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tailor_made/services/auth.dart';

class CloudDb {
  static Firestore instance = Firestore.instance;

  CloudDb._();

  static DocumentReference get account => instance.document("accounts/${Auth.getUser.uid}");
  static DocumentReference get stats => instance.document("stats/${Auth.getUser.uid}");
  static DocumentReference get settings => instance.document("settings/common");

  static CollectionReference get premium => instance.collection("premium");

  static Query get gallery => instance.collection("gallery").where("userID", isEqualTo: Auth.getUser.uid);
  static CollectionReference get galleryRef => gallery.reference();

  static Query get payments => instance.collection("payments").where("userID", isEqualTo: Auth.getUser.uid);
  static CollectionReference get paymentsRef => payments.reference();

  static Query get contacts => instance.collection("contacts").where("userID", isEqualTo: Auth.getUser.uid);
  static CollectionReference get contactsRef => contacts.reference();

  static Query get jobs => instance.collection("jobs").where("userID", isEqualTo: Auth.getUser.uid);
  static CollectionReference get jobsRef => jobs.reference();
}
