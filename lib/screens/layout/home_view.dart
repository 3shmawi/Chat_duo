import 'package:chat_duo/ctrl/app_ctrl.dart';
import 'package:chat_duo/screens/_resources/shared/navigation.dart';
import 'package:chat_duo/screens/auth/login.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          TextButton(
            onPressed: () {
              AppCtrl().logout().then((loggedOut) {
                if (loggedOut) {
                  toAndFinish(context, const LoginScreen());
                }
              });
            },
            child: Text("LOGOUT"),
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome to the Home Page!'),
      ),
    );
  }
}
