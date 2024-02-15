// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';

class CustomIconbutton extends StatelessWidget {
  const CustomIconbutton({
    Key? key,
    required this.iconImage,
    required this.iconTitle,
    this.onTap,
  }) : super(key: key);

  final Widget iconImage;
  final String iconTitle;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: PaddingManager.paddingMedium2, vertical: PaddingManager.p10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconImage,
            const SizedBox(height: HeightManager.h12),
            Text(
              iconTitle,
              style: TextStyle(
                color: white,
                fontSize: FontSizeManager.f18,
                fontWeight: FontWeightManager.light,
                letterSpacing: 0.5,
                fontFamily: GoogleFonts.inter().fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
