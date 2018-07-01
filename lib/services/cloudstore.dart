import 'package:cloud_firestore/cloud_firestore.dart';

class Cloudstore {
  Cloudstore._();

  static CollectionReference contacts = Firestore.instance.collection("contacts");
}
