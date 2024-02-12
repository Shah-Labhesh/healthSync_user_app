import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/chats/data/model/chat_mesaage.dart';
import 'package:user_mobile_app/features/chats/widgets/chat_bubble.dart';
import 'package:user_mobile_app/features/chats/widgets/image_bubble.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';
import 'package:user_mobile_app/widgets/custom_textfield.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isFocusCustom = false;

  changeState(bool value) {
    setState(() {
      isFocusCustom = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBarCustomWithSceenTitle(
          title: 'Chat',
          isBackButton: true,
          action: PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('Delete'),
                ),
              ];
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        controller: _scrollController,
        child: Column(
          children: [
            const SizedBox(height: 20),
            for (ChatMessage chat in ChatMessageModelData.chatMessages) ...[
              ChatBubble(
                isMe: chat.isMe,
                text: chat.text ?? '',
                time: chat.time,
              ),
            ],
            ImageBubble(
              image: AppImages.doctor2,
              time: '10:00 AM',
              isMe: false,
            ),
            ImageBubble(
              image: AppImages.doctor2,
              time: '10:00 AM',
              isMe: true,
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
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
                                vertical: 10,
                                horizontal: 17,
                              ),
                              filled: isFocusCustom,
                              fillColor: gray200,
                              hintStyle: TextStyle(
                                color: gray800,
                                fontSize: 14,
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
                    ChatMessageModelData.chatMessages.add(
                      ChatMessage(
                        text: controller.text,
                        isMe: true,
                        isImage: false,
                        time: '10:00 AM',
                      ),
                    );
                    controller.clear();
                    _scrollController.animateTo(
                      0.0,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 300),
                    );
                  }
                  setState(() {});
                },
                child: Container(
                  height: HeightManager.h50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: blue900,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
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
