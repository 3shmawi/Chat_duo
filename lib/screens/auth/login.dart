import 'package:chat_duo/ctrl/app_ctrl.dart';
import 'package:chat_duo/screens/_resources/shared/navigation.dart';
import 'package:chat_duo/screens/auth/signup.dart';
import 'package:chat_duo/screens/layout/layout_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AppCtrl, AppStates>(
        listener: (context, state) {
          if (state is AuthSuccessState) {
            toAndFinish(context, const LayoutView());
          } else {
            print('Error');
          }
        },
        builder: (context, state) {
          final cubit = context.read<AppCtrl>();
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 10,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.asset(
                      'assets/icons/logo.png',
                      height: 150,
                      width: 150,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: cubit.emailCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Email Password',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: cubit.passwordCtrl,
                    obscureText: cubit.isPassword,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: cubit.togglePasswordVisibility,
                        icon: Icon(
                          cubit.isPassword
                              ? CupertinoIcons.eye_slash
                              : CupertinoIcons.eye,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: state is AuthLoadingState ? null : cubit.login,
                    child: const Text('LOGIN'),
                  ),
                  if (state is AuthLoadingState)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: LinearProgressIndicator(),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          toAndReplace(context, const SignupScreen());
                        },
                        child: const Text("Signup"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
