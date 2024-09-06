import 'package:chat_duo/ctrl/app_ctrl.dart';
import 'package:chat_duo/resources/assets.dart';
import 'package:chat_duo/resources/colors.dart';
import 'package:chat_duo/screens/chat/details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                  color: Colors.cyan,
                ),
              ),
            ],
          ),
        ),
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
          child: _item(),
        ),
        itemCount: 10,
      ),
    );
  }

  Widget _item() => Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 30,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Mohamed Ashmawi Mohamed Ashmawi Mohamed Ashmawi Mohamed Ashmawi Mohamed Ashmawi ",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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
                    const Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            " last message last message last message last message last message last message vlast message",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "date",
                              textAlign: TextAlign.right,
                              style: TextStyle(
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
            ],
          ),
        ),
      );
}
