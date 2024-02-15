
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';

class DateSlotWidget extends StatelessWidget {
  const DateSlotWidget({
    Key? key,
    required this.maintextColor,
    required this.subtextColor,
    required this.borderColor,
    required this.backgroundColor,
    required this.date,
    required this.slots,
  }) : super(key: key);

  final Color maintextColor;
  final Color subtextColor;
  final Color borderColor;
  final Color backgroundColor;
  final String date;
  final int slots;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: PaddingManager.paddingMedium2, vertical: PaddingManager.p10),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: borderColor,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Text(
            date,
            style: TextStyle(
              fontSize: FontSizeManager.f16,
              fontWeight: FontWeightManager.semiBold,
              color: maintextColor,
              fontFamily: GoogleFonts.rubik().fontFamily,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${slots > 0 ? slots : 'No'} slots available',
            style: TextStyle(
              fontSize: FontSizeManager.f14,
              fontWeight: FontWeightManager.light,
              color: subtextColor,
              fontFamily: GoogleFonts.rubik().fontFamily,
            ),
          ),
        ],
      ),
    );
  }
}
