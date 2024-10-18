import 'package:chat_duo/app/functions.dart';
import 'package:chat_duo/ctrl/app_ctrl.dart';
import 'package:chat_duo/model/chat.dart';
import 'package:chat_duo/resources/shared/navigation.dart';
import 'package:chat_duo/screens/chat/details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewChatModelSheet extends StatelessWidget {
  const NewChatModelSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const NewChatSearchBar(),
          const Divider(
            color: Colors.orange,
          ),
          Expanded(
            child: BlocBuilder<AppCtrl, AppStates>(
                buildWhen: (_, current) =>
                    current is GetAllUsersLoadingState ||
                    current is GetAllUsersSuccessState ||
                    current is GetAllUsersFailedState,
                builder: (context, state) {
                  if (state is GetAllUsersLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final cubit = context.read<AppCtrl>();
                  final users = cubit.searchCtrl.text.isEmpty
                      ? cubit.allUsers
                      : cubit.filteredAllUsers;
                  if (users.isEmpty) {
                    return const Center(
                      child: Text(
                        "No users found",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async => cubit.refreshAllUsers(),
                    child: ListView.builder(
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          toPage(
                            context,
                            DetailsScreen(
                              ChatModel(
                                user: users[index],
                                lastMessage: "",
                                date: "",
                              ),
                            ),
                          );
                        },
                        child: HomeChatCardItem(
                          ChatModel(
                            user: users[index],
                            lastMessage: "Start chat with ${users[index].name}",
                            date: "",
                          ),
                        ),
                      ),
                      itemCount: users.length,
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class NewChatSearchBar extends StatefulWidget {
  const NewChatSearchBar({super.key});

  @override
  State<NewChatSearchBar> createState() => _NewChatSearchBarState();
}

class _NewChatSearchBarState extends State<NewChatSearchBar> {
  bool isFirst = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 15),
        Expanded(
          child: AnimatedCrossFade(
            firstChild: const Center(
              child: Text(
                "New Chat",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            secondChild: TextField(
              controller: context.read<AppCtrl>().searchCtrl,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.search,
              onSubmitted: (v) {
                context.read<AppCtrl>().searchAllUsers();
              },
              onChanged: (v) {
                context.read<AppCtrl>().searchAllUsers();
              },
              decoration: InputDecoration(
                hintText: 'Search for contacts...',
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            crossFadeState:
                isFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: const Duration(
              milliseconds: 300,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              isFirst = !isFirst;
            });
          },
          icon: Icon(
            isFirst ? Icons.search : Icons.search_off,
          ),
        ),
      ],
    );
  }
}

class HomeChatCardItem extends StatelessWidget {
  const HomeChatCardItem(this.chat, {super.key});

  final ChatModel chat;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(chat.user.avatar),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            chat.user.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            chat.lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              daysBetween(DateTime.parse(chat.date)),
                              maxLines: 1,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  child: Text("Option 1"),
                ),
                const PopupMenuItem(
                  child: Text("Option 2"),
                ),
                const PopupMenuItem(
                  child: Text("Option 3"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
