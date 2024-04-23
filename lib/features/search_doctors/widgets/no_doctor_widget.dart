import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';

class NoDoctorWidget extends StatelessWidget {
  const NoDoctorWidget({super.key});

   @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        // horizontal: MediaQuery.of(context).size.width * 0.06,
        vertical: MediaQuery.of(context).size.width * 0.1
      ),
      child: Center(
        child: Column(
          children: [
            Image.asset(
              AppImages.noDoctorImage,
              height: HeightManager.h200,
              width: WidthManager.w200,
            ),
            const SizedBox(height: HeightManager.h50),
            Text(
              'No Doctors Found',
              style: TextStyle(
                fontSize: FontSizeManager.f22,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.inter().fontFamily,
                color: gray800,
              ),
            ),
            const SizedBox(height: HeightManager.h20),
            Text(
              'We couldn\'t find any doctors matching your search criteria. Please try adjusting your search filters or check back later.',
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