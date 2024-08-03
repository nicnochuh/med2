import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  static String emer = '';
  static String username = '';

  static Future<void> initialize() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final usersCollection = FirebaseFirestore.instance.collection("users");

    final userDoc = await usersCollection.doc(currentUser.email).get();
    if (userDoc.exists) {
      final userdata = userDoc.data()!;
      username = userdata['username'];
      emer = userdata['emer'];
    }
  }

  static Future<void> updateField(String field, String value) async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final usersCollection = FirebaseFirestore.instance.collection("users");

    await usersCollection.doc(currentUser.email).update({field: value});
    if (field == 'emer') {
      emer = value;
    } else if (field == 'username') {
      username = value;
    }
  }
}
