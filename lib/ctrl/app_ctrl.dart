import 'package:chat_duo/model/user.dart';
import 'package:chat_duo/screens/_resources/shared/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppCtrl extends Cubit<AppStates> {
  AppCtrl() : super(AppInitialState());

  //data
  UserModel? user;

  //auth
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;

  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  void login() {
    if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      AppToast.error("Please fill all fields");
      return;
    }
    emit(AuthLoadingState());
    _auth
        .signInWithEmailAndPassword(
            email: emailCtrl.text, password: passwordCtrl.text)
        .then((response) async {
      user = await getUserData(response.user!.uid);
      emailCtrl.clear();
      passwordCtrl.clear();
      AppToast.success("Logged in successfully");
      emit(AuthSuccessState());
    }).catchError((error) {
      AppToast.error("Invalid email or password\n${error.toString()}");
      emit(AuthErrorState());
    });
  }

  void signUp() {
    if (usernameCtrl.text.isEmpty ||
        emailCtrl.text.isEmpty ||
        passwordCtrl.text.isEmpty) {
      return;
    }
    emit(AuthLoadingState());
    _auth
        .createUserWithEmailAndPassword(
            email: emailCtrl.text, password: passwordCtrl.text)
        .then((response) async {
      await _createUser(response.user!.uid);
      usernameCtrl.clear();
      passwordCtrl.clear();
      emailCtrl.clear();
      AppToast.success("Account created successfully");

      emit(AuthSuccessState());
    }).catchError((error) {
      AppToast.error("Failed to create account ${error.toString()}");
      emit(AuthErrorState());
    });
  }

  Future<void> _createUser(String id) async {
    final newUser = UserModel(
      id: id,
      name: usernameCtrl.text,
      email: emailCtrl.text,
      avatar:
          "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?size=626&ext=jpg",
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );

    await _database.collection('users').doc(id).set(newUser.toJson());
    user = newUser;
  }

  Future<UserModel> getUserData(String id, [bool isMyData = false]) async {
    return await _database.collection('users').doc(id).get().then((snapshot) {
      if (!snapshot.exists) {
        AppToast.error('User does not exist');
        throw Exception('User does not exist');
      }
      final user = UserModel.fromJson(snapshot.data()!);
      if (isMyData) {
        this.user = user;
        emit(GetMyDataState());
      }
      return UserModel.fromJson(snapshot.data()!);
    }).catchError((error) {
      throw Exception('Error getting document: $error');
    });
  }
}

abstract class AppStates {}

class AppInitialState extends AppStates {}

//auth
class AuthLoadingState extends AppStates {}

class AuthSuccessState extends AppStates {}

class AuthErrorState extends AppStates {}

class GetMyDataState extends AppStates {}
