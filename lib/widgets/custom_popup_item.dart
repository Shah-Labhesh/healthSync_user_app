
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';

class CustomPopupItem extends StatelessWidget {
  const CustomPopupItem({
    super.key,
    required this.title,
    this.icon,
    this.onTap,
  });

  final String title;
  final IconData? icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
     return PopupMenuItem(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: gray700,
            size: 20,
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeightManager.medium,
              color: gray700,
              fontSize: 16,
              fontFamily: GoogleFonts.rubik().fontFamily,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
