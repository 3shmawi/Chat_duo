import 'package:chat_duo/model/chat.dart';
import 'package:chat_duo/model/message.dart';
import 'package:chat_duo/model/user.dart';
import 'package:chat_duo/resources/shared/toast.dart';
import 'package:chat_duo/services/local_strage.dart';
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
      CacheHelper.saveData(key: "myId", value: user!.id);
      emailCtrl.clear();
      passwordCtrl.clear();
      if (user!.isLoggedIn) {
        AppToast.error("This email is already logged in at another app");
        emit(AuthFailedState());
      } else {
        emit(AuthSuccessState());
        AppToast.success("Logged in successfully");
      }
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
      CacheHelper.saveData(key: "myId", value: user!.id);
      emailCtrl.clear();
      passwordCtrl.clear();
      usrNameCtrl.clear();
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
      CacheHelper.removeData(key: "myId");

      await _auth.signOut();
      user = null;
      AppToast.success("Logout was successful");

      return true;
    } catch (e) {
      AppToast.error(e.toString());
      return false;
    }
  }

  //chat

  List<UserModel> allUsers = [];

  void refreshAllUsers() {
    allUsers.clear();
    getAllUsers();
  }

  void getAllUsers() {
    if (allUsers.isNotEmpty) return;
    emit(GetAllUsersLoadingState());
    _database.collection('users').get().then((snapshot) {
      allUsers =
          snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
      emit(GetAllUsersSuccessState());
    }).catchError((error) {
      AppToast.error(error.message);
      emit(GetAllUsersFailedState());
    });
  }

  //search user form all users
  final searchCtrl = TextEditingController();
  List<UserModel> filteredAllUsers = [];

  void searchAllUsers() {
    filteredAllUsers = allUsers
        .where((user) =>
            user.name.toLowerCase().contains(searchCtrl.text.toLowerCase()))
        .toList();
    emit(GetAllUsersSuccessState());
  }

  //message

  final messageCtrl = TextEditingController();

  void sendMessage({
    required UserModel sender,
    required UserModel receiver,
  }) async {
    if (messageCtrl.text.isEmpty) {
      AppToast.info("Please enter a message");
      return;
    }
    final id = DateTime.now().toIso8601String();
    final message = MessageModel(
      id: id,
      message: messageCtrl.text,
      createdAt: id,
      sender: sender,
      receiver: receiver,
    );

    //for sender
    await _database
        .collection("Mostafa_Users")
        .doc(message.sender.id)
        .collection("users")
        .doc(message.receiver.id)
        .collection("messages")
        .doc(message.id)
        .set(message.toJson());

    messageCtrl.clear();

    await _database
        .collection("Mostafa_Users")
        .doc(message.receiver.id)
        .collection("users")
        .doc(message.sender.id)
        .collection("messages")
        .doc(message.id)
        .set(message.toJson());

    await _database
        .collection("Mostafa_Users")
        .doc(message.sender.id)
        .collection("users")
        .doc(message.receiver.id)
        .set(
          ChatModel(
            user: message.receiver,
            lastMessage: message.message,
            date: message.createdAt,
          ).toJson(),
        );

    await _database
        .collection("Mostafa_Users")
        .doc(message.receiver.id)
        .collection("users")
        .doc(message.sender.id)
        .set(
          ChatModel(
            user: message.sender,
            lastMessage: message.message,
            date: message.createdAt,
          ).toJson(),
        );
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

class GetAllUsersLoadingState extends AppStates {}

class GetAllUsersSuccessState extends AppStates {}

class GetAllUsersFailedState extends AppStates {}
