import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tailor_made/services/auth.dart';

class Cloudstore {
  static Firestore instance = Firestore.instance;

  Cloudstore._();

  static DocumentReference get account => instance.document("accounts/${Auth.getUser.uid}");
  static DocumentReference get stats => instance.document("stats/${Auth.getUser.uid}");
  static CollectionReference get gallery => instance.collection("gallery").where("userID", isEqualTo: Auth.getUser.uid).reference();
  static CollectionReference get payments => instance.collection("payments").where("userID", isEqualTo: Auth.getUser.uid).reference();
  static CollectionReference get contacts => instance.collection("contacts").where("userID", isEqualTo: Auth.getUser.uid).reference();
  static CollectionReference get jobs => instance.collection("jobs").where("userID", isEqualTo: Auth.getUser.uid).reference();
}
