import 'package:chat_duo/resources/colors.dart';
import 'package:chat_duo/resources/shared/navigation.dart';
import 'package:chat_duo/screens/auth/register.dart';
import 'package:flutter/material.dart';

import '_widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "LOGIN",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const Text(
                "Welcome back to our app!",
              ),
              const SizedBox(height: 32),
              const AppFormField(
                hintText: "Email address",
              ),
              const SizedBox(height: 20),
              const AppFormField(
                hintText: "Password",
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Login'),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      toAndReplace(context, const SignupScreen());
                    },
                    child: Text(
                      "Signup",
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
