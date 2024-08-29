import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/profile/controller/profile_controller.dart';
import 'package:chat_app/utils/api.dart';
import 'package:chat_app/utils/user_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatelessWidget {
  Profile({Key? key}) : super(key: key);
  final ProfileController profileController = Get.put(ProfileController());
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  XFile? profileImage;
  @override
  Widget build(BuildContext context) {
    print('|||||| user details ||||||||||');
    print(auth.currentUser!.displayName);
    print(auth.currentUser!.email);
    print(auth.currentUser!.photoURL);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      imageUrl: auth.currentUser!.photoURL.toString(),
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: IconButton(
                        onPressed: () async {
                          profileImage = await ImagePicker().pickImage(
                              source: ImageSource.gallery, imageQuality: 80);
                          if (profileImage != null) {
                            final ext = profileImage!.path.split('.').last;
                            print(ext);
                            await firebaseStorage
                                .ref()
                                .child(
                                    'profile_pictures/${auth.currentUser!.uid}.$ext')
                                .putFile(
                                    File(profileImage!.path),
                                    SettableMetadata(
                                        contentType: 'image/${ext}'));
                          }
                        },
                        style:
                            IconButton.styleFrom(backgroundColor: Colors.grey),
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        )),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(auth.currentUser!.email.toString()),
              ),
              ElevatedButton(onPressed: () {}, child: Text('Update')),
              SizedBox(height: 20),
              TextButton(
                  onPressed: () => profileController.signOut(),
                  child: Text('Logout'))
            ],
          ),
        ),
      ),
    );
  }
}
