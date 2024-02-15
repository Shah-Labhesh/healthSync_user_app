// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.isMe,
    required this.text,
    required this.time,
  }) : super(key: key);

  final bool isMe;
  final String text;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
            minWidth: MediaQuery.of(context).size.width * 0.2,
          ),
          margin: const EdgeInsets.only(top: PaddingManager.p10, right: PaddingManager.p10, left: PaddingManager.p10),
          padding: const EdgeInsets.symmetric(horizontal: PaddingManager.paddingMedium2, vertical: PaddingManager.p10),
          decoration: BoxDecoration(
            color: isMe ? blue600 : const Color(0xffE2E8F0),
            borderRadius: BorderRadius.only(
              topLeft: isMe ? const Radius.circular(10) : const Radius.circular(0),
              bottomLeft: const Radius.circular(10),
              topRight:const  Radius.circular(10),
              bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: isMe ?  CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: isMe ? white : gray800,
                  fontSize: FontSizeManager.f14,
                  fontWeight: FontWeightManager.medium,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: isMe ?  MainAxisAlignment.start : MainAxisAlignment.end,
                children: [
                  Text(
                    time,
                    style: TextStyle(
                      color: isMe? white : black,
                      fontWeight: FontWeightManager.regular,
                      fontSize: FontSizeManager.f12,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
