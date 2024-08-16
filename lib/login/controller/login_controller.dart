import 'package:chat_app/chat_list/view/chat_list.dart';
import 'package:chat_app/chat_page/view/chat_page.dart';
import 'package:chat_app/services/firebase_services.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;

  login({required String email, required String password}) async {
    isLoading.value = true;
    var response =
        await AuthServices().signInUser(email: email, password: password);
    if (response != null) {
      if (response) {
        isLoading.value = false;
        Get.offAll(() => ChatList());
      } else {
        isLoading.value = false;
      }
    }
  }
}
