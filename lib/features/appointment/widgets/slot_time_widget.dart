
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/Utils/string_extension.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/slots/data/model/slot.dart';

class SlotTimeWidget extends StatelessWidget {
  const SlotTimeWidget({
    super.key,
    required this.slot,
    required this.isSelected,
  });

  final Slots slot;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: PaddingManager.paddingMedium2, vertical: PaddingManager.p10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: slot.isBooked!
              ? gray300
              : isSelected
                  ? blue800
                  : gray300,
        ),
        color: slot.isBooked!
            ? gray100
            : isSelected
                ? blue800
                : white,
      ),
      child: Text(
        slot.slotDateTime!.splitTime().toUpperCase(),
        style: TextStyle(
          fontSize: FontSizeManager.f16,
          fontWeight: FontWeightManager.semiBold,
          color: slot.isBooked!
              ? blue800
              : isSelected
                  ? white
                  : blue800,
          fontFamily: GoogleFonts.rubik().fontFamily,
        ),
      ),
    );
  }
}
