import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  final CollectionReference WFMCollection =
      FirebaseFirestore.instance.collection('Shoppers');

  Future updateUserData(
      String job, String name, DateTime off, DateTime shift) async {
    return await WFMCollection.doc(uid).set({
      'job': job,
      'name': name,
      'break': off,
      'shift': shift,
    });
  }
}
