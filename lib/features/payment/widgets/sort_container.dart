
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';

class SortContainer extends StatelessWidget {
  const SortContainer({
    super.key,
    required this.title,
    required this.isSelected,
  });

  final String title;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: PaddingManager.p12, right: PaddingManager.p8),
      padding: const EdgeInsets.symmetric(
        horizontal: PaddingManager.p10,
        vertical: PaddingManager.p5,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: gray200, width: 1.5),
        color: isSelected ? gray100 : white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: FontSizeManager.f14,
          fontWeight: FontWeightManager.semiBold,
          color: gray800,
          fontFamily: GoogleFonts.poppins().fontFamily,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
