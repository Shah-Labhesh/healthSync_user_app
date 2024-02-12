import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/Utils/string_extension.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/features/medical_records/data/model/medical_record.dart';
import 'package:user_mobile_app/features/preview_screen/image_preview.dart';
import 'package:user_mobile_app/features/preview_screen/pdf_preview.dart';

class RecordTile extends StatelessWidget {
  const RecordTile({
    super.key,
    required this.records,
    required this.popupMenuItems,
  });

  final MedicalRecord records;
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
                  records.updatedAt != null
                      ? records.updatedAt!.splitDay()
                      : records.createdAt!.splitDay(),
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
                  records.updatedAt != null
                      ? records.updatedAt!.splitMonth()
                      : records.createdAt!.splitMonth(),
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
                    'Medical Record added by ${records.selfAdded! ? 'you' : records.doctor!.name!}',
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
                      text: '${records.recordType} - ',
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
                          if (records.recordType == 'PDF') {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return PDFPreviewScreen(
                                  pdfPath: records.record!,
                                  isFromNetwork: true,
                                );
                              },
                            ));
                          }

                          if (records.recordType == 'IMAGE') {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return ImagePreviewScreen(
                                  imageUrl: records.record!,
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
