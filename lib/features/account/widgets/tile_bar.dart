// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';

class TileBarWidget extends StatelessWidget {
  const TileBarWidget({
    Key? key,
    required this.icon,
    required this.title,
    this.onPressed,
    this.isLogout = false,
  }) : super(key: key);
  final String icon;
  final String title;
  final Function()? onPressed;
  final bool isLogout;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed ?? () {print("move to $title");},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: PaddingManager.paddingMedium),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageIcon(
              AssetImage(icon),
              color: blue900,
            ),
            const SizedBox(
              width: 22,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: FontSizeManager.f18,
                fontWeight: isLogout
                    ? FontWeightManager.semiBold
                    : FontWeightManager.regular,
                color: gray700,
                fontFamily: GoogleFonts.rubik().fontFamily,
              ),
            ),
            const Spacer(),
            if (!isLogout)
              Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.grey,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}
