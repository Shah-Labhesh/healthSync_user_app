import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/Utils/string_extension.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/chats/data/model/chat_room.dart';
import 'package:user_mobile_app/features/chats/widgets/chat_room_tile.dart';
import 'package:user_mobile_app/features/notification/bloc/notification_bloc/notification_bloc.dart';
import 'package:user_mobile_app/widgets/appbar.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';

class MyChatRoomScreen extends StatefulWidget {
  const MyChatRoomScreen({super.key});

  @override
  State<MyChatRoomScreen> createState() => _MyChatRoomScreenState();
}

String token = '';
StreamController<List<ChatRoom>> chatRoomStream = StreamController();

List<ChatRoom> chatRooms = [];

StompClient stompClient = StompClient(
  config: StompConfig(
    url: 'ws://10.0.2.2:8086/ws',
    onConnect: onConnect,
    beforeConnect: () async {
      print('connecting...');
    },
    onDisconnect: (p0) {
      print('onDisconnect: $p0');
    },
    onStompError: (p0) => print('onStompError: $p0'),
    onWebSocketError: (dynamic error) => print('onWebSocketError: $error'),
    stompConnectHeaders: {
      'Authorization': 'Bearer $token',
      'Connection': 'Upgrade',
      'Upgrade': 'websocket'
    },
    webSocketConnectHeaders: {
      'Authorization': 'Bearer $token',
      'Connection': 'Upgrade',
      'Upgrade': 'websocket'
    },
  ),
);
void onConnect(StompFrame frame) {
  stompClient.send(
      destination: '/app/my-rooms',
      body: json.encode({'token': token}),
      headers: {
        'Authorization': 'Bearer $token',
        'Connection': 'Upgrade',
        'Upgrade': 'websocket',
        'content-type': 'application/json',
      },
    ); 

  stompClient.subscribe(
    destination: '/topic/my-rooms',
    headers: {
      'Authorization': 'Bearer $token',
      'Connection': 'Upgrade',
      'Upgrade': 'websocket'
    },
    callback: (frame) {
      Map<String, dynamic> result = json.decode(frame.body as String);
      chatRooms = (result['body'] as List<dynamic>)
          .map((e) => ChatRoom.fromMap(e))
          .toList();
      chatRoomStream.sink.add(chatRooms);
    },
  );

  Timer.periodic(const Duration(seconds: 10), (_) {
    stompClient.send(
      destination: '/app/my-rooms',
      body: json.encode({'token': token}),
      headers: {
        'Authorization': 'Bearer $token',
        'Connection': 'Upgrade',
        'Upgrade': 'websocket',
        'content-type': 'application/json',
      },
    );
  });
}

class _MyChatRoomScreenState extends State<MyChatRoomScreen> {
  bool doctor = false;

  // final WebSocket webSocket = WebSocket();

  @override
  void initState() {
    super.initState();
    initializeRole();
    chatRoomStream = StreamController();
  }

  void initializeRole() async {
    doctor = await SharedUtils.getRole() == 'DOCTOR';
    token = await SharedUtils.getToken();
    if (stompClient.isActive) {
      stompClient.deactivate();
    }
    stompClient.activate();
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stompClient.deactivate();
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
      body: StreamBuilder<List<ChatRoom>>(
          stream: chatRoomStream.stream,
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
                      const Center(
                        child: Text('Error'),
                      )
                    else if (snapshot.data == null || snapshot.data!.isEmpty)
                      const Center(
                        child: Text('No chat rooms available'),
                      )
                    else if (snapshot.hasData)
                      for (ChatRoom e in snapshot.data!)
                        ChatRoomTileWidget(
                          image: doctor ? e.user!.avatar! : e.doctor!.avatar!,
                          name: doctor ? e.user!.name! : 'Dr. ${e.doctor!.name!}',
                          lastMessage: e.lastMessage ?? 'no message yet',
                          time: e.lastMessageAt != null
                              ? e.lastMessageAt!.chatTimeAgo()
                              : '----',
                          onTap: () {
                            Navigator.pushNamed(context, 'chat_screen',
                                arguments: {
                                  'roomId': e.id,
                                  'user' : doctor ? e.user!.id! : e.doctor!.id!,
                                });
                          },
                        ),

                    // const ChatRoomTileWidget(
                    //   image: AppImages.defaultAvatar,
                    //   name: 'Dr. John Doe',
                    //   lastMessage: 'Hello, How are you?',
                    //   isImage: true,
                    //   time: '10:00 AM',
                    // ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
