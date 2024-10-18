import 'package:chat_duo/ctrl/app_ctrl.dart';
import 'package:chat_duo/model/message.dart';
import 'package:chat_duo/model/user.dart';
import 'package:chat_duo/screens/_resources/shared/navigation.dart';
import 'package:chat_duo/screens/_resources/shared/use_case.dart';
import 'package:chat_duo/screens/layout/profile_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsView extends StatelessWidget {
  const DetailsView(this.receiver, {super.key});

  final UserModel receiver;

  @override
  Widget build(BuildContext context) {
    final sender = context.read<AppCtrl>().user;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
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
            GestureDetector(
              onTap: () => toPage(context, ProfileView(receiver.id)),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(receiver.avatar),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              receiver.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
                stream: AppCtrl().getMessages(receiver.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    final messages = snapshot.data;
                    if (messages == null || messages.isEmpty) {
                      return const UseCaseWidget(UseCases.empty);
                    }

                    return ListView.builder(
                      itemBuilder: (context, index) => _ChatItem(
                        message: messages[index].message,
                        date: messages[index].updatedAt,
                        isSender: receiver.id == messages[index].receiverId,
                      ),
                      itemCount: messages.length,
                    );
                  }
                  return const UseCaseWidget(UseCases.loading);
                }),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: context.read<AppCtrl>().messageCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade400,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        CupertinoIcons.photo,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  print(sender);
                  context.read<AppCtrl>().sendMessage(receiver, sender!);
                },
                icon: const Icon(
                  Icons.send,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChatItem extends StatelessWidget {
  const _ChatItem({
    required this.message,
    required this.date,
    required this.isSender,
  });

  final String message;
  final String date;
  final bool isSender;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: isSender ? Colors.red : Colors.grey.shade400,
            borderRadius: BorderRadius.only(
              topLeft: isSender ? const Radius.circular(10) : Radius.zero,
              topRight: !isSender ? const Radius.circular(10) : Radius.zero,
              bottomLeft: isSender ? Radius.zero : const Radius.circular(10),
              bottomRight: !isSender ? Radius.zero : const Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                isSender ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Text(
                message,
                style: TextStyle(
                  color: isSender ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  color: isSender ? Colors.white70 : Colors.black45,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
