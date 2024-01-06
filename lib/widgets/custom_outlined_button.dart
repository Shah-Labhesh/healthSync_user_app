import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';

class CustomOutlineButtom extends StatelessWidget {
  const CustomOutlineButtom({
    Key? key,
    required this.title,
    this.onPressed,
    this.width,
    this.widget,
  }) : super(key: key);
  final Widget? widget;
  final String title;
  final double? width;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: 50,
        padding: EdgeInsets.symmetric(horizontal:  10),
        decoration: BoxDecoration(
          border: Border.all(
            color: blue900,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(
            4,
          ),
        ),
        child: widget ??
            Text(
              title,
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: blue900,
                fontSize: FontSizeManager.f18,
                fontWeight: FontWeightManager.semiBold,
                letterSpacing: 0.5,
              ),
            ),
      ),
    );
  }
}
