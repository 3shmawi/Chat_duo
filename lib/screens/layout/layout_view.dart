import 'package:chat_duo/screens/_resources/shared/navigation.dart';
import 'package:chat_duo/screens/auth/login.dart';
import 'package:flutter/material.dart';

class LayoutView extends StatelessWidget {
  const LayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            toAndFinish(context, const LoginScreen());
          },
          child: const Text('Go to Login Page'),
        ),
      ),
    );
  }
}
