import 'package:chat_app/utils/api.dart';
import 'package:chat_app/utils/widgets/common_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  Future<UserCredential> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential = await Api.auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await Api.fireStore.collection("users").doc(credential.user!.uid).set({
        "id": credential.user!.uid,
        "name": name,
        "email": email,
        "image": "",
        "created_at": DateTime.now().millisecondsSinceEpoch.toString(),
        "is_online": false,
        "last_active": DateTime.now().millisecondsSinceEpoch.toString(),
        "push_toke": '',
      });

      showToast(msg: "Successfully registered");
      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserCredential> signInUser(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await Api.auth
          .signInWithEmailAndPassword(email: email, password: password);
      showToast(msg: 'Login successful');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // showToast(msg: e.toString());
      throw Exception(e.code);
    }
  }

  // for signOut
  Future signOut() async {
    try {
      await Api.auth.signOut();
      await GoogleSignIn().signOut();
      return true;
    } catch (e) {
      showToast(msg: e.toString());
      return false;
    }
  }
}
