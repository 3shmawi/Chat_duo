import 'package:chat_duo/ctrl/app_ctrl.dart';
import 'package:chat_duo/resources/assets.dart';
import 'package:chat_duo/resources/colors.dart';
import 'package:chat_duo/resources/shared/navigation.dart';
import 'package:chat_duo/screens/auth/login.dart';
import 'package:chat_duo/screens/chat/details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '_widgets.dart';

class ChatHomeScreen extends StatelessWidget {
  const ChatHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AppCtrl>().logout().then((isSuccess) {
                if (isSuccess) {
                  toAndFinish(context, const LoginScreen());
                }
              });
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.cyan,
              ),
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
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const DetailsScreen(),
              ),
            );
          },
          child: ListTile(),
          // child: const HomeChatCardItem(),
        ),
        itemCount: 10,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) => const NewChatModelSheet());
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}
