import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/Utils/string_extension.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/chats/bloc/chat_room_bloc/chat_room_bloc.dart';
import 'package:user_mobile_app/features/chats/data/model/chat_room.dart';
import 'package:user_mobile_app/features/chats/widgets/chat_room_tile.dart';
import 'package:user_mobile_app/features/chats/widgets/no_chatroom_widget.dart';
import 'package:user_mobile_app/features/notification/bloc/notification_bloc/notification_bloc.dart';
import 'package:user_mobile_app/widgets/appbar.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';

class MyChatRoomScreen extends StatefulWidget {
  const MyChatRoomScreen({super.key});

  @override
  State<MyChatRoomScreen> createState() => _MyChatRoomScreenState();
}

class _MyChatRoomScreenState extends State<MyChatRoomScreen> {
  bool doctor = false;
  String token = '';

  final ChatRoomStream chatRoomStream = ChatRoomStream();

  @override
  void initState() {
    super.initState();
    initializeRole();
    stream = chatRoomStream.chatRoom;
  }

  late Stream<List<ChatRoom>> stream;

  void initializeRole() async {
    doctor = await SharedUtils.getRole() == 'DOCTOR';
    token = await SharedUtils.getToken();
    chatRoomStream.fetchChatRoom();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    chatRoomStream.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: doctor
          ? const PreferredSize(
              preferredSize: Size.fromHeight(HeightManager.h73),
              child: AppBarCustomWithSceenTitle(
                title: 'Chats',
                isBackButton: true,
              ),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          chatRoomStream.fetchChatRoom();
        },
        child: StreamBuilder<List<ChatRoom>>(
            stream: stream,
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: PaddingManager.paddingMedium2,
                  vertical: PaddingManager.paddingSmall,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (!doctor) ...[
                        BlocProvider(
                          create: (context) => NotificationBloc(),
                          child: const CustomAppBar(
                            title: 'Chats',
                            isBackButton: false,
                            notification: true,
                          ),
                        ),
                        const SizedBox(
                          height: HeightManager.h20,
                        ),
                      ],
                      if (snapshot.connectionState == ConnectionState.waiting)
                        const Center(
                          child: CircularProgressIndicator(),
                        )
                      else if (snapshot.hasError)
                        GestureDetector(
                          onTap: () {
                            chatRoomStream.fetchChatRoom();
                          },
                          child: const Center(
                            child: Text(
                                'Something went wrong. Please try again later'),
                          ),
                        )
                      else if (snapshot.data == null || snapshot.data!.isEmpty)
                        const NoChatRoomWidget()
                      else if (snapshot.hasData)
                        for (ChatRoom e in snapshot.data!)
                          ChatRoomTileWidget(
                            image: doctor ? e.user!.avatar : e.doctor!.avatar,
                            name: doctor
                                ? e.user!.name!
                                : 'Dr. ${e.doctor!.name!}',
                            lastMessage: e.lastMessage ?? 'no message yet',
                            time: e.lastMessageAt != null
                                ? e.lastMessageAt!.chatTimeAgo()
                                : '----',
                            onTap: () {
                              Navigator.pushNamed(context, 'chat_screen',
                                  arguments: {
                                    'roomId': e.id,
                                    'user':
                                        doctor ? e.doctor!.id! : e.user!.id!,
                                  });
                            },
                          ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
