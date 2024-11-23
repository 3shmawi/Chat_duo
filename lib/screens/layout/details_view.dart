import 'dart:async';

import 'package:chat_duo/ctrl/app_ctrl.dart';
import 'package:chat_duo/model/group.dart';
import 'package:chat_duo/model/message.dart';
import 'package:chat_duo/model/user.dart';
import 'package:chat_duo/screens/_resources/shared/navigation.dart';
import 'package:chat_duo/screens/_resources/shared/use_case.dart';
import 'package:chat_duo/screens/layout/profile_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_recorder/audio_encoder_type.dart';
import 'package:social_media_recorder/screen/social_media_recorder.dart';

import '../../app/functions.dart';
import 'audio_player.dart';
import 'display_image.dart';
import 'image_or_video_display.dart';

class DetailsView extends StatefulWidget {
  const DetailsView(
      {this.receiver,
      this.groupChatModel,
      this.isGroupChat = false,
      super.key});

  final UserModel? receiver;
  final GroupChatModel? groupChatModel;
  final bool isGroupChat;

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool isKeyboardActive = false;

  @override
  void initState() {
    super.initState();
    _refresh();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
    _scrollController.addListener(_checkIfAtBottom);

    Future.delayed(const Duration(milliseconds: 300)).then((_) => _goBottom());
    _focusNode.addListener(() {
      setState(() {
        isKeyboardActive = _focusNode.hasFocus;
      });
    });
  }

  late final Timer _timer;

  _refresh() {
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (t) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.removeListener(_checkIfAtBottom);
    _timer.cancel();
    super.dispose();
  }

  void _goBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _checkIfAtBottom() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels !=
          _scrollController.position.maxScrollExtent) {
        _goBottom();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sender = context.read<AppCtrl>().user;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
              ),
            ),
            GestureDetector(
              onTap: widget.isGroupChat
                  ? null
                  : () => toPage(context, ProfileView(widget.receiver!.id)),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                  widget.isGroupChat
                      ? widget.groupChatModel!.groupPicture
                      : widget.receiver!.avatar,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.isGroupChat
                  ? widget.groupChatModel!.groupTitle
                  : widget.receiver!.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
                stream: widget.isGroupChat
                    ? AppCtrl().getGroupMessages(widget.groupChatModel!.id)
                    : AppCtrl().getMessages(widget.receiver!.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    final messages = snapshot.data;
                    if (messages == null || messages.isEmpty) {
                      return Center(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: const UseCaseWidget(UseCases.empty),
                        ),
                      );
                    }

                    return Stack(
                      children: [
                        ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(
                            bottom: 20,
                          ),
                          itemBuilder: (context, index) =>
                              _isAudioUrl(messages[index].message)
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: AudioMessageWidget(
                                        date: messages[index].createdAt,
                                        audioUrl: messages[index].message,
                                        isSender: sender!.id ==
                                            messages[index].senderId,
                                      ),
                                    )
                                  : _ChatItem(
                                      message: messages[index],
                                      isGroup: widget.isGroupChat,
                                      isSender: sender!.id ==
                                          messages[index].senderId,
                                    ),
                          itemCount: messages.length,
                        ),
                        Positioned(
                          bottom: 10,
                          left: 6,
                          child: IconButton(
                            onPressed: _goBottom,
                            icon: const Icon(
                              CupertinoIcons.arrow_down_circle,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return SingleChildScrollView(
                      controller: _scrollController,
                      child: const UseCaseWidget(UseCases.loading));
                }),
          ),
          BlocBuilder<AppCtrl, AppStates>(
            builder: (context, state) {
              final cubit = context.read<AppCtrl>();
              return Column(
                children: [
                  if (cubit.selectedImages.isNotEmpty)
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Stack(
                            alignment: Alignment.topRight,
                            children: [
                              SizedBox(
                                height: 100,
                                width: 150,
                                child: Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Image.file(
                                    cubit.selectedImages[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.black26,
                                child: IconButton(
                                  onPressed: () {
                                    cubit.removeSelectedImage(index);
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                        itemCount: cubit.selectedImages.length,
                      ),
                    ),
                  if (state is UploadImageLoadingState)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: LinearProgressIndicator(),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            cubit.refresh();
                            _goBottom();
                          },
                          controller: context.read<AppCtrl>().messageCtrl,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 15),
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade400,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                cubit.selectImages();
                              },
                              icon: const Icon(
                                CupertinoIcons.photo,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          onTapOutside: (_) {
                            _focusNode.unfocus();
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                      cubit.messageCtrl.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                cubit.sendMessage(
                                  sender!,
                                  receiver: widget.receiver,
                                  isGroup: widget.isGroupChat,
                                  groupModel: widget.groupChatModel,
                                );
                                _goBottom();
                              },
                              icon: const Icon(
                                Icons.send,
                                color: Colors.red,
                              ),
                            )
                          : SocialMediaRecorder(
                              sendRequestFunction: (soundFile, time) {
                                cubit.sendMessage(
                                  sender!,
                                  receiver: widget.receiver,
                                  isGroup: widget.isGroupChat,
                                  groupModel: widget.groupChatModel,
                                  audioFile: soundFile,
                                );
                                print(soundFile.path);
                                print(time);
                              },
                              backGroundColor: Colors.transparent,
                              encode: AudioEncoderType.AAC,
                              recordIcon: const Icon(
                                CupertinoIcons.mic_fill,
                                color: Colors.red,
                              ),
                            ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  bool _isAudioUrl(String url) {
    final audioExtensions = ['.mp3', '.wav', '.m4a', '.flac', '.aac', '.ogg'];
    return audioExtensions.any((ext) => url.toLowerCase().contains(ext));
  }
}

class _ChatItem extends StatelessWidget {
  const _ChatItem({
    required this.message,
    required this.isSender,
    required this.isGroup,
  });

  final MessageModel message;
  final bool isSender;
  final bool isGroup;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isSender) const Expanded(child: SizedBox()),
        if (!isSender)
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.black26,
            backgroundImage: NetworkImage(message.senderAvatar ??
                "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?size=626&ext=jpg"),
          ),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              if (message.imgUrl.isNotEmpty)
                Wrap(
                  children: List.generate(
                    message.imgUrl.length,
                    (index) => GestureDetector(
                      onTap: () {
                        toPage(
                          context,
                          MediaViewerPage(
                            mediaUrls: message.imgUrl,
                            initialIndex: index,
                          ),
                        );
                      },
                      child: MediaWidget(mediaUrl: message.imgUrl[index]),
                    ),
                  ),
                ),
              Align(
                alignment: isSender ? Alignment.topRight : Alignment.topLeft,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isSender ? Colors.red : Colors.grey.shade400,
                    borderRadius: BorderRadius.only(
                      topLeft:
                          isSender ? const Radius.circular(10) : Radius.zero,
                      topRight:
                          !isSender ? const Radius.circular(10) : Radius.zero,
                      bottomLeft:
                          isSender ? Radius.zero : const Radius.circular(10),
                      bottomRight:
                          !isSender ? Radius.zero : const Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: isSender
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: [
                      if (!isSender && isGroup)
                        Text(
                          message.senderName ?? "",
                          style: TextStyle(
                            color: isSender ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (message.message.isNotEmpty)
                        Text(
                          message.message,
                          style: TextStyle(
                            color: isSender ? Colors.white : Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      Text(
                        daysBetween(message.createdAt),
                        style: TextStyle(
                          color: isSender ? Colors.white70 : Colors.black45,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isSender) const Expanded(child: SizedBox()),
      ],
    );
  }
}
