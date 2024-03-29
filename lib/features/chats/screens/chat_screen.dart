import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/Utils/string_extension.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/chats/data/model/chat_mesaage.dart';
import 'package:user_mobile_app/features/chats/widgets/chat_bubble.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

String token = '';
String chatRoomId = '';
String destination = 'get-messages';
StreamController<List<ChatMessage>> chatStream = StreamController();

StompClient stompClient = StompClient(
  config: StompConfig(
    url: 'ws://10.0.2.2:8086/ws',
    onConnect: onConnect,
    beforeConnect: () async {},
    onDisconnect: (p0) {},
    onStompError: (p0) => debugPrint('onStompError: $p0'),
    onWebSocketError: (dynamic error) => debugPrint('onWebSocketError: $error'),
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
  try {
    if (!stompClient.isActive) {
      return;
    }
    destination = chatRoomId;
      stompClient.subscribe(
        destination: '/topic/$destination',
        headers: {
          'Authorization': 'Bearer $token',
          'Connection': 'Upgrade',
          'Upgrade': 'websocket'
        },
        callback: (frame) {
          List<ChatMessage> message = (json.decode(frame.body as String) as List<dynamic>)
              .map((e) => ChatMessage.fromMap(e))
              .toList();
          chatStream.sink.add(message);
        },

      );

    
    
    stompClient.send(
      destination: '/app/get-messages',
      body: json.encode({'token': token, 'roomId': chatRoomId}),
      headers: {
        'Authorization': 'Bearer $token',
        'Connection': 'Upgrade',
        'Upgrade': 'websocket',
        'content-type': 'application/json',
      },
    );
    destination = chatRoomId;
  } catch (e) {
    debugPrint('Error: $e');
  }
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isFocusCustom = false;

  String currentUser = '';

  changeState(bool value) {
    setState(() {
      isFocusCustom = value;
    });
  }

  @override
  void initState() {
    super.initState();
    initToken();
    chatStream = StreamController();
  }

  initToken() async {
    token = await SharedUtils.getToken();
    stompClient.activate();
  }

  @override
  void dispose() {
    super.dispose();
    chatStream.close();
    stompClient.deactivate();
    destination = 'get-messages';
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      chatRoomId = args['roomId'];
      currentUser = args['user'];
    }
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(HeightManager.h73),
        child: AppBarCustomWithSceenTitle(
          title: 'Chat',
          isBackButton: true,
        ),
      ),
      body: StreamBuilder<List<ChatMessage>>(
          stream: chatStream.stream,
          builder: (context, snapshot) {
            return SingleChildScrollView(
              reverse: true,
              controller: _scrollController,
              child: Column(
                children: [
                  const SizedBox(height: HeightManager.h20),
                  if (snapshot.connectionState == ConnectionState.waiting)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else if (snapshot.hasError)
                    const Center(
                      child: Text('Error'),
                    )
                  else if (!snapshot.hasData)
                    const Center(
                      child: Text('No messages'),
                    )
                  else if (snapshot.hasData) ...[
                    for (ChatMessage chat in snapshot.data!) ...[
                      ChatBubble(
                        isMe: chat.senderId == currentUser,
                        text: chat.message ?? '',
                        time: chat.createdAt!.splitTime(),
                      ),
                    ],
                  ],
                ],
              ),
            );
          }),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: PaddingManager.paddingMedium,
          right: PaddingManager.paddingMedium,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: PaddingManager.p10,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.attach_file,
                color: gray800,
              ),
              const SizedBox(
                width: WidthManager.w5,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Focus(
                          onFocusChange: (value) {
                            changeState(value);
                          },
                          child: TextFormField(
                            controller: controller,
                            onTap: () {
                              controller.selection = TextSelection.fromPosition(
                                TextPosition(
                                  offset: controller.text.length,
                                ),
                              );
                            },
                            maxLines: isFocusCustom == false ? 1 : null,
                            autofocus: isFocusCustom,
                            textInputAction: TextInputAction.newline,
                            cursorColor: black,
                            style: TextStyle(
                              color: black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: PaddingManager.p10,
                                horizontal: PaddingManager.paddingMedium,
                              ),
                              filled: isFocusCustom,
                              fillColor: gray200,
                              hintStyle: TextStyle(
                                color: gray800,
                                fontSize: FontSizeManager.f14,
                                fontWeight: FontWeight.w400,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                              hintText: 'Type a message...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: WidthManager.w5,
              ),
              GestureDetector(
                onTap: () {
                  if (controller.text.isNotEmpty) {
                    stompClient.send(
                      destination: '/app/message',
                      body: json.encode({
                        'token': token,
                        'roomId': chatRoomId,
                        'message': controller.text,
                      }),
                      headers: {
                        'Authorization': 'Bearer $token',
                        'Connection': 'Upgrade',
                        'Upgrade': 'websocket',
                        'content-type': 'application/json',
                      },
                    );
                    controller.clear();
                    _scrollController.animateTo(
                      0.0,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 300),
                    );
                    destination = chatRoomId;
                  }

                  setState(() {});
                },
                child: Container(
                  height: HeightManager.h50,
                  width: WidthManager.w50,
                  decoration: BoxDecoration(
                    color: blue900,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.send,
                    color: gray200,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
