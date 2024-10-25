import 'package:chat_duo/model/user.dart';

class ChatModel {
  final String lastMessage;
  final String date;
  final UserModel user;
  final bool isRead;
  // final bool isActive;

  ChatModel({
    required this.lastMessage,
    required this.date,
    required this.user,
    required this.isRead,
    // required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'lastMessage': lastMessage,
      'date': date,
      'user': user.toJson(),
      'isRead': isRead,
      // 'isActive': isActive,
    };
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      lastMessage: json['lastMessage'],
      date: json['date'],
      user: UserModel.fromJson(json['user']),
      isRead: json['isRead'],
      // isActive: json['isActive'],
    );
  }

  ChatModel copyWith({
    String? lastMessage,
    String? date,
    UserModel? user,
    bool? isRead,
    bool? isActive,
  }) {
    return ChatModel(
      lastMessage: lastMessage ?? this.lastMessage,
      date: date ?? this.date,
      user: user ?? this.user,
      isRead: isRead ?? this.isRead,
      // isActive: isActive ?? this.isActive,
    );
  }
}
