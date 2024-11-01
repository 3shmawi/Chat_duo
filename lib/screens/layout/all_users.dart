import 'package:chat_duo/ctrl/app_ctrl.dart';
import 'package:chat_duo/model/chat.dart';
import 'package:chat_duo/screens/_resources/shared/use_case.dart';
import 'package:chat_duo/screens/layout/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllUsersPage extends StatelessWidget {
  const AllUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCtrl, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = context.read<AppCtrl>();
        final users = cubit.allUsers;
        return Scaffold(
          appBar: AppBar(
            title: const Text('All Users'),
            actions: [
              TextButton(
                onPressed: () {
                  cubit.toggleCheckBox();
                },
                child: const Text(
                  "Enable Select Group",
                  style: TextStyle(
                    color: Colors.deepOrange,
                  ),
                ),
              ),
              if (cubit.isGroupEnable)
                Text("[${cubit.selectedUser.length}]    "),
            ],
          ),
          body: state is GetUsersLoadingState
              ? const AppUseCase(UseCase.loading)
              : state is GetUsersFailureState
                  ? AppUseCase(
                      UseCase.failure,
                      errorMessage: state.error,
                    )
                  : users.isEmpty
                      ? const AppUseCase(UseCase.empty)
                      : Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemBuilder: (context, index) => Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    ChatHomeItem(
                                      ChatModel(
                                          lastMessage: "Start chat with me,",
                                          date: "",
                                          users: [users[index]],
                                          isRead: true),
                                    ),
                                    if (cubit.isGroupEnable)
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Checkbox(
                                          value: cubit.selectedUser
                                              .contains(users[index]),
                                          onChanged: (v) {
                                            cubit.addOrRemoveUser(users[index]);
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                                itemCount: users.length,
                              ),
                            ),
                            if (cubit.isGroupEnable)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        controller: cubit.groupTitle,
                                        decoration: InputDecoration(
                                          hintText: "Group Title",
                                          hintStyle: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (state is GroupCreateLoadingState)
                                      const LinearProgressIndicator(),
                                    SizedBox(
                                      width: 400,
                                      child: ElevatedButton(
                                        onPressed: cubit.createGroup,
                                        child: const Text("CREATE GROUP"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
        );
      },
    );
  }
}
