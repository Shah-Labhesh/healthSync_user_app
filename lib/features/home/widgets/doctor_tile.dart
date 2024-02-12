// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/app_urls.dart';
import 'package:user_mobile_app/constants/font_value.dart';
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
    print(BASE_URL + widget.doctor.avatar.toString());
    return InkWell(
      onTap: widget.onNavigate ??
          () {
            Navigator.pushNamed(context, 'doc_profile',
                    arguments: widget.doctor.id)
                .then((value) {
              if (value != null) {
                setState(() {
                  widget.doctor.favorite = value as bool;
                });
              }
            });
          },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
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
              Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: widget.doctor.avatar != null
                    ? CachedNetworkImage(
                        imageUrl: BASE_URL + widget.doctor.avatar!,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.error),
                        ),
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        AppImages.defaultAvatar,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(
                width: 10,
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
                      height: 3,
                    ),
                    Text(
                      widget.doctor.speciality ?? '-',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeightManager.medium,
                        color: gray400,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
                          width: 5,
                        ),
                        Text(
                          '${widget.doctor.avgRatings} (${widget.doctor.ratingCount} Reviews)',
                          style: TextStyle(
                            fontSize: 14,
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
                    height: 48,
                    width: 48,
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
                  height: 10,
                ),
                Text(
                  'NRs. ${widget.doctor.fee}',
                  style: TextStyle(
                    fontSize: 14,
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
