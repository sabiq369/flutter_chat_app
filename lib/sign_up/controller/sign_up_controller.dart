import 'package:chat_app/chat_list/view/chat_list.dart';
import 'package:chat_app/chat_page/view/chat_page.dart';
import 'package:chat_app/services/firebase_services.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  RxBool isLoading = false.obs;

  signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    print('|||||||||| user credentials |||||||||');
    print(name);
    print(email);
    print(password);
    isLoading.value = true;
    var response = await AuthServices()
        .signUpUser(name: name, email: email, password: password);
    print('|||||||||| response ||||||||||');
    print(response);
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
