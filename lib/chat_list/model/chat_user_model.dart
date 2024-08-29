// To parse this JSON data, do
//
//     final chatUser = chatUserFromJson(jsonString);

import 'dart:convert';

ChatUser chatUserFromJson(String str) => ChatUser.fromJson(json.decode(str));

String chatUserToJson(ChatUser data) => json.encode(data.toJson());

class ChatUser {
  final String image;
  final String pushToke;
  final String name;
  final String createdAt;
  final bool isOnline;
  final String id;
  final String lastActive;
  final String email;

  ChatUser({
    required this.image,
    required this.pushToke,
    required this.name,
    required this.createdAt,
    required this.isOnline,
    required this.id,
    required this.lastActive,
    required this.email,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
        image: json["image"] ?? '',
        pushToke: json["push_toke"] ?? '',
        name: json["name"] ?? '',
        createdAt: json["created_at"] ?? '',
        isOnline: json["is_online"] ?? false,
        id: json["id"] ?? '',
        lastActive: json["last_active"] ?? '',
        email: json["email"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "push_toke": pushToke,
        "name": name,
        "created_at": createdAt,
        "is_online": isOnline,
        "id": id,
        "last_active": lastActive,
        "email": email,
      };
}
