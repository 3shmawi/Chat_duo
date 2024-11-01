import 'package:chat_duo/model/user.dart';

class ChatModel {
  final String lastMessage;
  final String date;
  final List<UserModel> users;
  final bool isRead;
  final String? groupPicture;
  final String? groupTitle;
  final String? senderId;

  ChatModel({
    required this.lastMessage,
    required this.date,
    required this.users,
    this.isRead = false,
    this.groupPicture,
    this.groupTitle,
    this.senderId,
  });

  Map<String, dynamic> toJson() {
    if (groupPicture != null && groupTitle != null) {
      return {
        'lastMessage': lastMessage,
        'date': date,
        'users': users.map((user) => user.toJson()).toList(),
        'isRead': isRead,
        'groupPicture': groupPicture,
        'groupTitle': groupTitle,
        'senderId': senderId,
      };
    }
    return {
      'lastMessage': lastMessage,
      'date': date,
      'users': users.map((user) => user.toJson()).toList(),
      'isRead': isRead,
      'senderId': senderId,
    };
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      lastMessage: json['lastMessage'],
      date: json['date'],
      users: (json['users'] as List<dynamic>)
          .map((userJson) =>
              UserModel.fromJson(userJson as Map<String, dynamic>))
          .toList(), // Explicitly convert each item to UserModel
      isRead: json['isRead'],
      groupPicture: json['groupPicture'],
      groupTitle: json['groupTitle'],
      senderId: json['senderId'],
    );
  }
  ChatModel copyWith({
    String? lastMessage,
    String? date,
    List<UserModel>? users,
    bool? isRead,
    String? groupPicture,
    String? groupTitle,
    String? senderId,
  }) {
    return ChatModel(
      lastMessage: lastMessage ?? this.lastMessage,
      date: date ?? this.date,
      users: users ?? this.users,
      isRead: isRead ?? this.isRead,
      groupPicture: groupPicture ?? this.groupPicture,
      groupTitle: groupTitle ?? this.groupTitle,
      senderId: senderId ?? this.senderId,
    );
  }
}
