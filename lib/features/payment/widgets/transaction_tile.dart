
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.id,
    required this.date,
    required this.amount,
  });

  final String id;
  final String date;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: PaddingManager.paddingMedium),
      padding: const EdgeInsets.symmetric(
        horizontal: PaddingManager.paddingMedium2,
        vertical: PaddingManager.p12,
      ),
      decoration: BoxDecoration(
          color: gray50,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: black.withOpacity(0.08),
              blurRadius: 20,
            ),
          ]),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Appointment ID',
                      style: TextStyle(
                        fontSize: FontSizeManager.f18,
                        fontWeight: FontWeightManager.semiBold,
                        color: gray800,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                      ),
                    ),
                    TextSpan(
                      text: '#$id',
                      style: TextStyle(
                        fontSize: FontSizeManager.f18,
                        fontWeight: FontWeightManager.regular,
                        color: gray400,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                  ],
                )),
                const SizedBox(height: HeightManager.h5),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: FontSizeManager.f12,
                    fontWeight: FontWeightManager.medium,
                    color: gray500,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'NRs. $amount',
            style: TextStyle(
              fontSize: FontSizeManager.f18,
              fontWeight: FontWeightManager.semiBold,
              color: gray600,
              fontFamily: GoogleFonts.poppins().fontFamily,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
