import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(HeightManager.h73),
        child: AppBarCustomWithSceenTitle(
          title: 'About Us',
          isBackButton: true,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: PaddingManager.paddingMedium2,
              vertical: PaddingManager.paddingMedium2),
          child: Column(
            children: [
              Image.asset(
                APP_LOGO,
                height: HeightManager.h100,
                width: HeightManager.h100,
              ),
              const SizedBox(
                height: HeightManager.h20,
              ),
              RichText(
                  text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Health',
                    style: TextStyle(
                      fontSize: FontSizeManager.f38,
                      fontWeight: FontWeightManager.regular,
                      fontFamily: GoogleFonts.rochester().fontFamily,
                      color: green800,
                    ),
                  ),
                  TextSpan(
                    text: 'Sync',
                    style: TextStyle(
                      fontSize: FontSizeManager.f38,
                      fontWeight: FontWeightManager.regular,
                      fontFamily: GoogleFonts.rochester().fontFamily,
                      color: blue800,
                    ),
                  ),
                ],
              )),
              const SizedBox(
                height: HeightManager.h20,
              ),
              Text(
                'Health Sync is a platform that connects patients with doctors and pharmacies. It is a one-stop solution for all your healthcare needs. We are a team of highly motivated individuals who are working towards making healthcare accessible to all.',
                style: TextStyle(
                  fontSize: FontSizeManager.f16,
                  fontFamily: GoogleFonts.lato().fontFamily,
                  color: gray700,
                  fontWeight: FontWeightManager.semiBold,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: HeightManager.h20,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: PaddingManager.paddingMedium2, vertical: PaddingManager.paddingMedium2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: FontSizeManager.f18,
                fontWeight: FontWeightManager.medium,
                color: gray600,
                fontFamily: GoogleFonts.poppins().fontFamily,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: HeightManager.h36),
            Text(
              'Developed by',
              style: TextStyle(
                fontSize: FontSizeManager.f18,
                fontWeight: FontWeightManager.medium,
                color: red400,
                fontFamily: GoogleFonts.poppins().fontFamily,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: HeightManager.h5),
            Text(
              '- Mr. Shah Labhesh',
              style: TextStyle(
                fontSize: FontSizeManager.f18,
                fontWeight: FontWeightManager.bold,
                color: gray800,
                fontFamily: GoogleFonts.poppins().fontFamily,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: HeightManager.h20),
            Text(
              'Get in touch with me',
              style: TextStyle(
                fontSize: FontSizeManager.f14,
                fontWeight: FontWeightManager.regular,
                color: gray400,
                fontFamily: GoogleFonts.poppins().fontFamily,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: HeightManager.h8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  githubIcon,
                  width: WidthManager.w40,
                  height: HeightManager.h40,
                ),
                const SizedBox(width: WidthManager.w19),
                Image.asset(
                  instagramIcon,
                  width: WidthManager.w40,
                  height: HeightManager.h40,
                ),
                const SizedBox(width: WidthManager.w19),
                Image.asset(
                  linkedinIcon,
                  width: WidthManager.w60,
                  height: HeightManager.h15,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
