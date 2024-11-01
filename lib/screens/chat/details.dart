import 'package:chat_duo/ctrl/app_ctrl.dart';
import 'package:chat_duo/model/message.dart';
import 'package:chat_duo/resources/colors.dart';
import 'package:chat_duo/resources/shared/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../app/functions.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen(this.chat, {required this.isGroup, super.key});

  final dynamic chat;
  final bool isGroup;

  @override
  Widget build(BuildContext context) {
    final ctrl = AppCtrl();
    final sender = context.read<AppCtrl>().user;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
              ),
            ),
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 20,
                backgroundImage:
                    NetworkImage(isGroup ? chat.picture : chat.user.avatar),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isGroup ? chat.groupName : chat.user.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  chat.lastMessage,
                  style: const TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w200),
                ),
              ],
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: isGroup
                  ? ctrl.getGroupMessages(chat.date)
                  : ctrl.getMessages(chat.user.id),
              builder: (context, snapshot) {
                print(snapshot.error);
                if (snapshot.connectionState == ConnectionState.active) {
                  final messages = snapshot.data;
                  print(messages);
                  if (messages == null || messages.isEmpty) {
                    return const Center(child: Text("No messages yet"));
                  }
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) => _messageItem(
                        messages[index].message,
                        messages[index].createdAt,
                        messages[index].sender.id == ctrl.myId,
                        index % 3 == 1),
                  );
                }
                return Center(
                  child: Lottie.asset("assets/json/loading.json", width: 150),
                );
              },
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 5),
              Expanded(
                child: TextField(
                  controller: ctrl.messageCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Type a message",
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (sender == null) {
                    AppToast.info("Please login first");
                  } else {
                    if (isGroup) {
                      ctrl.sendMessage(
                        sender: sender,
                        groupId: chat.date,
                        isGroup: true,
                      );
                    } else {
                      ctrl.sendMessage(sender: sender, receiver: chat.user);
                    }
                  }
                },
                icon: Icon(
                  Icons.send,
                  color: AppColors.primary,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _messageItem(
    String message,
    String date,
    bool isSender,
    bool isPreviousMessageIsMine,
  ) =>
      Align(
        alignment: isSender ? Alignment.topRight : Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.only(
            left: isSender ? 200 : 5,
            right: isSender ? 5 : 200,
            top: 10,
          ),
          child: Column(
            crossAxisAlignment:
                isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: isSender ? AppColors.primary : Colors.grey.shade300,
                  borderRadius: BorderRadius.only(
                    topLeft: isSender
                        ? const Radius.circular(10)
                        : const Radius.circular(20),
                    topRight: isSender
                        ? const Radius.circular(20)
                        : const Radius.circular(10),
                    bottomRight: isSender
                        ? const Radius.circular(0)
                        : const Radius.circular(10),
                    bottomLeft: isSender
                        ? const Radius.circular(10)
                        : const Radius.circular(0),
                  ),
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 20,
                    color: isSender ? Colors.white : Colors.black,
                  ),
                ),
              ),
              if (!isPreviousMessageIsMine)
                Text(
                  daysBetween(DateTime.parse(date)),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
        ),
      );
}
