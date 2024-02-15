import 'package:flutter/material.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';

class NoDoctorWidget extends StatelessWidget {
  const NoDoctorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PaddingManager.paddingMedium2,
        vertical: PaddingManager.paddingMedium,
      ),
      child: Column(
        children: [
          const SizedBox(
            height: HeightManager.h20,
          ),
          Image.asset(
            AppImages.noDoctorImage,
            width: double.infinity,
          ),
          const SizedBox(
            height: HeightManager.h20,
          ),
          const Text(
            'No Doctor Found',
            style: TextStyle(
              color: gray500,
              fontWeight: FontWeightManager.medium,
            ),
          ),
        ],
      ),
    );
  }
}
