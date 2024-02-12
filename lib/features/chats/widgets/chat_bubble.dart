// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';

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
          margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isMe ? blue600 : Color(0xffE2E8F0),
            borderRadius: BorderRadius.only(
              topLeft: isMe ? Radius.circular(10) : Radius.circular(0),
              bottomLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomRight: isMe ? Radius.circular(0) : Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: isMe ?  CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: isMe ? white : gray800,
                  fontSize: 14,
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
                      fontSize: 12,
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
