// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/font_value.dart';

class CustomIconbutton extends StatelessWidget {
  const CustomIconbutton({
    Key? key,
    required this.IconImage,
    required this.IconTitle,
    this.onTap,
  }) : super(key: key);

  final Widget IconImage;
  final String IconTitle;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconImage,
            const SizedBox(height: 12),
            Text(
              IconTitle,
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
