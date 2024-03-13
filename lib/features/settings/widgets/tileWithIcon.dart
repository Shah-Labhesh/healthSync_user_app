import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';

class TileWithIcon extends StatelessWidget {
  const TileWithIcon({
    Key? key,
    required this.text,
    required this.icon,
    this.onTap,
    required this.color,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final Function()? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: PaddingManager.p10,
              vertical: PaddingManager.p12,
            ),
            height: HeightManager.h50,
            width: HeightManager.h50,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: white,
              size: 24,
            ),
          ),
          const SizedBox(
            width: WidthManager.w6,
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: GoogleFonts.inter().fontFamily,
                fontSize: FontSizeManager.f18,
                color: gray600,
                fontWeight: FontWeightManager.regular,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: gray400,
            size: 24,
          ),
        ],
      ),
    );
  }
}
