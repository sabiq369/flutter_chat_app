import 'package:chat_app/utils/user_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Api {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static User user = auth.currentUser!;
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    return await fireStore.collection("users").doc(user.uid).set({
      "id": user.uid,
      "name": user.displayName,
      "email": user.email,
      "image": Api.user.photoURL.toString(),
      "created_at": DateTime.now().millisecondsSinceEpoch.toString(),
      "is_online": false,
      "last_active": DateTime.now().millisecondsSinceEpoch.toString(),
      "push_toke": '',
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return fireStore
        .collection("users")
        .where("id", isNotEqualTo: user.uid)
        .snapshots();
  }
}
