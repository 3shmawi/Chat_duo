import 'package:chat_duo/ctrl/app_ctrl.dart';
import 'package:chat_duo/resources/theme.dart';
import 'package:chat_duo/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCtrl(),
      child: BlocBuilder<AppCtrl, AppStates>(
        buildWhen: (_, current) => current is ChangeThemeModeState,
        builder: (context, state) {
          final isDark = context.read<AppCtrl>().isDark;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
