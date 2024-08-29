import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/auth/login/view/login.dart';
import 'package:chat_app/chat_list/view/chat_list.dart';
import 'package:chat_app/utils/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: 2),
      () async {
        if (Api.auth.currentUser != null) {
          Get.off(() => ChatList());
        } else {
          Get.off(() => LoginScreen());
        }
      },
    );
    return Scaffold(
      backgroundColor: Color(0xff1a75bd),
      body: Center(
        child: CachedNetworkImage(
            imageUrl:
                "https://engineering.fb.com/wp-content/uploads/2009/02/chat.jpg"),
      ),
    );
  }
}
