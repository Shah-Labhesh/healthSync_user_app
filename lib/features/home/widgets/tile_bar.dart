// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';

class TileBarWidget extends StatelessWidget {
  const TileBarWidget({
    Key? key,
    this.more = false,
    required this.title,
    this.subTitle,
    this.padding,
  }) : super(key: key);

  final bool? more;
  final String title;
  final String? subTitle;
  final double? padding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding ?? PaddingManager.p10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: FontSizeManager.f24,
              fontWeight: FontWeightManager.extraBold,
              color: gray900,
              fontFamily: GoogleFonts.roboto().fontFamily,
              letterSpacing: 0.5,
            ),
          ),
          if (subTitle != null)
            Text(
              subTitle!,
              style: TextStyle(
                fontSize: FontSizeManager.f14,
                fontWeight: FontWeightManager.regular,
                color: gray400,
                fontFamily: GoogleFonts.roboto().fontFamily,
                letterSpacing: 0.5,
              ),
            ),
          const Spacer(),
          if (more == true)
            Text(
              'See All',
              style: TextStyle(
                fontSize: FontSizeManager.f16,
                fontWeight: FontWeightManager.bold,
                color: red600,
                fontFamily: GoogleFonts.montserrat().fontFamily,
                letterSpacing: 0.5,
              ),
            ),
        ],
      ),
    );
  }
}
