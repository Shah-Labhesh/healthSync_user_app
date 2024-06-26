import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/app_urls.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';

class PatientTileWidget extends StatelessWidget {
  const PatientTileWidget({
    super.key,
    required this.patient,
  });

  final User patient;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: gray50,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: patient.avatar != null
                ? CachedNetworkImage(
                    imageUrl: BASE_URL + patient.avatar!,
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
                    fit: BoxFit.cover,
                    height: 45,
                    width: 45,
                  )
                : Image.asset(
                    AppImages.defaultAvatar,
                    fit: BoxFit.cover,
                    height: 45,
                    width: 45,
                  ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            '${patient.name}',
            style: TextStyle(
              fontSize: FontSizeManager.f18,
              fontWeight: FontWeightManager.bold,
              color: gray700,
              fontFamily: GoogleFonts.roboto().fontFamily,
            ),
          ),
          const Spacer(),
          const Icon(
            CupertinoIcons.ellipsis,
            color: gray700,
            size: 28,
          )
        ],
      ),
    );
  }
}
