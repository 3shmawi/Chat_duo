import 'package:chat_duo/model/user.dart';

class ChatModel {
  final UserModel user;
  final String lastMessage;
  final String date;

  ChatModel({
    required this.user,
    required this.lastMessage,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'lastMessage': lastMessage,
      'date': date,
    };
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      user: UserModel.fromJson(json['user']),
      lastMessage: json['lastMessage'],
      date: json['date'],
    );
  }

  ChatModel copyWith({
    UserModel? user,
    String? lastMessage,
    String? date,
  }) {
    return ChatModel(
      user: user ?? this.user,
      lastMessage: lastMessage ?? this.lastMessage,
      date: date ?? this.date,
    );
  }
}
