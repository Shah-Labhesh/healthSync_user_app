import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/widgets/custom_rounded_button.dart';

class RateExperienceScreen extends StatefulWidget {
  const RateExperienceScreen({super.key});

  @override
  State<RateExperienceScreen> createState() => _RateExperienceScreenState();
}

class _RateExperienceScreenState extends State<RateExperienceScreen> {

  final reviewController = TextEditingController();
  double rating = 5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: PaddingManager.paddingMedium2,
            vertical: PaddingManager.paddingMedium2,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: HeightManager.h20,
              ),
              Center(
                child: Text(
                  'RATE YOUR EXPERIENCE',
                  style: TextStyle(
                    fontSize: FontSizeManager.f22,
                    fontWeight: FontWeightManager.black,
                    color: gray900,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(
                height: HeightManager.h40,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  AppImages.doctor1,
                  height: HeightManager.h140,
                  width: WidthManager.w140,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: HeightManager.h20,
              ),
              Text(
                'Dr. John Doe',
                style: TextStyle(
                  fontSize: FontSizeManager.f22,
                  fontWeight: FontWeightManager.medium,
                  color: gray800,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),
              const SizedBox(
                height: HeightManager.h35,
              ),
              RatingBar(
                initialRating: rating,
                direction: Axis.horizontal,
                allowHalfRating: false,
                ignoreGestures: false,
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
                itemPadding: const EdgeInsets.symmetric(horizontal: PaddingManager.p10),
                onRatingUpdate: (rating) {
                  setState(() {
                    this.rating = rating;
                  });
                },
              ),
              const SizedBox(
                height: HeightManager.h45,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Write your comment here...',
                  hintStyle: TextStyle(
                    fontSize: FontSizeManager.f14,
                    fontWeight: FontWeightManager.medium,
                    color: gray500,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  fillColor: gray100,
                  filled: true,
                  enabled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                maxLines: 4,
                minLines: 4,
                controller: reviewController,
              ),
              const SizedBox(
                height: HeightManager.h30,
              ),
              Center(
                child: Text(
                  'Let Us Know Your Experience On Consulting Doctor Virtually',
                  style: TextStyle(
                    fontSize: FontSizeManager.f18,
                    fontWeight: FontWeightManager.medium,
                    color: gray400,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    letterSpacing: 0.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: HeightManager.h30,
              ),
              CustomButtom(
                title: 'Continue',
                onPressed: () {
                  print('Rating: $rating \nReview: ${reviewController.text}');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
