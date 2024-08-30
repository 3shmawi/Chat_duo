import 'package:chat_duo/resources/colors.dart';
import 'package:chat_duo/resources/shared/navigation.dart';
import 'package:chat_duo/screens/auth/login.dart';
import 'package:flutter/material.dart';

import '_widgets.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

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
                "SIGN UP",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const Text(
                "Let's Join to out group",
              ),
              const SizedBox(height: 32),
              const AppFormField(
                hintText: "User name",
              ),
              const SizedBox(height: 20),
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
                child: const Text('Signup'),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      toAndReplace(context, const LoginScreen());
                    },
                    child: Text(
                      "Login",
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
