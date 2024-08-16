import 'package:chat_app/utils/widgets/common_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  // for storing data in cloud firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // for authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // for signUp
  Future signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // for registering user in firebase auth with email and password
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // for adding user to cloud firestore
      await _firestore.collection("users").doc(credential.user!.uid).set({
        "name": name,
        "email": email,
        "uid": credential.user!.uid,
      });

      showToast(msg: "Successfully registered");
      return true;
    } catch (e) {
      showToast(msg: e.toString());
      return false;
    }
  }

// for login
  Future signInUser({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      showToast(msg: 'Login successful');
      return true;
    } catch (e) {
      showToast(msg: e.toString());
      return false;
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
