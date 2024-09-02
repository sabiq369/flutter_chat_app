import 'package:chat_app/chat_page/view/chat_page.dart';
import 'package:get/get.dart';

class ChatListController extends GetxController {
  RxBool search = false.obs;
  RxString searchString = ''.obs;

  goToChatRoom({
    required name,
    required profileImage,
    required recieverId,
    required senderId,
  }) {
    List<String> sortedIds = [senderId, recieverId]..sort();
    Get.to(ChatPage(
        name: name,
        recieverId: recieverId,
        profileImage: profileImage,
        chatroomId: sortedIds.toString()));
  }

  @override
  void onInit() {
    super.onInit();
  }
}
