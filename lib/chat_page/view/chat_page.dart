import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/chat_page/controller/chat_controller.dart';
import 'package:chat_app/utils/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatelessWidget {
  ChatPage({
    Key? key,
    required this.recieverId,
    required this.name,
    required this.profileImage,
    required this.chatroomId,
  }) : super(key: key);
  ChatController controller = Get.put(ChatController());
  final TextEditingController msgController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final String recieverId, name, profileImage, chatroomId;

  @override
  Widget build(BuildContext context) {
    print(name);
    print(profileImage);
    print(recieverId);
    print(auth.currentUser!.uid);
    // return Obx(() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 60,
        titleSpacing: 0,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                imageUrl: profileImage,
                width: 55,
                height: 55,
              ),
            ),
            SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                Text(
                  'Last seen',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
                ),
              ],
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
              stream: fireStore
                  .collection("chats/$chatroomId/messages")
                  .snapshots(),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    QueryDocumentSnapshot data = snapshot.data!.docs[index];

                    return Align(
                      alignment: recieverId == data["id"]
                          ? Alignment.topLeft
                          : Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width - 150),
                          child: Text(
                            data["message"],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            )),
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.white,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.emoji_emotions),
                        ),
                        Expanded(
                            child: TextFormField(
                          controller: msgController,
                          decoration: InputDecoration(
                            hintText: 'Message $name',
                            border: InputBorder.none,
                          ),
                        )),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.image),
                        ),
                        IconButton(
                            onPressed: () {}, icon: Icon(Icons.camera_alt))
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final time =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    fireStore
                        .collection("chats/$chatroomId/messages")
                        .doc(time)
                        .set({
                      "message": msgController.text,
                      "id": auth.currentUser!.uid,
                      // "from_id": auth.currentUser!.uid,
                      "read": "",
                      "type": "1",
                      "sent": time,
                    });
                    msgController.text = '';
                  },
                  icon: Icon(Icons.send),
                )
              ],
            ),
          ],
        ),
      ),
    );
    // });
  }
}
