import 'package:chat_duo/model/chat.dart';
import 'package:flutter/material.dart';

import '../_resources/colors.dart';

class ChatHomeItem extends StatelessWidget {
  const ChatHomeItem(this.chat, {super.key});

  final ChatModel chat;

  @override
  Widget build(BuildContext context) {
    final isGroup = chat.users.length > 1;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.primary,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            blurRadius: 10,
            color: Colors.cyan.shade50,
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                  isGroup ? chat.groupPicture! : chat.users.first.avatar),
            ),
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
                      isGroup ? chat.groupTitle! : chat.users.first.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      chat.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 5),
                  if (!chat.isRead)
                    const CircleAvatar(
                      radius: 6,
                      backgroundColor: Colors.green,
                      child: CircleAvatar(
                        radius: 2,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  if (!chat.isRead) const SizedBox(width: 5),
                  Text(
                    chat.date,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ))
        ],
      ),
    );
  }
}
