import 'package:chat_app/chat_page/controller/chat_controller.dart';
import 'package:chat_app/login/view/login.dart';
import 'package:chat_app/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatelessWidget {
  ChatPage({Key? key, required this.name}) : super(key: key);
  ChatController controller = Get.put(ChatController());
  final TextEditingController msgController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Stream<QuerySnapshot> _msgStream = FirebaseFirestore.instance
      .collection("messages")
      .orderBy("time")
      .snapshots();
  final String name;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            controller.signOutLoading.value
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  )
                : TextButton(
                    onPressed: () => controller.signOut(),
                    child: Text('Logout')),
            SizedBox(width: 15)
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: _msgStream,
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
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot qds = snapshot.data!.docs[index];
                      return Text(qds['message']);
                    },
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: msgController,
                    decoration: InputDecoration(),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      if (msgController.text.isNotEmpty) {
                        _firestore.collection("messages").doc().set({
                          "message": msgController.text.trim(),
                          "time": DateTime.now(),
                        });
                        msgController.clear();
                      }
                    },
                    icon: Icon(Icons.send))
              ],
            )
          ],
        ),
      );
    });
  }
}
