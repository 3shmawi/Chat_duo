import 'package:chat_duo/model/chat.dart';
import 'package:chat_duo/resources/colors.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen(this.chat, {super.key});

  final ChatModel chat;

  @override
  Widget build(BuildContext context) {
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
                backgroundImage: NetworkImage(chat.user.avatar),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat.user.name,
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
            child: ListView.builder(
              itemBuilder: (context, index) => _messageItem(
                  "hello", index.toString(), index % 3 == 0, index % 3 == 1),
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 5),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: "Type a message",
                      hintStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey)),
                ),
              ),
              IconButton(
                onPressed: () {},
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
                isSender ? CrossAxisAlignment.start : CrossAxisAlignment.end,
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
                  date,
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
