import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/Utils/string_extension.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/features/prescriptions/data/model/prescription.dart';
import 'package:user_mobile_app/features/preview_screen/image_preview.dart';
import 'package:user_mobile_app/features/preview_screen/pdf_preview.dart';

class PrescriptionTile extends StatelessWidget {
  const PrescriptionTile({
    super.key,
    required this.isDoctor,
    required this.prescription,
    required this.popupMenuItems,
  });

  final bool isDoctor;
  final Prescription prescription;
  final PopupMenuItem<dynamic> popupMenuItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 2),
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: blue600,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  prescription.createdAt!.splitDay(),
                  style: TextStyle(
                    color: white,
                    fontFamily: GoogleFonts.rubik().fontFamily,
                    fontSize: FontSizeManager.f16,
                    fontWeight: FontWeightManager.bold,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  prescription.createdAt!.splitMonth(),
                  style: TextStyle(
                    color: white,
                    fontFamily: GoogleFonts.rubik().fontFamily,
                    fontSize: FontSizeManager.f16,
                    fontWeight: FontWeightManager.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    'Prescription added ${isDoctor ? 'for' : 'by'} ${isDoctor ? prescription.user!.name! : prescription.doctor!.name!}',
                    style: TextStyle(
                      color: gray900,
                      fontFamily: GoogleFonts.lato().fontFamily,
                      fontSize: FontSizeManager.f16,
                      fontWeight: FontWeightManager.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                RichText(
                    text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${prescription.recordType} - ',
                      style: TextStyle(
                        color: gray500,
                        fontFamily: GoogleFonts.lato().fontFamily,
                        fontSize: FontSizeManager.f14,
                        fontWeight: FontWeightManager.bold,
                      ),
                    ),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          if (prescription.recordType == 'PDF') {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return PDFPreviewScreen(
                                  pdfPath: prescription.prescription!,
                                  isFromNetwork: true,
                                );
                              },
                            ));
                          }

                          if (prescription.recordType == 'IMAGE') {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return ImagePreviewScreen(
                                  imageUrl: prescription.prescription!,
                                );
                              },
                            ));
                          }
                        },
                      text: 'preview',
                      style: TextStyle(
                        color: gray500,
                        fontFamily: GoogleFonts.lato().fontFamily,
                        fontSize: FontSizeManager.f12,
                        fontWeight: FontWeightManager.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
          PopupMenuButton(
            iconSize: 22,
            iconColor: gray700,
            color: white,
            shape: ShapeBorder.lerp(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              0.5,
            ),
            offset: const Offset(-25, 25),
            itemBuilder: (context) {
              return [popupMenuItems];
            },
          ),
        ],
      ),
    );
  }
}
