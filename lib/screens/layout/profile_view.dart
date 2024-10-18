import 'package:chat_duo/ctrl/app_ctrl.dart';
import 'package:chat_duo/model/user.dart';
import 'package:chat_duo/screens/_resources/shared/use_case.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView(this.userId, {super.key});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: FutureBuilder<UserModel>(
          future: AppCtrl().getUserData(userId),
          builder: (context, snapshot) {
            final user = snapshot.data;
            if (user == null) {
              return const UseCaseWidget(UseCases.loading);
            }
            return Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(user.avatar),
                  ),
                  Text(
                    user.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(user.email),
                ],
              ),
            );
          }),
    );
  }
}
