import 'package:chat_duo/app/functions.dart';
import 'package:chat_duo/ctrl/app_ctrl.dart';
import 'package:chat_duo/model/chat.dart';
import 'package:chat_duo/model/user.dart';
import 'package:chat_duo/screens/_resources/shared/navigation.dart';
import 'package:chat_duo/screens/_resources/shared/use_case.dart';
import 'package:chat_duo/screens/auth/login.dart';
import 'package:chat_duo/screens/layout/details_view.dart';
import 'package:chat_duo/screens/layout/profile_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/group.dart';

class LayoutView extends StatefulWidget {
  const LayoutView({super.key});

  @override
  State<LayoutView> createState() => _LayoutViewState();
}

class _LayoutViewState extends State<LayoutView> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AppCtrl().setUserActive(true);
  }

  @override
  void dispose() {
    AppCtrl().setUserActive(false);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Listening to app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      AppCtrl().setUserActive(true);
    } else if (state == AppLifecycleState.paused) {
      AppCtrl().setUserActive(false);
    } else if (state == AppLifecycleState.detached) {
      AppCtrl().setUserActive(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          leadingWidth: 30,
          title: const Text(
            'Chat Duo',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const BottomModelSheet(true),
                );
              },
              child: const Text(
                "New Group",
                style: TextStyle(color: Colors.white),
              ),
            ),
            BlocBuilder<AppCtrl, AppStates>(
              buildWhen: (_, current) => current is DarkModeToggledState,
              builder: (context, state) {
                final ctrl = context.read<AppCtrl>();
                return IconButton(
                  icon: Icon(
                    ctrl.isDarkMode
                        ? CupertinoIcons.lightbulb_fill
                        : CupertinoIcons.lightbulb_slash_fill,
                    color: ctrl.isDarkMode ? Colors.yellowAccent : Colors.black,
                  ),
                  onPressed: () {
                    ctrl.toggleDarkMode();
                  },
                );
              },
            ),
            IconButton(
              icon: const Icon(CupertinoIcons.profile_circled),
              onPressed: () {
                toPage(context, ProfileView(AppCtrl().myId!));
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          'Logout',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        content: const Text('Are you sure you want to logout?'),
                        actions: <Widget>[
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    context
                                        .read<AppCtrl>()
                                        .logout()
                                        .then((isLoggedOut) {
                                      if (isLoggedOut) {
                                        toAndFinish(
                                            context, const LoginScreen());
                                      }
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey),
                                  child: const Text('Logout'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    });
              },
            ),
          ],
          bottom: const TabBar(
            unselectedLabelColor: Colors.white24,
            labelColor: Colors.white,
            dividerColor: Colors.transparent,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Personal'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.group),
                    SizedBox(
                      width: 5,
                    ),
                    Text('My Groups'),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          StreamBuilder<List<ChatModel>>(
              stream: AppCtrl().getMyUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final users = snapshot.data;
                  if (users == null || users.isEmpty) {
                    return const UseCaseWidget(UseCases.empty);
                  }

                  return ListView.builder(
                    itemBuilder: (context, index) => ChatItem(
                      chat: users[index],
                      isGroup: false,
                    ),
                    itemCount: users.length,
                  );
                }
                return const UseCaseWidget(UseCases.loading);
              }),
          StreamBuilder<List<GroupChatModel>>(
              stream: AppCtrl().getMyGroups(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final groups = snapshot.data;
                  if (snapshot.hasError) {
                    print(snapshot.error);
                  }
                  if (groups == null || groups.isEmpty) {
                    return const UseCaseWidget(UseCases.empty);
                  }

                  return ListView.builder(
                    itemBuilder: (context, index) => ChatItem(
                      group: groups[index],
                      isGroup: true,
                    ),
                    itemCount: groups.length,
                  );
                }
                return const UseCaseWidget(UseCases.loading);
              })
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => const BottomModelSheet(false),
            );
          },
          child: const Icon(Icons.chat_bubble_outline),
        ),
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  const ChatItem({
    required this.isGroup,
    this.chat,
    this.group,
    super.key,
  });

  final ChatModel? chat;
  final GroupChatModel? group;
  final bool isGroup;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppCtrl()
            .updateReadingState(isGroup ? group!.id : chat!.user.id, isGroup);
        toPage(
          context,
          DetailsView(
            isGroupChat: isGroup,
            receiver: chat?.user,
            groupChatModel: group,
          ),
        );
      },
      child: Container(
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
                    backgroundImage: NetworkImage(
                        isGroup ? group!.groupPicture : chat!.user.avatar),
                  ),
                ),
                if (!isGroup)
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.white,
                      child: StreamBuilder<bool>(
                          stream: AppCtrl().isUserActive(chat!.user.id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.active) {
                              final isActive = snapshot.data;
                              if (isActive == null) {
                                return const CircleAvatar(
                                  radius: 7.5,
                                  backgroundColor: Colors.grey,
                                );
                              }
                              return CircleAvatar(
                                radius: 7.5,
                                backgroundColor:
                                    isActive ? Colors.green : Colors.grey,
                              );
                            }
                            return const CircleAvatar(
                              radius: 7.5,
                              backgroundColor: Colors.grey,
                            );
                          }),
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
                          isGroup ? group!.groupTitle : chat!.user.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _isAudioUrl(isGroup
                                  ? group!.lastMessage
                                  : chat!.lastMessage)
                              ? "Audio ၊၊||၊|။||||။၊|။|||။|||။၊|။၊ "
                              : isGroup
                                  ? group!.lastMessage
                                  : chat!.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (isRead())
                        const CircleAvatar(
                          radius: 6,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 5,
                            backgroundColor: Colors.red,
                          ),
                        ),
                      const SizedBox(width: 10),
                      Text(isGroup
                          ? group!.date.isEmpty
                              ? ""
                              : daysBetween(group!.date)
                          : chat!.date.isEmpty
                              ? ""
                              : daysBetween(chat!.date)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isRead() {
    if (isGroup) {
      return group!.isRead;
    }
    return chat!.isRead;
  }

  bool _isAudioUrl(String url) {
    final audioExtensions = ['.mp3', '.wav', '.m4a', '.flac', '.aac', '.ogg'];
    return audioExtensions.any((ext) => url.toLowerCase().contains(ext));
  }
}

class BottomModelSheet extends StatelessWidget {
  const BottomModelSheet(this.isGroup, {super.key});

  final bool isGroup;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCtrl, AppStates>(
      builder: (context, state) {
        final cubit = context.read<AppCtrl>();
        cubit.getAllUsers();

        final allUsers = cubit.searchText.text.isEmpty
            ? cubit.allUsers
            : cubit.filteredUsers;
        return Column(
          children: [
            const SizedBox(height: 15),
            Row(
              children: [
                const SizedBox(width: 30),
                Expanded(
                  child: Center(child: _bar(cubit)),
                ),
                IconButton(
                  onPressed: cubit.toggleSearch,
                  icon: Icon(
                    cubit.isSearch
                        ? CupertinoIcons.clear_circled
                        : CupertinoIcons.search,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey.shade400),
            if (isGroup)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: cubit.groupTitleCtrl,
                        decoration: InputDecoration(
                          hintText: "Group Title",
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          cubit.createGroup();
                        },
                        child: const Text("CREATE"),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: state is GetAllUsersLoadingState
                  ? const UseCaseWidget(UseCases.loading)
                  : state is GetAllUsersErrorState
                      ? const UseCaseWidget(UseCases.error)
                      : allUsers.isEmpty
                          ? const UseCaseWidget(UseCases.empty)
                          : UseCaseWidget(
                              UseCases.success,
                              body: _body(cubit, allUsers),
                            ),
            ),
          ],
        );
      },
    );
  }

  RefreshIndicator _body(AppCtrl cubit, List<UserModel> allUsers) {
    return RefreshIndicator(
      onRefresh: () async {
        cubit.refreshAllUsers();
      },
      child: ListView.builder(
        itemBuilder: (context, index) => Stack(
          alignment: Alignment.centerRight,
          children: [
            ChatItem(
              isGroup: false,
              chat: ChatModel(
                lastMessage:
                    "Start chat with ${allUsers[index].name.split(" ").first}...",
                date: "",
                user: allUsers[index],
                isRead: false,
              ),
            ),
            if (isGroup)
              Checkbox(
                value: cubit.isSelected(allUsers[index]),
                onChanged: (v) {
                  cubit.addOrRemoveUser(allUsers[index]);
                },
              ),
          ],
        ),
        itemCount: allUsers.length,
      ),
    );
  }

  Widget _bar(AppCtrl cubit) => AnimatedCrossFade(
        firstChild: Text(
          isGroup ? "NEW GROUP [${cubit.selectedUsers.length}]" : "NEW CHAT",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        secondChild: TextField(
          controller: cubit.searchText,
          onChanged: (v) {
            cubit.filterUsers();
          },
          decoration: InputDecoration(
            hintText: "Search for user name...",
            hintStyle: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade400,
            ),
            border: InputBorder.none,
          ),
        ),
        crossFadeState: cubit.isSearch
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: const Duration(
          milliseconds: 300,
        ),
      );
}
