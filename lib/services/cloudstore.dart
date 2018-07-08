import 'package:cloud_firestore/cloud_firestore.dart';

class Cloudstore {
  static Firestore instance = Firestore.instance;

  Cloudstore._();

  static DocumentReference stats = instance.document("stats/current");
  static CollectionReference gallery = instance.collection("gallery");
  static CollectionReference payments = instance.collection("payments");
  static CollectionReference contacts = instance.collection("contacts");
  static CollectionReference jobs = instance.collection("jobs");
}
