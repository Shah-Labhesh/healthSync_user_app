import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/chats/widgets/chat_room_tile.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeRole();
  }

  void initializeRole() async {
    doctor = await SharedUtils.getRole() == 'DOCTOR';
    setState(() {});
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
      body: Padding(
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
                  height: 20,
                ),
              ],
              ChatRoomTileWidget(
                image: AppImages.user1,
                name: 'Toya',
                lastMessage: 'Hello, How are you?',
                time: '5 Mins ago',
              ),
              ChatRoomTileWidget(
                image: AppImages.defaultAvatar,
                name: 'Niskar',
                lastMessage:
                    'I’m here for you, don’t worry just follow the instructions I gave you.',
                time: 'Just Now',
              ),
              ChatRoomTileWidget(
                image: AppImages.doctor2,
                name: 'Dr. John Doe',
                lastMessage: 'Hello, How are you?',
                isImage: true,
                time: '10:00 AM',
              ),
              ChatRoomTileWidget(
                image: AppImages.defaultAvatar,
                name: 'Mueion',
                lastMessage:
                    'I heard about you rey@v and I’m so sorry for you. I hope you get well soon.',
                time: 'Sun 10/08/2023',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
