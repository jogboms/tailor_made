import 'package:cloud_firestore/cloud_firestore.dart';

class Cloudstore {
  static Firestore instance = Firestore.instance;

  Cloudstore._();

  static CollectionReference contacts = instance.collection("contacts");
  static CollectionReference jobs = instance.collection("jobs");
}
