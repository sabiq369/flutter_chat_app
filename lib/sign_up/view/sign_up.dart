import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/utils/widgets/textField.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController(),
      nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CachedNetworkImage(
                imageUrl:
                    "https://cdni.iconscout.com/illustration/premium/thumb/sign-up-illustration-download-in-svg-png-gif-file-formats--log-register-form-user-interface-pack-design-development-illustrations-6430773.png"),
            Spacer(),
            CommonTextField(
              controller: nameController,
              hintText: 'Enter your name',
              prefixIcon: Icon(Icons.person),
            ),
            SizedBox(height: 20),
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
            Spacer(flex: 6),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width, 50),
                  backgroundColor: Color(0xff1e8bf2),
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Login',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.black),
                    )),
              ],
            ),
            Spacer(flex: 10)
          ],
        ),
      )),
    );
  }
}
