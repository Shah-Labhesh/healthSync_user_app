import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/app_urls.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/widgets/custom_rounded_button.dart';

class DocProfileTile extends StatelessWidget {
  const DocProfileTile({
    super.key,
    required this.doctor,
  });

  final User doctor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: PaddingManager.paddingMedium2, top: PaddingManager.paddingMedium2, bottom: PaddingManager.p50),
      decoration: const BoxDecoration(
        color: gray50,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(80),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: HeightManager.h170,
            width: WidthManager.w160,
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
                        color: red600,
                      ),
                    ),
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    AppImages.defaultAvatar,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: WidthManager.w20),
          SizedBox(
            width: WidthManager.w190,
            height: HeightManager.h170,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  doctor.name ?? '-',
                  style: TextStyle(
                      fontSize: FontSizeManager.f24,
                      fontWeight: FontWeightManager.semiBold,
                      color: gray900,
                      fontFamily: GoogleFonts.inter().fontFamily),
                      overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: HeightManager.h6),
                Text(
                  doctor.speciality ?? '-',
                  style: TextStyle(
                    fontSize: FontSizeManager.f16,
                    fontWeight: FontWeightManager.medium,
                    color: gray400,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                  ),
                ),
                const SizedBox(height: HeightManager.h12),
                Text(
                  'NRs. ${doctor.fee}',
                  style: TextStyle(
                    fontSize: FontSizeManager.f18,
                    fontWeight: FontWeightManager.semiBold,
                    color: red600,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                  ),
                ),
                const Spacer(),
                CustomButtom(
                  title: 'Book Now',
                  onPressed: () {
                    Navigator.pushNamed(context, 'book_slot', arguments: doctor);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
