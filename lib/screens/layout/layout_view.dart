import 'package:chat_duo/ctrl/app_ctrl.dart';
import 'package:chat_duo/model/chat.dart';
import 'package:chat_duo/model/user.dart';
import 'package:chat_duo/screens/_resources/shared/navigation.dart';
import 'package:chat_duo/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutView extends StatelessWidget {
  const LayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Chat Duo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AppCtrl>().logout().then((isLoggedOut) {
                if (isLoggedOut) {
                  toAndFinish(context, const LoginScreen());
                }
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => ChatItem(
          ChatModel(
            lastMessage: "lastMessage",
            date: "date",
            user: UserModel(
              id: "id",
              name: "Mohamed Ashmawi",
              email: "email",
              avatar: "avatar",
              createdAt: "createdAt",
              updatedAt: "updatedAt",
            ),
            isRead: true,
            isActive: true,
          ),
        ),
        itemCount: 10,
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  const ChatItem(this.chat, {super.key});

  final ChatModel chat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.red,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0),
            color: Colors.deepOrange.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 1,
          ),
          BoxShadow(
            offset: const Offset(0, 0),
            color: Colors.deepPurple.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 42,
                backgroundColor: Colors.red,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(chat.user.avatar),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: CircleAvatar(
                  radius: 9,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 7.5,
                    backgroundColor:
                        !chat.isActive ? Colors.green : Colors.grey,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        chat.user.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {},
                      child: const Icon(
                        Icons.more_horiz,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        chat.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: !chat.isRead ? Colors.grey.shade700 : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(chat.date),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
