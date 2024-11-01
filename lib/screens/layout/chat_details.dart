import 'package:chat_duo/model/chat.dart';
import 'package:chat_duo/screens/_resources/colors.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage(this.chat, {super.key});

  final ChatModel chat;

  @override
  Widget build(BuildContext context) {
    final isGroup = chat.users.length > 2;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios),
            ),
            CircleAvatar(
              radius: 28,
              child: CircleAvatar(
                radius: 26,
                backgroundImage: NetworkImage(
                  isGroup ? chat.groupPicture! : chat.users.first.avatar,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isGroup ? chat.groupTitle! : chat.users.first.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    isGroup ? "You, Mohamed" : "online",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const _MessageItem(
            isSender: true,
          ),
          const _MessageItem(
            isSender: false,
          ),
          const _MessageItem(
            isSender: true,
          ),
          const _MessageItem(
            isSender: true,
          ),
          const _MessageItem(
            isSender: true,
          ),
          const _MessageItem(
            isSender: false,
          ),
        ],
      ),
    );
  }
}

class _MessageItem extends StatelessWidget {
  const _MessageItem({
    this.isSender = false,
    this.isGroup = true,
  });

  final bool isSender;
  final bool isGroup;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isSender) const Expanded(child: SizedBox.shrink()),
        if (isGroup && !isSender)
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary,
            child: const CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white,
            ),
          ),
        Expanded(
          flex: 3,
          child: Align(
            alignment: isSender ? Alignment.topRight : Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(
                top: 10,
                right: isSender ? 4 : 8,
                left: isSender ? 8 : 4,
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isSender ? 0 : 20),
                  topRight: Radius.circular(isSender ? 20 : 0),
                  bottomLeft: Radius.circular(isSender ? 10 : 0),
                  bottomRight: Radius.circular(isSender ? 0 : 10),
                ),
                color: isSender ? AppColors.primary : Colors.grey[400],
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "Message"),
                    TextSpan(
                      text: "\n",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "1m",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (!isSender) const Expanded(child: SizedBox.shrink()),
      ],
    );
  }
}
