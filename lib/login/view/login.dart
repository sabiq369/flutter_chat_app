import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/login/controller/login_controller.dart';
import 'package:chat_app/sign_up/view/sign_up.dart';
import 'package:chat_app/utils/widgets/common_functions.dart';
import 'package:chat_app/utils/widgets/textField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController();
  LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
                      "https://img.freepik.com/free-vector/access-control-system-abstract-concept_335657-3180.jpg"),
              Spacer(),
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
              SizedBox(height: 15),
              Spacer(flex: 6),
              loginController.isLoading.value
                  ? loadingButton(context)
                  : ElevatedButton(
                      onPressed: () => loginController.login(
                          email: emailController.text,
                          password: passwordController.text),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(MediaQuery.of(context).size.width, 50),
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
              Spacer(flex: 10)
            ],
          ),
        )),
      );
    });
  }
}
