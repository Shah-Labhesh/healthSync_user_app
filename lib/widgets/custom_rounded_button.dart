// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';

class CustomButtom extends StatelessWidget {
  const CustomButtom({
    Key? key,
    required this.title,
    this.onPressed,
    this.widget,
  }) : super(key: key);
  final Widget? widget;
  final String title;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: blue900,
          borderRadius: BorderRadius.circular(
            4,
          ),
        ),
        child: widget ??
            Text(
              title,
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: white,
                fontSize: FontSizeManager.f18,
                fontWeight: FontWeightManager.semiBold,
                letterSpacing: 0.5,
              ),
            ),
      ),
    );
  }
}
