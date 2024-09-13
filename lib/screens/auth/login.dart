import 'package:chat_duo/ctrl/app_ctrl.dart';
import 'package:chat_duo/resources/colors.dart';
import 'package:chat_duo/resources/shared/navigation.dart';
import 'package:chat_duo/screens/auth/register.dart';
import 'package:chat_duo/screens/chat/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '_widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCtrl, AppStates>(
      listener: (context, state) {
        if (state is AuthSuccessState) {
          toAndFinish(context, const ChatHomeScreen());
        }
      },
      builder: (context, state) {
        final cubit = context.read<AppCtrl>();
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
                  AppFormField(
                    controller: cubit.emailCtrl,
                    hintText: "Email address",
                  ),
                  const SizedBox(height: 20),
                  AppFormField(
                    controller: cubit.passwordCtrl,
                    enablePasswordVisibilityIcon: true,
                    hintText: "Password",
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: state is AuthLoadingState ? null : cubit.login,
                    child: const Text('Login'),
                  ),
                  if (state is AuthLoadingState)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: LinearProgressIndicator(),
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
      },
    );
  }
}
