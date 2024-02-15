
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';

class IconWithText extends StatelessWidget {
  const IconWithText({
    super.key,
    required this.icon,
    required this.title,
    required this.iconSize,
    required this.color,
    required this.onTap,
  });

  final String icon;
  final String title;
  final double iconSize;
  final Color color;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(PaddingManager.paddingMedium2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(AssetImage(icon), size: iconSize, color: color),
            const SizedBox(
              height: HeightManager.h8,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: FontSizeManager.f16,
                fontWeight: FontWeightManager.semiBold,
                color: color,
                fontFamily: GoogleFonts.rubik().fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
