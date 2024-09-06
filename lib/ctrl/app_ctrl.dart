import 'package:flutter_bloc/flutter_bloc.dart';

class AppCtrl extends Cubit<AppStates> {
  AppCtrl() : super(InitialState());

  bool isDark = false;

  void toggleThemeMode() {
    isDark = !isDark;
    emit(ChangeThemeModeState());
  }
}

abstract class AppStates {}

class InitialState extends AppStates {}

class ChangeThemeModeState extends AppStates {}
