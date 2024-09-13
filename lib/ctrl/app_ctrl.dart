import 'package:chat_duo/model/user.dart';
import 'package:chat_duo/resources/shared/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppCtrl extends Cubit<AppStates> {
  AppCtrl() : super(InitialState());

  bool isDark = false;

  void toggleThemeMode() {
    isDark = !isDark;
    emit(ChangeThemeModeState());
  }

  //data
  UserModel? user;

  //auth
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;

  final usrNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  void login() {
    if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      AppToast.info("Please enter your email address and password");
      return;
    }
    emit(AuthLoadingState());
    _auth
        .signInWithEmailAndPassword(
      email: emailCtrl.text,
      password: passwordCtrl.text,
    )
        .then((response) async {
      user = await getUserData(response.user!.uid);
      if (user!.isLoggedIn) {
        AppToast.error("This email is already logged in");
        emit(AuthFailedState());
      } else {
        emit(AuthSuccessState());
      }
      AppToast.success("Logged in successfully");
    }).catchError((error) {
      AppToast.error(error.message);
      emit(AuthFailedState());
    });
  }

  void signUp() {
    if (emailCtrl.text.isEmpty ||
        passwordCtrl.text.isEmpty ||
        usrNameCtrl.text.isEmpty) {
      AppToast.info("Please enter all fields");
      return;
    }
    emit(AuthLoadingState());
    _auth
        .createUserWithEmailAndPassword(
      email: emailCtrl.text,
      password: passwordCtrl.text,
    )
        .then((response) async {
      await _createUser(response.user!.uid);
      emit(AuthSuccessState());
      AppToast.success("User created successfully");
    }).catchError((error) {
      AppToast.error(error.message);
      emit(AuthFailedState());
    });
  }

  Future<void> _createUser(String uId) async {
    final newUser = UserModel(
      id: uId,
      name: usrNameCtrl.text,
      email: emailCtrl.text,
      avatar:
          "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?size=626&ext=jpg",
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      isLoggedIn: true,
    );
    await _database.collection("users").doc(uId).set(newUser.toJson());
    user = newUser;
  }

  void getMyData(String myId) {
    emit(GetUserDataLoadingState());
    getUserData(myId).then((user) {
      this.user = user;
      emit(GetUserDataSuccessState());
    }).catchError((error) {
      AppToast.error(error.message);
      emit(GetUserDataFailedState());
    });
  }

  Future<UserModel> getUserData(String uId) {
    return _database.collection('users').doc(uId).get().then((snapshot) {
      if (!snapshot.exists) {
        throw Exception('Document does not exist');
      }
      return UserModel.fromJson(snapshot.data()!);
    }).catchError((error) {
      AppToast.error(error.message);

      throw error;
    });
  }

  Future<bool> logout() async {
    try {
      await _database
          .collection('users')
          .doc(user!.id)
          .update({"is_logged_in": false});

      await _auth.signOut();
      user = null;
      return true;
    } catch (e) {
      AppToast.error(e.toString());
      return false;
    }
  }
}

abstract class AppStates {}

class InitialState extends AppStates {}

class ChangeThemeModeState extends AppStates {}

//auth
class AuthLoadingState extends AppStates {}

class AuthFailedState extends AppStates {}

class AuthSuccessState extends AppStates {}

//user
class GetUserDataLoadingState extends AppStates {}

class GetUserDataSuccessState extends AppStates {}

class GetUserDataFailedState extends AppStates {}
