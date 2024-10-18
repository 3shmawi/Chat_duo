import 'package:chat_duo/ctrl/app_ctrl.dart';
import 'package:chat_duo/screens/_resources/shared/navigation.dart';
import 'package:chat_duo/screens/auth/login.dart';
import 'package:chat_duo/screens/layout/home_view.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _start();
  }

  _start() async {
    final ctrl = AppCtrl();
    if (ctrl.myId != null) {
      await ctrl.getMyData(ctrl.myId!);
      toAndReplace(context, const HomeView());
    } else {
      Future.delayed(const Duration(seconds: 2)).then(
        (_) => toAndReplace(context, const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                "assets/icons/logo.png",
                height: 150,
                width: 150,
              ),
            ),
            const Spacer(),
            const Text(
              "Powered by Salma",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
