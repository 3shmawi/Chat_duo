import 'package:chat_duo/model/user.dart';

class ChatModel {
  final String id;
  final String lastMessage;
  final String date;
  final List<UserModel> users;
  final bool isRead;
  final String? groupPicture;
  final String? groupTitle;
  final String? senderId;
  final bool isGroup;

  ChatModel({
    required this.id,
    required this.lastMessage,
    required this.date,
    required this.users,
    this.isRead = false,
    this.groupPicture,
    this.groupTitle,
    this.senderId,
    this.isGroup = false,
  });

  Map<String, dynamic> toJson() {
    if (groupPicture != null && groupTitle != null) {
      return {
        'id': id,
        'lastMessage': lastMessage,
        'date': date,
        'users': users.map((user) => user.toJson()).toList(),
        'isRead': isRead,
        'groupPicture': groupPicture,
        'groupTitle': groupTitle,
        'senderId': senderId,
        'isGroup': users.length > 2 ? true : false,
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
      id: json['id'],
      lastMessage: json['lastMessage'],
      date: json['date'],
      users: (json['users'] as List<dynamic>)
          .map((userJson) =>
              UserModel.fromJson(userJson as Map<String, dynamic>))
          .toList(),
      // Explicitly convert each item to UserModel
      isRead: json['isRead'],
      groupPicture: json['groupPicture'],
      groupTitle: json['groupTitle'],
      senderId: json['senderId'],
      isGroup: json['isGroup'] ?? false,
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
    bool? isGroup,
  }) {
    return ChatModel(
      lastMessage: lastMessage ?? this.lastMessage,
      date: date ?? this.date,
      users: users ?? this.users,
      isRead: isRead ?? this.isRead,
      groupPicture: groupPicture ?? this.groupPicture,
      groupTitle: groupTitle ?? this.groupTitle,
      senderId: senderId ?? this.senderId,
      id: id,
      isGroup: isGroup ?? this.isGroup,
    );
  }
}
