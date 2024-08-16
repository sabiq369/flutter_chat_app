import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/chat_page/controller/chat_controller.dart';
import 'package:chat_app/login/view/login.dart';
import 'package:chat_app/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatList extends StatelessWidget {
  ChatList({Key? key}) : super(key: key);
  ChatController controller = Get.put(ChatController());
  final TextEditingController msgController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Stream<QuerySnapshot> _msgStream = FirebaseFirestore.instance
      .collection("users")
      .orderBy("name")
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Chat List',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 15),
                      itemBuilder: (context, index) {
                        QueryDocumentSnapshot qds = snapshot.data!.docs[index];

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                                width: 55,
                                height: 55,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(qds['name']),
                            ),
                          ],
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
    });
  }
}
