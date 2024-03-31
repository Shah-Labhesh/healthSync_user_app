// ignore_for_file: public_member_api_docs, sort_constructors_first
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
import 'package:user_mobile_app/features/account/data/model/user.dart';

class DoctorTile extends StatefulWidget {
  const DoctorTile({
    Key? key,
    required this.doctor,
    this.onNavigate,
    this.onPressed,
  }) : super(key: key);

  final User doctor;
  final Function()? onPressed;
  final Function()? onNavigate;

  @override
  State<DoctorTile> createState() => _DoctorTileState();
}

class _DoctorTileState extends State<DoctorTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onNavigate ??
          () {
            if (Utils.checkInternetConnection(context)) {
              Navigator.pushNamed(context, 'doc_profile',
                      arguments: widget.doctor.id)
                  .then((value) {
                if (value != null) {
                  setState(() {
                    widget.doctor.favorite = value as bool;
                  });
                }
              });
            }
          },
      child: Padding(
        padding: const EdgeInsets.only(bottom: PaddingManager.p18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
              horizontal: PaddingManager.paddingMedium2,
              vertical: PaddingManager.p10),
          decoration: BoxDecoration(
            color: gray50,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 2),
                blurStyle: BlurStyle.outer,
              ),
            ],
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    height: HeightManager.h90,
                    width: WidthManager.w90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: widget.doctor.avatar != null
                        ? Utils.ImageWidget(
                            BASE_URL + widget.doctor.avatar!,
                          )
                        : Image.asset(
                            AppImages.defaultAvatar,
                            fit: BoxFit.cover,
                          ),
                  ),
                  if (widget.doctor.popular!)
                    Positioned(
                      bottom: 5,
                      right: 3,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: blue900,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Popular',
                          style: TextStyle(
                            fontSize: FontSizeManager.f12,
                            fontWeight: FontWeightManager.medium,
                            color: white,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(
                width: WidthManager.w10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Dr. ${widget.doctor.name}',
                      style: TextStyle(
                        fontSize: FontSizeManager.f22,
                        fontWeight: FontWeightManager.semiBold,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        color: gray900,
                      ),
                    ),
                    const SizedBox(
                      height: HeightManager.h3,
                    ),
                    Text(
                      widget.doctor.speciality ?? '-',
                      style: TextStyle(
                        fontSize: FontSizeManager.f14,
                        fontWeight: FontWeightManager.medium,
                        color: gray400,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                    const SizedBox(
                      height: HeightManager.h10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const ImageIcon(
                          AssetImage(
                            filledStarIcon,
                          ),
                          size: 18,
                          color: starColor,
                        ),
                        const SizedBox(
                          width: WidthManager.w5,
                        ),
                        Text(
                          '${widget.doctor.avgRatings != null ? widget.doctor.avgRatings!.toStringAsFixed(1) : '0'} (${widget.doctor.ratingCount} Reviews)',
                          style: TextStyle(
                            fontSize: FontSizeManager.f14,
                            fontWeight: FontWeightManager.medium,
                            color: gray400,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                InkWell(
                  onTap: widget.onPressed,
                  child: Container(
                    height: HeightManager.h48,
                    width: WidthManager.w48,
                    decoration: BoxDecoration(
                      color: gray200,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: ImageIcon(
                        AssetImage(
                          widget.doctor.favorite! ? heartFilledIcon : heartIcon,
                        ),
                        size: 26,
                        color: widget.doctor.favorite! ? red600 : gray700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: HeightManager.h10,
                ),
                Text(
                  'NRs. ${widget.doctor.fee}',
                  style: TextStyle(
                    fontSize: FontSizeManager.f14,
                    fontWeight: FontWeightManager.semiBold,
                    color: red600,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
