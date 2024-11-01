import 'package:chat_duo/ctrl/app_ctrl.dart';
import 'package:chat_duo/screens/_resources/shared/navigation.dart';
import 'package:chat_duo/screens/_resources/shared/use_case.dart';
import 'package:chat_duo/screens/auth/login.dart';
import 'package:chat_duo/screens/layout/widgets.dart';
import 'package:flutter/material.dart';

import 'all_users.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
          actions: [
            TextButton(
              onPressed: () {
                AppCtrl().logout().then((loggedOut) {
                  if (loggedOut) {
                    toAndFinish(context, const LoginScreen());
                  }
                });
              },
              child: const Text("LOGOUT"),
            ),
          ],
          bottom: const TabBar(
            dividerColor: Colors.transparent,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Contacts  '),
                    Icon(Icons.person_2),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Groups  '),
                    Icon(Icons.groups),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const Center(
              child: Text("data"),
            ),
            StreamBuilder(
              stream: AppCtrl().getMyGroups(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final groups = snapshot.data;
                  if (groups == null) {
                    return AppUseCase(
                      UseCase.failure,
                      errorMessage: snapshot.error.toString(),
                    );
                  }
                  if (groups.isEmpty) {
                    return const AppUseCase(UseCase.empty);
                  }
                  return ListView.builder(
                    itemBuilder: (context, index) =>
                        ChatHomeItem(groups[index]),
                    itemCount: groups.length,
                  );
                }
                return const AppUseCase(UseCase.loading);
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            toPage(context, const AllUsersPage());
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
