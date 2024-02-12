import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/Utils/string_extension.dart';

import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/font_value.dart';


class NotificationTile extends StatelessWidget {
  const NotificationTile({
    Key? key,
    required this.index,
    required this.title,
    required this.subTitle,
    required this.notificationType,
    required this.time,
  }) : super(key: key);

  final int index;
  final String title;
  final String subTitle;
  final String notificationType;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: white,
          margin: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: index % 2 == 0 ? black : white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: black.withOpacity(0.25),
                      blurRadius: 80,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                      blurStyle: BlurStyle.outer,
                    ),
                  ],
                ),
                child: Center(
                  child: ImageIcon(
                    AssetImage(notificationIcons[notificationType] ?? notificationIcon),
                    color: index % 2 == 0 ? white : black,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.removeUnderScore(),
                      style: TextStyle(
                        color: gray800,
                        fontSize: 16,
                        fontWeight: FontWeightManager.semiBold,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subTitle,
                      style: TextStyle(
                        color: gray400,
                        fontSize: 14,
                        fontWeight: FontWeightManager.medium,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                time,
                style: TextStyle(
                    color: gray400,
                    fontSize: 14,
                    fontWeight: FontWeightManager.medium,
                    fontFamily: GoogleFonts.poppins().fontFamily),
              ),
            ],
          ),
        ),
        const Divider(
          color: gray300,
          thickness: 1,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}