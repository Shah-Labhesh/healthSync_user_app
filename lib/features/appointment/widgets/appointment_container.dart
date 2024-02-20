import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/Utils/string_extension.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/app_urls.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/appointment/data/model/appointment.dart';

class AppointmentTile extends StatelessWidget {
  const AppointmentTile({
    super.key,
    required this.appointment,
    required this.doctor,
  });

  final bool doctor;
  bool checkTime(String time) {
    final currentTime = DateTime.now();
    final appointmentTime = DateTime.parse(time);
    // only cancel is the appointment is 3 hours away
    return appointmentTime
        .isAfter(currentTime.subtract(const Duration(hours: 3)));
  }

  final Appointment appointment;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PaddingManager.paddingMedium2,
        vertical: PaddingManager.paddingMedium,
      ),
      margin: const EdgeInsets.only(bottom: PaddingManager.paddingMedium),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: blue50,
        boxShadow: [
          BoxShadow(
            color: black.withOpacity(0.08),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (doctor)
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: appointment.user!.avatar != null
                      ? CachedNetworkImage(
                          imageUrl: BASE_URL + appointment.user!.avatar!,
                          height: HeightManager.h80,
                          width: WidthManager.w80,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) {
                            return const Icon(
                              Icons.error,
                              color: red600,
                              size: 22,
                            );
                          },
                          progressIndicatorBuilder: (context, url, progress) {
                            return CircularProgressIndicator(
                              value: progress.progress,
                              color: red600,
                            );
                          },
                        )
                      : Image.asset(
                          AppImages.defaultAvatar,
                          height: HeightManager.h80,
                          width: WidthManager.w80,
                          fit: BoxFit.cover,
                        ),
                )
              else
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: appointment.doctor!.avatar != null
                      ? CachedNetworkImage(
                          imageUrl: BASE_URL + appointment.doctor!.avatar!,
                          height: HeightManager.h80,
                          width: WidthManager.w80,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) {
                            return const Icon(
                              Icons.error,
                              color: red600,
                              size: 22,
                            );
                          },
                          progressIndicatorBuilder: (context, url, progress) {
                            return CircularProgressIndicator(
                              value: progress.progress,
                              color: red600,
                            );
                          },
                        )
                      : Image.asset(
                          AppImages.defaultAvatar,
                          height: HeightManager.h80,
                          width: WidthManager.w80,
                          fit: BoxFit.cover,
                        ),
                ),
              const SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    doctor
                        ? appointment.user!.name!
                        : 'Dr. ${appointment.doctor!.name}',
                    style: TextStyle(
                      fontSize: FontSizeManager.f20,
                      fontWeight: FontWeightManager.bold,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      color: gray800,
                    ),
                  ),
                  if (!doctor)
                    Text(
                      appointment.doctor!.speciality ?? '-',
                      style: TextStyle(
                        fontSize: FontSizeManager.f16,
                        fontWeight: FontWeightManager.medium,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                        color: gray500,
                      ),
                    ),
                  const SizedBox(
                    height: HeightManager.h4,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: HeightManager.h16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ImageIcon(
                AssetImage(calendarIcon),
                color: green700,
                size: FontSizeManager.f22,
              ),
              const SizedBox(
                width: HeightManager.h5,
              ),
              Text(
                appointment.slot!.slotDateTime!.splitDate(),
                style: TextStyle(
                  fontSize: FontSizeManager.f14,
                  fontWeight: FontWeightManager.semiBold,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                  color: green800,
                ),
              ),
              const Spacer(),
              const ImageIcon(
                AssetImage(clockIcon),
                color: green700,
                size: FontSizeManager.f22,
              ),
              const SizedBox(
                width: HeightManager.h5,
              ),
              Text(
                appointment.slot!.slotDateTime!.splitTime(),
                style: TextStyle(
                  fontSize: FontSizeManager.f14,
                  fontWeight: FontWeightManager.semiBold,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                  color: green800,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: HeightManager.h16,
          ),
          Row(
            children: [
              if (appointment.isExpired == true)
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: PaddingManager.paddingMedium,
                      vertical: PaddingManager.paddingSmall,
                    ),
                    decoration: BoxDecoration(
                      color: blue800,
                      border: Border.all(
                        color: red600,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Rate Experience',
                      style: TextStyle(
                        fontSize: FontSizeManager.f16,
                        fontWeight: FontWeightManager.semiBold,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                        color: gray50,
                      ),
                    ),
                  ),
                )
              else
              if (appointment.payment == null && !doctor)
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: PaddingManager.paddingMedium,
                      vertical: PaddingManager.paddingSmall,
                    ),
                    decoration: BoxDecoration(
                      color: red600,
                      border: Border.all(
                        color: red600,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Pay',
                      style: TextStyle(
                        fontSize: FontSizeManager.f16,
                        fontWeight: FontWeightManager.semiBold,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                        color: red50,
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      DateTime dateTime =
                          DateTime.parse(appointment.slot!.slotDateTime!);
                      if (dateTime.isBefore(DateTime.now())) {
                        Utils.showSnackBar(
                            context, 'Appointment time has passed');
                      } else if (dateTime.isAfter(DateTime.now())) {
                        showDialog(context: context, builder: (context) {
                          return Utils.errorDialog(context, 'You can only join the appointment at the scheduled time.',onPressed: () => Navigator.pop(context),);
                        },);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: PaddingManager.paddingMedium,
                        vertical: PaddingManager.paddingSmall,
                      ),
                      decoration: BoxDecoration(
                        color: green600,
                        border: Border.all(
                          color: green600,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Join Now',
                        style: TextStyle(
                          fontSize: FontSizeManager.f16,
                          fontWeight: FontWeightManager.semiBold,
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                          color: green50,
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: HeightManager.h6),
              if (checkTime(appointment.slot!.slotDateTime!))
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: PaddingManager.paddingMedium,
                      vertical: PaddingManager.paddingSmall,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: red600,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: FontSizeManager.f16,
                        fontWeight: FontWeightManager.semiBold,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                        color: red600,
                      ),
                    ),
                  ),
                )
            ],
          )
        ],
      ),
    );
  }
}
