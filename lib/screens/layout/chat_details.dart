import 'package:chat_duo/app/constants.dart';
import 'package:chat_duo/app/functions.dart';
import 'package:chat_duo/ctrl/app_ctrl.dart';
import 'package:chat_duo/model/chat.dart';
import 'package:chat_duo/model/message.dart';
import 'package:chat_duo/screens/_resources/colors.dart';
import 'package:chat_duo/screens/_resources/shared/use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage(this.chat, {super.key});

  final ChatModel chat;

  @override
  Widget build(BuildContext context) {
    print(chat.id);
    final isGroup = chat.users.length > 2;
    final ctrl = AppCtrl();
    final senderId = ctrl.myId;
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
                    isGroup
                        ? getFirstNames(chat.users, senderId ?? "")
                        : "Online",
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
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
                stream: ctrl.getMessages(chatId: chat.id, isGroup: isGroup),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    final messages = snapshot.data;
                    if (messages == null) {
                      return AppUseCase(
                        UseCase.failure,
                        errorMessage: "Message\n${snapshot.error.toString()}",
                      );
                    }
                    if (messages.isEmpty) {
                      return const AppUseCase(UseCase.empty);
                    }
                    return ListView.builder(
                      itemBuilder: (context, index) => _MessageItem(
                        message: messages[index],
                        myId: senderId ?? "",
                        isGroup: isGroup,
                      ),
                      itemCount: messages.length,
                    );
                  }
                  return const AppUseCase(UseCase.loading);
                }),
          ),
          BlocBuilder<AppCtrl, AppStates>(
            builder: (context, state) {
              final cubit = context.read<AppCtrl>();
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: cubit.messageCtrl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "Write your message",
                        hintStyle: TextStyle(
                            fontSize: 16, color: Colors.grey.shade400),
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            CupertinoIcons.photo_on_rectangle,
                            color: Colors.cyan,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      cubit.sendMessage(
                        users: chat.users,
                        chatId: chat.id,
                        isGroup: isGroup,
                      );
                    },
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Colors.cyan,
                    ),
                  )
                ],
              );
            },
          )
        ],
      ),
    );
  }
}

class _MessageItem extends StatelessWidget {
  const _MessageItem({
    required this.message,
    required this.myId,
    this.isGroup = true,
  });

  final String myId;
  final bool isGroup;
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    final bool isSender = message.senderId == myId;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isSender) const Expanded(child: SizedBox.shrink()),
        if (isGroup && !isSender)
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white,
              backgroundImage:
                  NetworkImage(message.senderPicture ?? AppConsts.userAvatar),
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
                    TextSpan(text: message.text),
                    const TextSpan(
                      text: "\n",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          message.date.isEmpty ? "" : daysBetween(message.date),
                      style: const TextStyle(
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
