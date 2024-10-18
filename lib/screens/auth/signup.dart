import 'package:chat_duo/ctrl/app_ctrl.dart';
import 'package:chat_duo/screens/_resources/colors.dart';
import 'package:chat_duo/screens/_resources/shared/navigation.dart';
import 'package:chat_duo/screens/auth/login.dart';
import 'package:chat_duo/screens/layout/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCtrl, AppStates>(
      listener: (context, state) {
        if (state is AuthSuccessState) {
          toAndFinish(context, const HomeView());
        }
      },
      builder: (context, state) {
        final cubit = context.read<AppCtrl>();
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "SIGN UP",
                    style: TextStyle(
                        fontSize: 44.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: cubit.usernameCtrl,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: cubit.emailCtrl,
                  decoration: const InputDecoration(labelText: 'Email address'),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: cubit.passwordCtrl,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(height: 40.0),
                ElevatedButton(
                  onPressed: state is AuthLoadingState ? null : cubit.register,
                  child: const Text("SIGNUP"),
                ),
                if (state is AuthLoadingState)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: LinearProgressIndicator(),
                  ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () =>
                          toAndReplace(context, const LoginScreen()),
                      child: const Text("Login"),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
