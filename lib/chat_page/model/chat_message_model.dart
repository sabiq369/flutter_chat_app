class ChatMessageModel {
  final String message;
  final String sender;
  final String reciever;
  final String? msgId;
  final DateTime timeStamp;
  final bool isSeenByReciever;
  final bool? isImage;

  ChatMessageModel({
    required this.message,
    required this.sender,
    required this.reciever,
    required this.timeStamp,
    required this.isSeenByReciever,
    this.isImage,
    this.msgId,
  });
}
