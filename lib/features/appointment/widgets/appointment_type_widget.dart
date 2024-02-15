
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';

class AppointmentTypeWidget extends StatelessWidget {
  const AppointmentTypeWidget({
    super.key,
    required this.title,
    required this.isSelected,
  });

  final String title;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: PaddingManager.paddingMedium2, vertical: PaddingManager.p10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: isSelected ? blue800 : white,
        border: Border.all(
          color: isSelected ? blue800 : gray300,
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: FontSizeManager.f16,
          fontWeight: FontWeightManager.semiBold,
          color: isSelected ? gray50 : blue800,
          fontFamily: GoogleFonts.rubik().fontFamily,
        ),
      ),
    );
  }
}
