import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_string.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(HeightManager.h73),
        child: AppBarCustomWithSceenTitle(
          title: 'Privacy Policy',
          isBackButton: true,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: PaddingManager.paddingMedium2,
          vertical: PaddingManager.p8,
        ),
        child: Column(
          children: [
            Text(
              AppStrings.privacyPolicyParagraph1,
              style: TextStyle(
                fontFamily: GoogleFonts.inter().fontFamily,
                fontSize: FontSizeManager.f16,
                color: gray600,
                fontWeight: FontWeightManager.medium,
              ),
            ),
            const SizedBox(
              height: HeightManager.h20,
            ),
            Text(
              AppStrings.privacyPolicyParagraph2,
              style: TextStyle(
                fontFamily: GoogleFonts.inter().fontFamily,
                fontSize: FontSizeManager.f16,
                color: gray600,
                fontWeight: FontWeightManager.medium,
              ),
            ),
            const SizedBox(
              height: HeightManager.h20,
            ),
            Text(
              AppStrings.privacyPolicyParagraph3,
              style: TextStyle(
                fontFamily: GoogleFonts.inter().fontFamily,
                fontSize: FontSizeManager.f16,
                color: gray600,
                fontWeight: FontWeightManager.medium,
              ),
            ),
            const SizedBox(
              height: HeightManager.h20,
            ),
            Text(
              AppStrings.privacyPolicyParagraph4,
              style: TextStyle(
                fontFamily: GoogleFonts.inter().fontFamily,
                fontSize: FontSizeManager.f16,
                color: gray600,
                fontWeight: FontWeightManager.medium,
              ),
            ),
            const SizedBox(
              height: HeightManager.h20,
            ),
          ],
        ),
      ),
    );
  }
}
