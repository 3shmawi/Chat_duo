import 'package:chat_duo/model/user.dart';

class MessageModel {
  final String id;
  final String message;
  final String createdAt;
  final UserModel sender;
  final UserModel? receiver;
  final bool isGroup;

  MessageModel({
    required this.id,
    required this.message,
    required this.createdAt,
    required this.sender,
    this.receiver,
    required this.isGroup,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'createdAt': createdAt,
      'sender': sender.toJson(),
      'receiver': receiver?.toJson(),
      'isGroup': isGroup,
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      message: json['message'],
      createdAt: json['createdAt'],
      sender: UserModel.fromJson(json['sender']),
      receiver: UserModel.fromJson(json['receiver']),
      isGroup: json['isGroup'],
    );
  }
}
