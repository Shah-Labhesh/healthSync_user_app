// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/Utils/string_extension.dart';

import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/app_urls.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/appointment/data/model/appointment.dart';
import 'package:user_mobile_app/features/appointment/screens/call_screen.dart';

class AppointmentWidget extends StatelessWidget {
  AppointmentWidget({
    Key? key,
    required this.appointment,
  }) : super(key: key);

  final Appointment appointment;

  Map<int, String> month = {
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'May',
    6: 'Jun',
    7: 'Jul',
    8: 'Aug',
    9: 'Sep',
    10: 'Oct',
    11: 'Nov',
    12: 'Dec'
  };

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: PaddingManager.paddingMedium,
          vertical: PaddingManager.paddingMedium),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xff007BFF),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: appointment.doctor!.avatar != null
                    ? CachedNetworkImage(
                        height: HeightManager.h65,
                        width: WidthManager.w65,
                        imageUrl: BASE_URL + appointment.doctor!.avatar!,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.error),
                        ),
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        AppImages.defaultAvatar,
                        fit: BoxFit.cover,
                        height: HeightManager.h65,
                        width: WidthManager.w65,
                      ),
              ),
              const SizedBox(
                width: PaddingManager.paddingMedium2,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dr. ${appointment.doctor!.name}",
                    style: TextStyle(
                      fontSize: FontSizeManager.f16,
                      fontWeight: FontWeightManager.semiBold,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                      color: white,
                    ),
                  ),
                  Text(
                    appointment.doctor!.speciality ?? '-',
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CallScreen(
                          callID: appointment.id!,
                          userId: appointment.user!.id!,
                          userName: appointment.user!.name!,
                        ),
                      ),
                    );
                },
                child: Container(
                  height: HeightManager.h55,
                  width: WidthManager.w55,
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
              ),
            ],
          ),
          const SizedBox(
            height: PaddingManager.paddingMedium,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: PaddingManager.paddingMedium2,
              vertical: PaddingManager.p12,
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
                  width: WidthManager.w12,
                ),
                Text(
                  appointment.slot!.slotDateTime!.splitDate(),
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
                  appointment.slot!.slotDateTime!.splitTime(),
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
