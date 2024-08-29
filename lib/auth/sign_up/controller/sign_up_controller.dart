import 'package:chat_app/chat_list/view/chat_list.dart';
import 'package:chat_app/chat_page/view/chat_page.dart';
import 'package:chat_app/services/firebase_services.dart';
import 'package:chat_app/utils/api.dart';
import 'package:chat_app/utils/widgets/common_functions.dart';
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
    try {
      await AuthServices()
          .signUpUser(name: name, email: email, password: password);

      isLoading.value = false;

      Get.offAll(() => ChatList());
    } catch (e) {
      showToast(msg: e.toString());
      isLoading.value = false;
    }
  }
}
