import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/app_urls.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/appointment/data/model/appointment.dart';
import 'package:user_mobile_app/features/appointment/screens/call_screen.dart';
import 'package:user_mobile_app/utils/string_extension.dart';

class UserAppointmentBox extends StatelessWidget {
  const UserAppointmentBox({
    super.key,
    required this.appointment,
  });

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.43,
      decoration: BoxDecoration(
        color: blue500,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: HeightManager.h20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: PaddingManager.paddingMedium2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const ImageIcon(
                  AssetImage(
                    calendarIcon,
                  ),
                  color: gray200,
                  size: 20,
                ),
                const SizedBox(
                  width: WidthManager.w10,
                ),
                Text(
                  appointment.slot!.slotDateTime!.splitDate(),
                  style: TextStyle(
                    fontSize: FontSizeManager.f14,
                    fontWeight: FontWeightManager.regular,
                    color: gray200,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: HeightManager.h12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: PaddingManager.paddingMedium2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const ImageIcon(
                  AssetImage(
                    clockIcon,
                  ),
                  color: gray200,
                  size: 20,
                ),
                const SizedBox(
                  width: WidthManager.w10,
                ),
                Text(
                  appointment.slot!.slotDateTime!.splitTime(),
                  style: TextStyle(
                    fontSize: FontSizeManager.f14,
                    fontWeight: FontWeightManager.regular,
                    color: gray200,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.43,
            padding: const EdgeInsets.symmetric(
                horizontal: PaddingManager.p6, vertical: PaddingManager.p10),
            decoration: const BoxDecoration(
              color: blue900,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: appointment.user!.avatar != null
                          ? Utils.ImageWidget(
                              BASE_URL + appointment.user!.avatar!,
                              height: HeightManager.h40,
                              width: WidthManager.w40,
                            )
                          : Image.asset(
                              AppImages.defaultAvatar,
                              height: HeightManager.h40,
                              width: WidthManager.w40,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(
                      width: WidthManager.w10,
                    ),
                    Text(
                      appointment.user!.name!,
                      style: TextStyle(
                        fontSize: FontSizeManager.f16,
                        fontWeight: FontWeightManager.bold,
                        color: gray50,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: HeightManager.h16,
                ),
                GestureDetector(
                  onTap: () {
                    if (Utils.checkInternetConnection(context)) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CallScreen(
                            appointment: appointment,
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: PaddingManager.p10,
                      vertical: PaddingManager.p4,
                    ),
                    decoration: BoxDecoration(
                      color: gray50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Join Meeting',
                      style: TextStyle(
                        fontSize: FontSizeManager.f14,
                        fontWeight: FontWeightManager.semiBold,
                        color: gray700,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
