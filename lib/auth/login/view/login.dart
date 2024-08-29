import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/auth/login/controller/login_controller.dart';
import 'package:chat_app/auth/sign_up/view/sign_up.dart';
import 'package:chat_app/chat_list/view/chat_list.dart';
import 'package:chat_app/utils/api.dart';
import 'package:chat_app/utils/widgets/common_functions.dart';
import 'package:chat_app/utils/widgets/textField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController();
  LoginController loginController = Get.put(LoginController());

  handleGoogleButtonClick() {
    signInWithGoogle().then((user) async {
      if (user != null) {
        print('User: ${user.user}');
        print('User additional information: ${user.additionalUserInfo}');
        if ((await Api.fireStore.collection("users").doc(Api.user.uid).get())
            .exists) {
          Get.off(() => ChatList());
        } else {
          await Api.createUser().then(
            (value) {
              Get.off(() => ChatList());
            },
          );
        }
      }
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await Api.auth.signInWithCredential(credential);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: CachedNetworkImage(
                      imageUrl:
                          "https://img.freepik.com/free-vector/access-control-system-abstract-concept_335657-3180.jpg"),
                ),
                CommonTextField(
                  controller: emailController,
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email),
                ),
                SizedBox(height: 20),
                CommonTextField(
                  controller: passwordController,
                  hintText: 'Enter your password',
                  prefixIcon: Icon(Icons.lock),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => handleGoogleButtonClick(),
                  icon: Image.asset("assets/google_icon.webp", width: 50),
                ),
                SizedBox(height: 30),
                loginController.isLoading.value
                    ? loadingButton(context)
                    : ElevatedButton(
                        onPressed: () => loginController.login(
                            email: emailController.text,
                            password: passwordController.text),
                        style: ElevatedButton.styleFrom(
                          fixedSize:
                              Size(MediaQuery.of(context).size.width, 50),
                          backgroundColor: Color(0xff1e8bf2),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                        onPressed: () => Get.to(() => SignUpScreen()),
                        child: Text(
                          'Signup',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.black),
                        )),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        )),
      );
    });
  }
}
