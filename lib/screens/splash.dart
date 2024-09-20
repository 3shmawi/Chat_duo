import 'package:chat_duo/ctrl/app_ctrl.dart';
import 'package:chat_duo/resources/assets.dart';
import 'package:chat_duo/resources/colors.dart';
import 'package:chat_duo/resources/shared/navigation.dart';
import 'package:chat_duo/screens/chat/home.dart';
import 'package:chat_duo/services/local_strage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final myId = CacheHelper.getData(key: "myId");

  @override
  void initState() {
    super.initState();
    if (myId != null) {
      context.read<AppCtrl>().getMyData(myId);

      _navigateToHomeScreen(context);
    } else {
      _navigateToLoginScreen(context);
    }
  }

  void _navigateToLoginScreen(BuildContext context) {
    Future.delayed(const Duration(seconds: 2)).then(
      (_) => toAndReplace(context, const LoginScreen()),
    );
  }

  void _navigateToHomeScreen(BuildContext context) {
    Future.delayed(const Duration(seconds: 2)).then(
      (_) => toAndReplace(context, const ChatHomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.asset(
                AppAssets.logo,
                height: 200,
                fit: BoxFit.cover,
                width: 200,
              ),
            ),
            const Spacer(),
            Text(
              "Text Twice",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Connecting with friends and family",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
