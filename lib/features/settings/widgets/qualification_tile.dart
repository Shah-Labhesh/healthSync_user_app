import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/Utils/string_extension.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/authentication/data/model/Qualification.dart';
import 'package:user_mobile_app/features/preview_screen/image_preview.dart';

class QualificationTile extends StatelessWidget {
  const QualificationTile({
    super.key,
    required this.qualification,
    this.onEditTap,
    this.onDeleteTap,
  });

  final DocQualification qualification;
  final Function()? onEditTap;
  final Function()? onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: PaddingManager.paddingMedium2),
      padding: const EdgeInsets.symmetric(
        horizontal: WidthManager.w20,
        vertical: HeightManager.h10,
      ),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                qualification.title ?? '-',
                style: TextStyle(
                  color: gray800,
                  fontSize: FontSizeManager.f18,
                  fontWeight: FontWeightManager.semiBold,
                  fontFamily: GoogleFonts.lato().fontFamily,
                ),
              ),
              Text(
                'Pass Out Year',
                style: TextStyle(
                  color: gray400,
                  fontSize: FontSizeManager.f16,
                  fontWeight: FontWeightManager.medium,
                  fontFamily: GoogleFonts.lato().fontFamily,
                ),
              )
            ],
          ),
          const SizedBox(height: HeightManager.h6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                qualification.institute ?? '-',
                style: TextStyle(
                  color: gray400,
                  fontSize: FontSizeManager.f14,
                  fontWeight: FontWeightManager.medium,
                  fontFamily: GoogleFonts.lato().fontFamily,
                ),
              ),
              Text(
                qualification.passOutYear!.splitDate(),
                style: TextStyle(
                  color: gray400,
                  fontSize: FontSizeManager.f14,
                  fontWeight: FontWeightManager.medium,
                  fontFamily: GoogleFonts.lato().fontFamily,
                  letterSpacing: 0.5,
                ),
              )
            ],
          ),
          const SizedBox(height: HeightManager.h8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(
                Icons.play_arrow_rounded,
                color: gray500,
                size: 18,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ImagePreviewScreen(
                      imageUrl: qualification.image!,
                    );
                  }));
                },
                child: Text(
                  'Preview Certificate',
                  style: TextStyle(
                    color: gray500,
                    fontSize: FontSizeManager.f12,
                    fontWeight: FontWeightManager.regular,
                    fontFamily: GoogleFonts.lato().fontFamily,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onEditTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: WidthManager.w10,
                    vertical: HeightManager.h8,
                  ),
                  decoration: BoxDecoration(
                    color: gray50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: gray300,
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: gray600,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onDeleteTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: WidthManager.w10,
                    vertical: HeightManager.h8,
                  ),
                  decoration: BoxDecoration(
                    color: gray50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: gray300,
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: red600,
                    size: 20,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
