import 'package:chat_duo/resources/colors.dart';
import 'package:chat_duo/resources/shared/navigation.dart';
import 'package:chat_duo/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ctrl/app_ctrl.dart';
import '../chat/home.dart';
import '_widgets.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

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
                  AppFormField(
                    controller: cubit.usrNameCtrl,
                    hintText: "User name",
                  ),
                  const SizedBox(height: 20),
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
                    onPressed: state is AuthLoadingState ? null : cubit.signUp,
                    child: const Text('Signup'),
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
      },
    );
  }
}
