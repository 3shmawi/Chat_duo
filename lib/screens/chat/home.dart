import 'package:chat_duo/ctrl/app_ctrl.dart';
import 'package:chat_duo/model/chat.dart';
import 'package:chat_duo/model/group.dart';
import 'package:chat_duo/resources/assets.dart';
import 'package:chat_duo/resources/colors.dart';
import 'package:chat_duo/resources/shared/navigation.dart';
import 'package:chat_duo/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../app/functions.dart';
import '_widgets.dart';
import 'details.dart';

class ChatHomeScreen extends StatelessWidget {
  const ChatHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: AppColors.white,
          backgroundColor: Colors.deepPurple[600],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
          ),
          leadingWidth: 30,
          centerTitle: false,
          title: RichText(
            text: TextSpan(
              text: "Text",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
              children: const [
                TextSpan(
                  text: "Twice",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {},
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.white,
            dividerColor: Colors.transparent,
            unselectedLabelColor: Colors.white24,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: "Contacts"),
              Tab(text: "Groups"),
            ],
          ),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.cyan,
                ),
                child: Center(
                  child: Column(
                    children: [
                      const Spacer(),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          AppAssets.logo,
                          height: 90,
                          width: 90,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        "Version 1.0.0",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SwitchListTile(
                value: context.watch<AppCtrl>().isDark,
                onChanged: (v) {
                  context.read<AppCtrl>().toggleThemeMode();
                },
                title: const Text(
                  "Dark mode",
                ),
              ),
              const Divider(color: Colors.cyan),
              const Spacer(),
              ListTile(
                title: const Text("Logout"),
                trailing: const Icon(Icons.logout),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Are you sure?"),
                          content: const Text("Do you want to logout?"),
                          actions: [
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text("No"),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                TextButton(
                                  child: const Text("Yes"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    context
                                        .read<AppCtrl>()
                                        .logout()
                                        .then((isSuccess) {
                                      if (isSuccess) {
                                        toAndFinish(
                                            context, const LoginScreen());
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        );
                      });
                },
              ),
              const Divider(color: Colors.cyan),
              const Text("copyright@ Mostafa"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder<List<ChatModel>>(
              stream: AppCtrl().getMyUsers(),
              builder: (context, snapshot) {
                print(snapshot.connectionState);
                if (snapshot.connectionState == ConnectionState.active) {
                  final users = snapshot.data;

                  if (users == null || users.isEmpty) {
                    return const Center(child: Text("No users yet"));
                  }
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        toPage(
                          context,
                          DetailsScreen(
                            users[index],
                            isGroup: false,
                          ),
                        );
                      },
                      child: HomeChatCardItem(
                        users[index],
                        isGroup: false,
                      ),
                    ),
                  );
                }
                return Center(
                  child: Lottie.asset("assets/json/loading.json", width: 150),
                );
              },
            ),
            StreamBuilder<List<GroupModel>>(
              stream: AppCtrl().getMyGroups(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final groups = snapshot.data;
                  print(snapshot.error);

                  if (groups == null || groups.isEmpty) {
                    return const Center(child: Text("No groups yet"));
                  }
                  return ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        toPage(
                          context,
                          DetailsScreen(
                            groups[index],
                            isGroup: true,
                          ),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(groups[index]
                                        .picture ??
                                    "https://plus.unsplash.com/premium_vector-1724431032286-6b1fbe183ba4?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Z3JvdXAlMjBkZWZhdWx0JTIwaW1hZ2V8ZW58MHx8MHx8fDA%3D"),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              groups[index].groupName!,
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
                                            child: Text(
                                              groups[index].lastMessage,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8.0),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              daysBetween(DateTime.parse(
                                                  groups[index].date)),
                                              maxLines: 1,
                                              textAlign: TextAlign.right,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return Center(
                  child: Lottie.asset("assets/json/loading.json", width: 150),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          onPressed: () {
            context.read<AppCtrl>().getAllUsers();
            showModalBottomSheet(
              context: context,
              builder: (context) => const NewChatModelSheet(
                isGroup: true,
              ),
            );
          },
          child: const Icon(Icons.chat),
        ),
      ),
    );
  }
}
