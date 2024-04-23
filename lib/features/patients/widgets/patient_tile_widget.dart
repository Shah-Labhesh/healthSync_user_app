import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/app_urls.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';

class PatientTileWidget extends StatelessWidget {
  const PatientTileWidget({
    super.key,
    required this.patient,
  });

  final User patient;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'patient_view_screen', arguments: patient);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: PaddingManager.p14),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
            horizontal: PaddingManager.paddingMedium2,
            vertical: PaddingManager.p10),
        decoration: BoxDecoration(
          color: gray50,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: black.withOpacity(0.08),
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
                  ? Utils.ImageWidget(
                      BASE_URL + patient.avatar!,
                      height: HeightManager.h45,
                      width: WidthManager.w45,)
                  : Image.asset(
                      AppImages.defaultAvatar,
                      fit: BoxFit.cover,
                      height: HeightManager.h45,
                      width: WidthManager.w45,
                    ),
            ),
            const SizedBox(
              width: WidthManager.w10,
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
      ),
    );
  }
}
