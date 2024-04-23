import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'Package:http_parser/http_parser.dart';
import 'package:user_mobile_app/Utils/image_picker.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/Utils/string_extension.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_urls.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/chats/data/model/chat_mesaage.dart';
import 'package:user_mobile_app/features/chats/widgets/chat_bubble.dart';
import 'package:user_mobile_app/main.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

String token = '';
String chatRoomId = '';
String destination = 'get-messages';
StreamController<Map<String, List<ChatMessage>>> chatStream =
    StreamController();

List<String> dateList = [];

StompClient stompClient = StompClient(
  config: StompConfig(
    url: SOCKET_URL,
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
        if (chatStream.isClosed) return;
        List<ChatMessage> messages =
            (json.decode(frame.body as String) as List<dynamic>)
                .map((e) => ChatMessage.fromMap(e))
                .toList();
        dateList.clear();
        final messageMap = mapMessageAccordingDate(messages);
        chatStream.sink.add(messageMap);
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

mapMessageAccordingDate(List<ChatMessage> messages) {
  Map<String, List<ChatMessage>> messageMap = {};
  for (ChatMessage message in messages) {
    String date = message.createdAt!.splitDate();
    if (messageMap.containsKey(date)) {
      messageMap[date]!.add(message);
    } else {
      dateList.add(date);
      messageMap[date] = [message];
    }
  }
  return messageMap;
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

  Widget showImageDialog(BuildContext context) {
    File? image;
    return SimpleDialog(
      title: const Text('Select Image'),
      children: [
        SimpleDialogOption(
          onPressed: () async {
            image = await ImagePick.pickImage(source: ImageSource.camera);
            if (image != null) {
              Navigator.pop(context,image);
            }
            setState(() {});
          },
          child: const Text('Camera'),
        ),
        SimpleDialogOption(
          onPressed: () async {
            image =
                await ImagePick.pickImage(source: ImageSource.gallery);
            if (image != null) {
              Navigator.pop(context,image);
            }
            setState(() {});
          },
          child: const Text('Gallery'),
        ),
      ],
    );
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
    chatScreen = true;
  }

  @override
  void dispose() {
    super.dispose();
    chatStream.close();
    dateList.clear();
    stompClient.deactivate();
    destination = 'get-messages';
    chatScreen = false;
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
      body: StreamBuilder<Map<String, List<ChatMessage>>>(
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
                  else if (snapshot.data == null || snapshot.data!.isEmpty)
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: gray200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: PaddingManager.p10,
                            horizontal: PaddingManager.paddingMedium,
                          ),
                          child: Text(
                            'No messages',
                            style: TextStyle(
                              color: gray800,
                              fontSize: FontSizeManager.f12,
                              fontWeight: FontWeight.w400,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            ),
                          ),
                        ),
                      ),
                    )
                  else if (snapshot.hasData) ...[
                    for (String date in dateList) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: PaddingManager.paddingMedium,
                          vertical: PaddingManager.paddingSmall,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: gray200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: PaddingManager.p10,
                              horizontal: PaddingManager.paddingMedium,
                            ),
                            child: Text(
                              date == DateTime.now().toString().splitDate()
                                  ? 'Today'
                                  : date ==
                                          DateTime.now()
                                              .subtract(const Duration(days: 1))
                                              .toString()
                                              .splitDate()
                                      ? 'Yesterday'
                                      : date,
                              style: TextStyle(
                                color: gray800,
                                fontSize: FontSizeManager.f12,
                                fontWeight: FontWeight.w400,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                          ),
                        ),
                      ),
                      for (ChatMessage chat in snapshot.data![date]!) ...[
                        ChatBubble(
                          isMe: chat.senderId == currentUser,
                          text: chat.message ?? '',
                          time: chat.createdAt!.splitTime(),
                        ),
                      ],
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
              GestureDetector(
                onTap: () async {
                    showDialog(
                            context: context,
                            builder: (context) => showImageDialog(context),
                          ).then((val) async {
                                 print('here before');
                                try {
                                  if (val != null) {
                                    print(val.path);
                                    final file = File(val!.path);
                                    final List<int> imageBytes = await file.readAsBytes();

                                    // Encode image file as base64
                                    String base64Image = base64Encode(imageBytes);

                                    stompClient.send(
                                      destination: '/app/message',
                                      body: json.encode({
                                        'token': token,
                                        'roomId': chatRoomId,
                                        'message': "file",
                                        'file': base64Image, // Send the base64 encoded image
                                        'messageType': 'IMAGE',
                                      }),
                                      headers: {
                                        'Authorization': 'Bearer $token',
                                        'Connection': 'Upgrade',
                                        'Upgrade': 'websocket',
                                        'content-type': 'application/json', // Change content type to application/json
                                      },
                                    );
                                    _scrollController.animateTo(
                                      0.0,
                                      curve: Curves.easeOut,
                                      duration: const Duration(milliseconds: 300),
                                    );
                                    destination = chatRoomId;
                                  }
                                } catch (e) {
                                  print(e.toString());
                                  Utils.showSnackBar(context, e.toString());
                                }

                          });
                },
                child:const Icon(
                Icons.attach_file,
                color: gray800,
              ),
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
                        'messageType' : 'TEXT',
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
