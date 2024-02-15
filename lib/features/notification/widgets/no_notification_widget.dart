import 'package:flutter/material.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';

class NoNotificationWidget extends StatelessWidget {
  const NoNotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       
        Image.asset(
          AppImages.noNotificationImage,
          width: double.infinity,
        ),
       const SizedBox(
        height: HeightManager.h20,
       ),
        const Text(
          'You have no Notification',
          style: TextStyle(
            color: gray500,
            fontWeight: FontWeightManager.medium,
          ),
        ),
      ],
    );
  }
}
