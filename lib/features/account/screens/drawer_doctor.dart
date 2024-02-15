import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/app_urls.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/features/account/widgets/tile_bar.dart';

class DoctorDrawer extends StatelessWidget {
  const DoctorDrawer({super.key, required this.doctor});

  final User doctor;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Drawer(
      width: MediaQuery.of(context).size.width,
      child: Container(
        color: blue900,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: PaddingManager.paddingLitteLarge,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: HeightManager.h80,
              ),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50),
                    ),
                    child: doctor.avatar != null
                        ? CachedNetworkImage(
                            imageUrl: BASE_URL + doctor.avatar!,
                            progressIndicatorBuilder: (context, url, progress) {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: progress.progress,
                                ),
                              );
                            },
                            errorWidget: (context, url, error) => const Center(
                              child: Icon(
                                Icons.error,
                              ),
                            ),
                            height: HeightManager.h50,
                            width: WidthManager.w50,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            AppImages.defaultAvatar,
                            height: HeightManager.h50,
                            width: WidthManager.w50,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dr. ${doctor.name}',
                        style: TextStyle(
                          fontSize: FontSizeManager.f16,
                          fontFamily: GoogleFonts.inter().fontFamily,
                          fontWeight: FontWeightManager.semiBold,
                          color: gray50,
                        ),
                      ),
                      const SizedBox(
                        height: HeightManager.h5,
                      ),
                      SizedBox(
                        width: width * 0.6,
                        child: Row(
                          children: [
                            const Icon(
                              CupertinoIcons.mail_solid,
                              color: white,
                              size: 16,
                            ),
                            const SizedBox(
                              width: WidthManager.w5,
                            ),
                            Flexible(
                              child: Text(
                                '${doctor.email}',
                                style: TextStyle(
                                  fontSize: FontSizeManager.f14,
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                  fontWeight: FontWeightManager.medium,
                                  color: gray50,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                    child: const Icon(
                      CupertinoIcons.xmark_circle_fill,
                      color: red700,
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: HeightManager.h40,
              ),
              TileBarWidget(
                icon: dashBoardIcon,
                title: 'Dashboard',
                color: gray50,
                gap: HeightManager.h20,
                onPressed: () {
                  Navigator.pushNamed(context, 'doctor_home_screen');
                },
              ),
              TileBarWidget(
                icon: appointmentIcon,
                title: 'My Appointments',
                color: gray50,
                gap: HeightManager.h20,
                onPressed: () {
                  Navigator.pushNamed(
                      context, 'my_appointment_screen');
                },
              ),
              TileBarWidget(
                icon: recordIcon,
                title: 'Medical Records',
                color: gray50,
                gap: HeightManager.h20,
                onPressed: () {
                  Navigator.pushNamed(
                      context, 'medical_record_screen');
                },
              ),
              TileBarWidget(
                icon: paymentIcon,
                title: 'Payments',
                color: gray50,
                gap: HeightManager.h20,
                onPressed: () {
                  Navigator.pushNamed(context, 'payment_screen');
                },
              ),
              TileBarWidget(
                icon: prescriptionIcon,
                title: 'Prescriptions',
                color: gray50,
                gap: HeightManager.h20,
                onPressed: () {
                  Navigator.pushNamed(
                      context, 'prescription_screen');
                },
              ),
              TileBarWidget(
                icon: mySlotIcon,
                title: 'My Slots',
                color: gray50,
                gap: HeightManager.h20,
                onPressed: () {
                  Navigator.pushNamed(context, 'my_slots_screen');
                },
              ),
              TileBarWidget(
                icon: messageIcon,
                title: 'Messages',
                color: gray50,
                gap: HeightManager.h20,
                onPressed: () {
                  Navigator.pushNamed(context, 'chat_room_screen');
                },
              ),
              TileBarWidget(
                icon: policyIcon,
                title: 'Privacy & Policy',
                color: gray50,
                gap: HeightManager.h20,
                onPressed: () {
                  Navigator.pushNamed(
                      context, 'privacy_policy_screen');
                },
              ),
              TileBarWidget(
                icon: queryIcon,
                title: 'Contact Support',
                color: gray50,
                gap: HeightManager.h20,
                onPressed: () {
                  Navigator.pushNamed(context, 'contact_support');
                },
              ),
              TileBarWidget(
                icon: settingsIcon,
                title: 'Settings',
                color: gray50,
                gap: HeightManager.h20,
                onPressed: () {
                  Navigator.pushNamed(context, 'settings_screen',
                      arguments: doctor);
                },
              ),
              TileBarWidget(
                icon: logoutIcon,
                title: 'Logout',
                isLogout: true,
                color: gray50,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Utils().logoutDialog(context, () {
                        Navigator.pushReplacementNamed(context, 'login_screen');
                        SharedUtils.setRole('');
                        SharedUtils.setToken('');
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
