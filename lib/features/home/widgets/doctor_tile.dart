// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/font_value.dart';

class DoctorTile extends StatelessWidget {
  const DoctorTile({
    Key? key,
    this.isFav = false,
  }) : super(key: key);

  final bool isFav;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: gray50,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 2),
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage(AppImages.doctor1),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Dr. Logan Mason',
                  style: TextStyle(
                    fontSize: FontSizeManager.f22,
                    fontWeight: FontWeightManager.semiBold,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    color: gray900,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  'Dentist',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeightManager.medium,
                    color: gray400,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const ImageIcon(
                      AssetImage(
                        filledStarIcon,
                      ),
                      size: 18,
                      color: starColor,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      '4.9 (120 Reviews)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeightManager.medium,
                        color: gray400,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: gray200,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: ImageIcon(
                    AssetImage(
                      isFav ? heartFilledIcon : heartIcon,
                    ),
                    size: 26,
                    color: isFav ? red600 : gray700,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'NRs. 500',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeightManager.semiBold,
                  color: red600,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
