import 'package:chat_duo/model/chat.dart';
import 'package:chat_duo/model/message.dart';
import 'package:chat_duo/model/user.dart';
import 'package:chat_duo/screens/_resources/shared/toast.dart';
import 'package:chat_duo/services/local_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppCtrl extends Cubit<AppStates> {
  AppCtrl() : super(AppInitialState());

  //data
  String? myId = CacheHelper.getData(key: "myId");
  UserModel? user;

  List<UserModel> allUsers = [];
  List<UserModel> filteredUsers = [];

  final _auth = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;

  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  final searchText = TextEditingController();
  final messageCtrl = TextEditingController();

  bool isSearch = false;

  //auth

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
      final user = await getUserData(response.user!.uid, true);
      this.user = user;
      myId = response.user!.uid;
      emailCtrl.clear();
      passwordCtrl.clear();
      CacheHelper.saveData(key: "myId", value: response.user!.uid);
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
      myId = response.user!.uid;
      usernameCtrl.clear();
      passwordCtrl.clear();
      emailCtrl.clear();
      AppToast.success("Account created successfully");
      CacheHelper.saveData(key: "myId", value: response.user!.uid);
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
      return user;
    }).catchError((error) {
      throw Exception('Error getting document: $error');
    });
  }

  Future<bool> logout() async {
    try {
      await _auth.signOut();
      user = null;
      myId = null;
      CacheHelper.removeData(key: "myId");
      AppToast.success("Logging out user successfully");
      return true;
    } catch (e) {
      AppToast.error("Error logging out: $e");
      return false;
    }
  }

  //search and all users

  void toggleSearch() {
    searchText.clear();
    isSearch = !isSearch;
    emit(ToggleSearchState());
  }

  void refreshAllUsers() {
    allUsers.clear();
    getAllUsers();
  }

  void getAllUsers() {
    if (allUsers.isNotEmpty) return;
    emit(GetAllUsersLoadingState());
    _database.collection('users').get().then((snapshot) {
      allUsers.clear();
      for (final user in snapshot.docs) {
        if (user.id == myId) {
          continue;
        }
        allUsers.add(UserModel.fromJson(user.data()));
      }
      emit(GetAllUsersSuccessState());
    }).catchError((error) {
      AppToast.error("Error getting documents: $error");
      emit(GetAllUsersErrorState());
    });
  }

  void filterUsers() {
    filteredUsers = allUsers
        .where((user) =>
            user.name.toLowerCase().contains(searchText.text.toLowerCase()))
        .toList();
    emit(GetAllUsersSuccessState());
  }

  //streams
  Stream<List<ChatModel>> getMyUsers() {
    return _database
        .collection("my_users")
        .doc(myId)
        .collection("chats")
        .orderBy("date", descending: true)
        .snapshots()
        .map((response) => response.docs
            .map((user) => ChatModel.fromJson(user.data()))
            .toList());
  }

  void sendMessage(UserModel receiver, UserModel sender) async {
    if (messageCtrl.text.isEmpty) {
      AppToast.error("Please enter a message");
      return;
    }

    final newId = DateTime.now().toIso8601String();
    final newMessage = MessageModel(
      id: newId,
      message: messageCtrl.text,
      createdAt: newId,
      updatedAt: newId,
      senderId: sender.id,
      receiverId: receiver.id,
      imgUrl: [],
    );

    await _database
        .collection("my_users")
        .doc(newMessage.senderId)
        .collection("chats")
        .doc(newMessage.receiverId)
        .collection("messages")
        .doc(newMessage.id)
        .set(newMessage.toJson());
    messageCtrl.clear();

    await _database
        .collection("my_users")
        .doc(newMessage.receiverId)
        .collection("chats")
        .doc(newMessage.senderId)
        .collection("messages")
        .doc(newMessage.id)
        .set(newMessage.toJson());

    await _database
        .collection("my_users")
        .doc(newMessage.receiverId)
        .collection("chats")
        .doc(newMessage.senderId)
        .set(ChatModel(
          lastMessage: newMessage.message,
          date: newMessage.createdAt,
          user: sender,
          isRead: false,
          isActive: true,
        ).toJson());

    await _database
        .collection("my_users")
        .doc(newMessage.senderId)
        .collection("chats")
        .doc(newMessage.receiverId)
        .set(ChatModel(
          lastMessage: newMessage.message,
          date: newMessage.createdAt,
          user: receiver,
          isRead: false,
          isActive: true,
        ).toJson());
  }

  Stream<List<MessageModel>> getMessages(String receiverId) {
    return _database
        .collection("my_users")
        .doc(myId)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .orderBy("created_at", descending: false)
        .snapshots()
        .map((response) => response.docs
            .map((doc) => MessageModel.fromJson(doc.data()))
            .toList());
  }
}

abstract class AppStates {}

class AppInitialState extends AppStates {}

//auth
class AuthLoadingState extends AppStates {}

class AuthSuccessState extends AppStates {}

class AuthErrorState extends AppStates {}

class GetMyDataState extends AppStates {}

//
class GetAllUsersLoadingState extends AppStates {}

class GetAllUsersSuccessState extends AppStates {}

class GetAllUsersErrorState extends AppStates {}

class ToggleSearchState extends AppStates {}
