import 'package:chat_duo/model/user.dart';
import 'package:chat_duo/screens/_resources/shared/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppCtrl extends Cubit<AppStates> {
  AppCtrl() : super(AppInitialState());

  //data
  UserModel? myData;

  final _auth = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;

  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  void login() {
    if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      AppToast.info("please fill all the fields first");
      return;
    }
    emit(AuthLoadingState());
    _auth
        .signInWithEmailAndPassword(
      email: emailCtrl.text,
      password: passwordCtrl.text,
    )
        .then((response) async {
      emailCtrl.clear();
      passwordCtrl.clear();
      await getMyData(response.user!.uid);
      AppToast.success("You have successfully signed in");
      emit(AuthSuccessState());
    }).catchError((error) {
      emit(AuthFailureState());
      AppToast.error("The email or password is incorrect $error");
    });
  }

  void register() {
    if (emailCtrl.text.isEmpty ||
        passwordCtrl.text.isEmpty ||
        usernameCtrl.text.isEmpty) {
      AppToast.info("Please fill all the fields first");
      return;
    }

    emit(AuthLoadingState());
    _auth
        .createUserWithEmailAndPassword(
            email: emailCtrl.text, password: passwordCtrl.text)
        .then((response) async {
      await _createUser(response.user!.uid);
      AppToast.success("You have successfully registered");
      emit(AuthSuccessState());
    }).catchError((error) {
      emit(AuthFailureState());
      AppToast.error("An error occurred ${error.toString()}");
    });
  }

  Future<void> _createUser(String uid) async {
    final newUser = UserModel(
      id: uid,
      name: usernameCtrl.text,
      email: emailCtrl.text,
      avatar:
          "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?size=626&ext=jpg",
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );
    await _database.collection('users').doc(uid).set(newUser.toJson());
    usernameCtrl.clear();
    emailCtrl.clear();
    passwordCtrl.clear();
    myData = newUser;
  }

  Future<bool> logout() async {
    try {
      await _auth.signOut();
      myData = null;
      return true;
    } catch (error) {
      AppToast.error("An error occurred ${error.toString()}");
      return false;
    }
  }

  //get user data
  Future<void> getMyData(String myId) async {
    myData = await getUserData(myId);
  }

  Future<UserModel> getUserData(String uid) async {
    return await _database.collection('users').doc(uid).get().then((snapshot) {
      return UserModel.fromJson(snapshot.data()!);
    });
  }
}

abstract class AppStates {}

class AppInitialState extends AppStates {}

//auth
class AuthLoadingState extends AppStates {}

class AuthSuccessState extends AppStates {}

class AuthFailureState extends AppStates {}
