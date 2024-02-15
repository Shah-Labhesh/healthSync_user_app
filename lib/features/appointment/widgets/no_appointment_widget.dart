import 'package:flutter/material.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';

class NoAppointmentWidget extends StatelessWidget {
  const NoAppointmentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       
        Image.asset(
          AppImages.noAppointmentImage,
          width: double.infinity,
          height: HeightManager.h180,
        ),
       
        const Text(
          'You have no appointment',
          style: TextStyle(
            color: gray500,
            fontWeight: FontWeightManager.medium,
          ),
        ),
      ],
    );
  }
}
