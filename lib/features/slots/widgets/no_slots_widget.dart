import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/font_value.dart';

class NoSlotsWidget extends StatelessWidget {
  const NoSlotsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.1,
        vertical: MediaQuery.of(context).size.width * 0.3
      ),
      child: Center(
        child: Column(
          children: [
            Image.asset(
              AppImages.noSlotsImage,
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 50),
            Text(
              'No Slots Found',
              style: TextStyle(
                fontSize: FontSizeManager.f22,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.inter().fontFamily,
                color: gray800,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'You can create a slot by clicking on the button below.',
              style: TextStyle(
                fontSize: FontSizeManager.f14,
                fontWeight: FontWeightManager.regular,
                fontFamily: GoogleFonts.inter().fontFamily,
                color: gray500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
