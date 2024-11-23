import 'package:chat_duo/model/user.dart';

class GroupChatModel {
  final String id;
  final String lastMessage;
  final String date;
  final List<UserModel> users;
  final String groupPicture;
  final String groupTitle;
  final bool isRead;

  GroupChatModel({
    required this.id,
    required this.lastMessage,
    required this.date,
    required this.users,
    required this.isRead,
    required this.groupPicture,
    required this.groupTitle,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lastMessage': lastMessage,
      'date': date,
      'users': users.map((user) => user.toJson()).toList(),
      'groupPicture': groupPicture,
      'groupTitle': groupTitle,
      'isRead': isRead,
    };
  }

  factory GroupChatModel.fromJson(Map<String, dynamic> json) {
    return GroupChatModel(
      id: json['id'],
      lastMessage: json['lastMessage'],
      date: json['date'],
      isRead: json['isRead'],
      users: (json['users'] as List<dynamic>)
          .map((user) => UserModel.fromJson(user as Map<String, dynamic>))
          .toList(),
      groupPicture: json['groupPicture'],
      groupTitle: json['groupTitle'],
    );
  }

  GroupChatModel copyWith({
    String? lastMessage,
    String? date,
    List<UserModel>? users,
    bool? isRead,
    bool? isActive,
    String? groupPicture,
    String? groupTitle,
  }) {
    return GroupChatModel(
      id: id,
      lastMessage: lastMessage ?? this.lastMessage,
      date: date ?? this.date,
      users: users ?? this.users,
      isRead: isRead ?? this.isRead,
      groupPicture: groupPicture ?? this.groupPicture,
      groupTitle: groupTitle ?? this.groupTitle,
    );
  }
}
