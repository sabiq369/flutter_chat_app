import 'package:chat_app/auth/login/view/login.dart';
import 'package:chat_app/services/firebase_services.dart';
import 'package:chat_app/utils/api.dart';
import 'package:chat_app/utils/widgets/common_functions.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  RxBool signOutLoading = false.obs;

  signOut() async {
    signOutLoading.value = true;
    var response = await AuthServices().signOut();
    if (response != null) {
      if (response) {
        signOutLoading.value = false;
        showToast(msg: 'Logged out successfully');
        Get.offAll(() => LoginScreen());
      } else {
        signOutLoading.value = false;
      }
    }
  }
}
