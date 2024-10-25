import 'package:chat_duo/model/user.dart';
import 'package:chat_duo/screens/_resources/shared/toast.dart';
import 'package:chat_duo/services/local_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//
class AppCtrl extends Cubit<AppStates> {
  AppCtrl() : super(AppInitialState());

  //data
  UserModel? myData;
  String? myId = CacheHelper.getData(key: "uid");
  List<UserModel> allUsers = [];
  List<UserModel> selectedUser = [];
  bool isGroupEnable = false;

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
      CacheHelper.saveData(key: "uid", value: response.user!.uid);
      AppToast.success("You have successfully signed in");
      await getMyData(response.user!.uid);
    }).catchError((error) {
      emit(AuthFailureState());
      AppToast.error("The email or password is incorrect\n\n$error");
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
      CacheHelper.saveData(key: "uid", value: response.user!.uid);

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
      CacheHelper.removeData(key: "uid");
      myData = null;
      AppToast.success("You have been logged out");
      return true;
    } catch (error) {
      AppToast.error("An error occurred ${error.toString()}");
      return false;
    }
  }

  //get user data
  Future<void> getMyData(String myId) async {
    myData = await getUserData(myId);
    emit(AuthSuccessState());
  }

  Future<UserModel> getUserData(String uid) async {
    return await _database.collection('users').doc(uid).get().then((snapshot) {
      return UserModel.fromJson(snapshot.data()!);
    });
  }

  //all users
  void refreshAllUsers() async {
    allUsers.clear();
    getAllUsers();
  }

  void getAllUsers() {
    if (allUsers.isNotEmpty) return;
    emit(GetUsersLoadingState());
    _database.collection('users').get().then((snapshot) {
      allUsers.clear(); // clear previous data first
      for (final user in snapshot.docs) {
        if (user.id == myId) continue; // exclude myself from the list
        allUsers.add(UserModel.fromJson(user.data()));
      }
      emit(GetUsersSuccessState());
    }).catchError((error) {
      emit(GetUsersFailureState(error: error.toString()));
      AppToast.error("An error occurred ${error.toString()}");
    });
  }

  void toggleCheckBox() {
    isGroupEnable = !isGroupEnable;
    emit(AppToggleState());
  }

  void addOrRemoveUser(UserModel user) {
    if (selectedUser.contains(user)) {
      selectedUser.remove(user);
    } else {
      selectedUser.add(user);
    }
    emit(AppToggleState());
  }
}

abstract class AppStates {}

class AppInitialState extends AppStates {}

//auth
class AuthLoadingState extends AppStates {}

class AuthSuccessState extends AppStates {}

class AuthFailureState extends AppStates {}

//get all users
class GetUsersLoadingState extends AppStates {}

class GetUsersFailureState extends AppStates {
  final String error;

  GetUsersFailureState({this.error = ''});
}

class GetUsersSuccessState extends AppStates {}

//logic
class AppToggleState extends AppStates {}
