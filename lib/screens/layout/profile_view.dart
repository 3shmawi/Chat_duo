import 'package:chat_duo/ctrl/app_ctrl.dart';
import 'package:chat_duo/model/user.dart';
import 'package:chat_duo/screens/_resources/shared/toast.dart';
import 'package:chat_duo/screens/_resources/shared/use_case.dart';
import 'package:chat_duo/services/local_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatelessWidget {
  const ProfileView(this.userId, {super.key});

  final String userId;

  @override
  Widget build(BuildContext context) {
    final myId = CacheHelper.getData(key: "myId");
    return BlocConsumer<AppCtrl, AppStates>(
      listener: (context, state) {
        if (state is UpdateProfileSuccessState) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        final cubit = context.read<AppCtrl>();
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
          ),
          body: FutureBuilder<UserModel>(
            future: AppCtrl().getUserData(userId),
            builder: (context, snapshot) {
              final user = snapshot.data;
              if (user == null) {
                return const UseCaseWidget(UseCases.loading);
              }
              cubit.profileNameCtrl.text = user.name;
              return Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 75,
                          backgroundColor: Theme.of(context).dividerColor,
                          child: CircleAvatar(
                            radius: 70,
                            backgroundImage: cubit.selectedProfileImage == null
                                ? NetworkImage(user.avatar)
                                : FileImage(cubit.selectedProfileImage!),
                          ),
                        ),
                        if (userId == myId)
                          CircleAvatar(
                            backgroundColor: Colors.black26,
                            child: IconButton(
                              icon: const Icon(
                                CupertinoIcons.camera,
                                color: Colors.white,
                              ),
                              onPressed: cubit.selectProfileImage,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        readOnly: userId != myId,
                        controller: cubit.profileNameCtrl,
                        decoration: InputDecoration(
                          labelText: 'User Name',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (state is UpdateProfileLoadingState)
                      const UseCaseWidget(UseCases.loading),
                    const Spacer(),
                    if (userId == myId)
                      ElevatedButton.icon(
                        onPressed: state is UpdateProfileLoadingState ||
                                (cubit.selectedProfileImage == null &&
                                    cubit.profileNameCtrl.text.isEmpty)
                            ? null
                            : () {
                                if (cubit.profileNameCtrl.text == user.name &&
                                    cubit.selectedProfileImage == null) {
                                  AppToast.error(
                                      "Please edit name or photo first");
                                } else {
                                  cubit.editProfile(userId);
                                }
                              },
                        label: const Text("Edit Photo"),
                        icon: const Icon(Icons.edit),
                      ),
                    const SizedBox(height: 90),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
