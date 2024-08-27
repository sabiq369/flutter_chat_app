import 'dart:ffi';

import 'package:chat_app/chat_list/view/chat_list.dart';
import 'package:chat_app/chat_page/view/chat_page.dart';
import 'package:chat_app/services/firebase_services.dart';
import 'package:chat_app/utils/widgets/common_functions.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;

  login({required String email, required String password}) async {
    isLoading.value = true;
    try {
      await AuthServices().signInUser(email: email, password: password);
      isLoading.value = false;
      Get.offAll(() => ChatList());
    } catch (e) {
      isLoading.value = false;
      showToast(msg: e.toString());
    }
  }
}
