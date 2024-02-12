import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/app_urls.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/features/appointment/data/model/appointment.dart';
import 'package:user_mobile_app/features/appointment/screens/call_screen.dart';
import 'package:user_mobile_app/utils/string_extension.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

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
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  width: 10,
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
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  width: 10,
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
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
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
                          ? CachedNetworkImage(
                              imageUrl: BASE_URL + appointment.user!.avatar!,
                              progressIndicatorBuilder:
                                  (context, url, progress) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: progress.progress,
                                  ),
                                );
                              },
                              errorWidget: (context, url, error) =>
                                  const Center(
                                child: Icon(
                                  Icons.error,
                                ),
                              ),
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              AppImages.defaultAvatar,
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(
                      width: 10,
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
                  height: 16,
                ),
                ZegoSendCallInvitationButton(
                    isVideoCall: true,
                    resourceID:
                        "health_sync_zego", //You need to use the resourceID that you created in the subsequent steps. Please continue reading this document.
                    invitees: [
                      ZegoUIKitUser(
                        id: appointment.user!.id!,
                        name: appointment.user!.name!,
                      ),
                      // ...
                      // ZegoUIKitUser(
                      //    id: targetUserID,
                      //    name: targetUserName,
                      // )
                    ],
                  ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CallScreen(
                          callID: appointment.id!,
                          userId: appointment.doctor!.id!,
                          userName: appointment.doctor!.name!,
                        ),
                      ),
                    );
                  
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
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
