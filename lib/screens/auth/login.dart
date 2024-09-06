import 'package:chat_duo/screens/_resources/colors.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "LOGIN",
                style: TextStyle(
                    fontSize: 44.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 20.0),
            const TextField(
              decoration: InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 20.0),
            const TextField(
              decoration: InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () {},
              child: const Text("LOGIN"),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {},
                  child: const Text("Signup"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
