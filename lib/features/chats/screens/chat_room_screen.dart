import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/chats/widgets/chat_room_tile.dart';
import 'package:user_mobile_app/widgets/appbar.dart';

class MyChatRoomScreen extends StatelessWidget {
  const MyChatRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: PaddingManager.paddingMedium2,
          vertical: PaddingManager.paddingSmall,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomAppBar(
                title: 'Chats',
                isBackButton: false,
                notification: true,
              ),
              const SizedBox(
                height: 20,
              ),
              ChatRoomTileWidget(
                image: AppImages.user1,
                name: 'Toya',
                lastMessage: 'Hello, How are you?',
                time: '5 Mins ago',
              ),
              ChatRoomTileWidget(
                image: AppImages.doctor2,
                name: 'Niskar',
                lastMessage: 'I’m here for you, don’t worry just follow the instructions I gave you.',
                time: 'Just Now',
              ),
              ChatRoomTileWidget(
                image: AppImages.defaultAvatar,
                name: 'Dr. John Doe',
                lastMessage: 'Hello, How are you?',
                isImage: true,
                time: '10:00 AM',
              ),
              ChatRoomTileWidget(
                image: AppImages.doctor1,
                name: 'Mueion',
                lastMessage: 'I heard about you rey@v and I’m so sorry for you. I hope you get well soon.',
                time: 'Sun 10/08/2023',
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}
