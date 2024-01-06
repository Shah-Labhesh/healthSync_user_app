import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';

class AppointmentWidget extends StatelessWidget {
  const AppointmentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 150,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: PaddingManager.paddingMedium,
          vertical: PaddingManager.paddingSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: const Color(0xff007BFF),
      ),
      child: Column(
        children: [
          Row(
            children: [
              
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  AppImages.doctor2,
                  height: 65,
                  width: 65,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: PaddingManager.paddingMedium2,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Prof. Dr. Logan Mason",
                    style: TextStyle(
                      fontSize: FontSizeManager.f16,
                      fontWeight: FontWeightManager.semiBold,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                      color: white,
                    ),
                  ),
                  Text(
                    "Dentist",
                    style: TextStyle(
                      fontSize: FontSizeManager.f14,
                      fontWeight: FontWeightManager.medium,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                      color: gray400,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  color: blue900,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Center(
                  child: ImageIcon(
                    AssetImage(
                      videoIcon,
                    ),
                    size: 28,
                    color: gray50,
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: PaddingManager.paddingMedium2,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: blue900,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const ImageIcon(
                  AssetImage(
                    calendarIcon,
                  ),
                  size: 28,
                  color: gray100,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  "June 12, 2023",
                  style: textTheme.bodyMedium!.copyWith(
                    fontSize: FontSizeManager.f16,
                    color: gray100,
                    letterSpacing: 0.5,
                    fontWeight: FontWeightManager.light,
                  ),
                ),
                const Spacer(),
                const ImageIcon(
                  AssetImage(
                    clockIcon,
                  ),
                  size: 28,
                  color: gray100,
                ),
                const SizedBox(
                  width: WidthManager.w12,
                ),
                Text(
                  "10:00 AM",
                  style: textTheme.bodyMedium!.copyWith(
                    fontSize: FontSizeManager.f16,
                    color: gray100,
                    letterSpacing: 0.5,
                    fontWeight: FontWeightManager.light,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
