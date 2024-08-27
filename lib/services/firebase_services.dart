import 'package:chat_app/utils/widgets/common_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _firestore.collection("users").doc(credential.user!.uid).set({
        "name": name,
        "email": email,
        "uid": credential.user!.uid,
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
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
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
      await _auth.signOut();
      return true;
    } catch (e) {
      showToast(msg: e.toString());
      return false;
    }
  }
}
