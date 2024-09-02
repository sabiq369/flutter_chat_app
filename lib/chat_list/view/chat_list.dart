import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/chat_list/controller/chat_list_controller.dart';
import 'package:chat_app/chat_list/model/chat_user_model.dart';
import 'package:chat_app/chat_page/view/chat_page.dart';
import 'package:chat_app/profile/view/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChatList extends StatelessWidget {
  ChatList({Key? key}) : super(key: key);
  final ChatListController chatListController = Get.put(ChatListController());
  final TextEditingController msgController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  List<ChatUser> list = [];
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Obx(() {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: chatListController.search.value
                ? TextFormField(
                    onChanged: (value) {
                      chatListController.searchString.value =
                          value.toLowerCase();
                      print(chatListController.searchString.value);
                    },
                  )
                : Text(
                    'Chat List',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    chatListController.search.value =
                        !chatListController.search.value;
                    chatListController.searchString.value = "";
                  },
                  icon: chatListController.search.value
                      ? Icon(Icons.close)
                      : Icon(Icons.search)),
              IconButton(
                  onPressed: () => Get.to(() => Profile()),
                  icon: Icon(Icons.more_vert)),
              SizedBox(width: 15)
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: fireStore
                        .collection("users")
                        .where(
                          "id",
                          isNotEqualTo: auth.currentUser!.uid,
                        )
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 15),
                        itemBuilder: (context, index) {
                          QueryDocumentSnapshot data =
                              snapshot.data!.docs[index];

                          return InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () => chatListController.goToChatRoom(
                              name: data["name"],
                              profileImage: data["image"],
                              recieverId: data["id"],
                              senderId: auth.currentUser!.uid,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                        imageUrl: data["image"],
                                        width: 55,
                                        height: 55,
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 5,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.green,
                                        radius: 8,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['name'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      StreamBuilder(
                                        stream: fireStore
                                            .collection("chats/${[
                                              auth.currentUser!.uid,
                                              data["id"]
                                            ]..sort()}/messages")
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          final data = snapshot.data!.docs;
                                          if (data.isEmpty) {
                                            return Text('Send message');
                                          }

                                          return Text(
                                              data[data.length - 1]["message"]);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
