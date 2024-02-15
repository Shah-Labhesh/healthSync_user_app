
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';

class FilterContainer extends StatelessWidget {
  const FilterContainer({
    Key? key,
    required this.title,
    required this.dropDown,
    required this.isSelected,
    this.onCancelPressed,
  }) : super(key: key);

  final String title;
  final bool dropDown;
  final bool isSelected;
  final Function()? onCancelPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: PaddingManager.p12, vertical: PaddingManager.p8),
      margin: const EdgeInsets.only(
        right: PaddingManager.p8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: isSelected ? gray100 : white,
        border: Border.all(color: gray200, width: 1.5),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: FontSizeManager.f14,
              fontWeight: FontWeightManager.semiBold,
              color: gray800,
              fontFamily: GoogleFonts.poppins().fontFamily,
              letterSpacing: 0.5,
            ),
          ),
          if (dropDown) ...[
            const SizedBox(
              width: WidthManager.w5,
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: gray800,
              size: 22,
            ),
          ],
          if (isSelected) ...[
            const SizedBox(
              width: WidthManager.w5,
            ),
            InkWell(
              onTap: onCancelPressed,
              child: const Icon(
                Icons.cancel,
                color: gray800,
                size: 22,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
