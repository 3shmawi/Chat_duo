import 'package:chat_duo/ctrl/app_ctrl.dart';
import 'package:chat_duo/screens/_resources/shared/navigation.dart';
import 'package:chat_duo/screens/_resources/shared/toast.dart';
import 'package:chat_duo/screens/layout/layout_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final myId = "";

  @override
  void initState() {
    super.initState();
    if (myId != "") {
      _getMyData();
    } else {
      Future.delayed(const Duration(seconds: 2)).then(
        (_) => toAndReplace(context, const LoginScreen()),
      );
    }
  }

  void _getMyData() {
    context.read<AppCtrl>().getUserData(myId, true).then((user) {
      toAndReplace(context, const LayoutView());
    }).catchError((error) {
      AppToast.error('Failed to fetch user data: $error');
      toAndReplace(context, const LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/icons/logo.png',
          height: 150,
          width: 150,
        ),
      ),
    );
  }
}
