import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/app_urls.dart';
import 'package:user_mobile_app/constants/font_value.dart';

class RatingBarWidget extends StatelessWidget {
  const RatingBarWidget({
    Key? key,
    this.userAvatar,
    required this.userName,
    required this.rating,
    this.review,
  }) : super(key: key);

  final String? userAvatar;
  final String userName;
  final double rating;
  final String? review;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: userAvatar != null
                      ? CachedNetworkImage(
                          height: 40,
                          width: 40,
                          imageUrl: BASE_URL + userAvatar!,
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
                          height: 40,
                          width: 40,
                          AppImages.defaultAvatar,
                          fit: BoxFit.cover,
                        )),
              const SizedBox(width: 10),
              Text(
                userName,
                style: TextStyle(
                  fontSize: FontSizeManager.f18,
                  fontWeight: FontWeightManager.semiBold,
                  color: white,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          RatingBar(
            initialRating: rating,
            direction: Axis.horizontal,
            allowHalfRating: false,
            ignoreGestures: true,
            itemSize: 26,
            itemCount: 5,
            ratingWidget: RatingWidget(
              full: const ImageIcon(
                AssetImage(filledStarIcon),
                color: Colors.amber,
              ),
              half: const Icon(Icons.star_half, color: Colors.amber),
              empty: const ImageIcon(
                AssetImage(starIcon),
                color: Colors.amber,
              ),
            ),
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),
          const SizedBox(height: 10),
          if (review != null)
            Text(
              review ?? '',
              style: TextStyle(
                fontSize: FontSizeManager.f16,
                fontWeight: FontWeightManager.medium,
                color: gray300,
                fontFamily: GoogleFonts.montserrat().fontFamily,
              ),
            ),
        ],
      ),
    );
  }
}
